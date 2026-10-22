import 'dart:async';
import 'dart:collection';
import 'dart:math';

import 'package:http/http.dart';

import '../rest_api/api_errors.dart';
import '../rest_api/low_priority.dart'; // CloudflareTooManyRequestsError

enum RequestPriority { high, low }

/// The server is rate limiting us and this request can not (or should not) wait
/// until [retryAt].
final class RateLimitedException implements Exception {
  const RateLimitedException(this.retryAt);

  final DateTime retryAt;

  Duration get remaining {
    final left = retryAt.difference(DateTime.now());
    return left.isNegative ? Duration.zero : left;
  }

  @override
  String toString() => 'RateLimitedException: try again in ${remaining.inSeconds}s';
}

/// Throttles every request that goes through it.
///
///  * **Priority:** JSON (default) is always dispatched before images
///    ([lowPriorityHeaders]). Images may use at most
///    `maxConcurrent - reservedForHigh` slots, so a JSON request never waits for
///    an image that is already in flight.
///  * **Spacing:** request *starts* are at least the current interval apart
///    (rate limits count starts, not finished requests).
///  * **429:** the whole client pauses for `Retry-After` (header first, then the
///    Cloudflare body, see [CloudflareTooManyRequestsError.retryAfter]). The
///    pause doubles when a probe after it gets another 429, and the spacing
///    doubles too, easing back after [recoverAfter] successes.
///    A request that can wait that long is retried first in line; otherwise it
///    fails with [RateLimitedException]. JSON may wait at most [maxWait], images
///    up to [lowMaxWait] (the UI shows a waiting indicator meanwhile).
///  * **Abort:** a queued request with an `abortTrigger` is dropped without ever
///    being sent. [close] fails everything still queued.
///
/// Put it above the native client (Cronet/Cupertino): it also counts requests
/// that the native HTTP cache answers, because that can't be told up front.
final class ThrottledHttpClient extends BaseClient {
  ThrottledHttpClient(
      this._inner, {
        this.maxConcurrent = 4,
        this.reservedForHigh = 1,
        this.minInterval = const Duration(milliseconds: 200),
        this.maxInterval = const Duration(seconds: 2),
        this.recoverAfter = 20,
        this.defaultPause = const Duration(seconds: 30),
        this.maxPause = const Duration(minutes: 10),
        this.maxWait = const Duration(seconds: 10),
        this.lowMaxWait = const Duration(minutes: 2),
        this.maxRetries = 3,
      }) : _interval = minInterval;

  final Client _inner;
  final int maxConcurrent;
  final int reservedForHigh;
  final Duration minInterval;
  final Duration maxInterval;
  final int recoverAfter;
  final Duration defaultPause;
  final Duration maxPause;
  final Duration maxWait;
  final Duration lowMaxWait;
  final int maxRetries;

  final _high = Queue<_Job>();
  final _low = Queue<_Job>();
  var _inFlight = 0;
  var _closed = false;
  Duration _interval;
  var _successes = 0;
  var _strikes = 0;
  var _nextStart = DateTime.fromMillisecondsSinceEpoch(0);
  DateTime? _pausedUntil;
  Timer? _wake;

  @override
  Future<StreamedResponse> send(BaseRequest request) {
    if (_closed) {
      return Future.error(ClientException('The client is closed', request.url));
    }

    final priority = request.headers.remove(requestPriorityHeader) == 'low'
        ? RequestPriority.low
        : RequestPriority.high;

    // Don't queue what could not be sent within its patience anyway.
    if (_remainingPause() > _maxWaitFor(priority)) {
      return Future.error(RateLimitedException(_pausedUntil!));
    }

    final job = _Job(request, priority);
    _queueFor(priority).add(job);

    final abortTrigger = request is Abortable ? request.abortTrigger : null;
    abortTrigger?.then((_) {
      if (_queueFor(priority).remove(job)) {
        job.completer.completeError(RequestAbortedException(request.url));
      }
    });

    _pump();
    return job.completer.future;
  }

  /// Starts as many queued requests as the limits allow, otherwise sleeps until
  /// the earliest moment one may start.
  void _pump() {
    _wake?.cancel();
    _wake = null;

    while (!_closed) {
      final job = _nextJob();
      if (job == null) return;

      final now = DateTime.now();
      final pausedUntil = _pausedUntil;
      final readyAt = pausedUntil != null && pausedUntil.isAfter(_nextStart)
          ? pausedUntil
          : _nextStart;
      if (readyAt.isAfter(now)) {
        _wake = Timer(readyAt.difference(now), _pump);
        return;
      }

      _queueFor(job.priority).removeFirst();
      _inFlight++;
      _nextStart = now.add(_interval);
      unawaited(_run(job));
    }
  }

  /// Strict priority: images only get a turn when no JSON request is waiting.
  _Job? _nextJob() {
    if (_high.isNotEmpty) return _inFlight < maxConcurrent ? _high.first : null;
    if (_low.isNotEmpty) {
      return _inFlight < max(1, maxConcurrent - reservedForHigh) ? _low.first : null;
    }
    return null;
  }

  Future<void> _run(_Job job) async {
    try {
      final request = job.attempt == 0 ? job.request : _copy(job.request);
      final response = await _inner.send(request);
      if (response.statusCode == 429) {
        await _onRateLimited(job, response);
      } else {
        _onSuccess();
        job.completer.complete(response);
      }
    } catch (error, stack) {
      job.completer.completeError(error, stack);
    } finally {
      _inFlight--;
      _pump();
    }
  }

  Future<void> _onRateLimited(_Job job, StreamedResponse streamed) async {
    // A 429 body is small; buffer it to read the Cloudflare hint.
    final error = CloudflareTooManyRequestsError.fromResponse(await Response.fromStream(streamed));
    final hint = error.retryAfter(fallback: defaultPause);

    final now = DateTime.now();
    final current = _pausedUntil;
    // Only a request sent after the previous pause ended is a new strike:
    // stragglers that were already in flight must not escalate the backoff.
    if (current == null || !now.isBefore(current)) _strikes++;
    var pause = hint * (1 << min(_strikes - 1, 6));
    if (pause > maxPause) pause = hint > maxPause ? hint : maxPause;

    final resumeAt = now.add(pause);
    if (current == null || resumeAt.isAfter(current)) _pausedUntil = resumeAt;
    final resume = _pausedUntil!;

    _interval = _interval * 2 > maxInterval ? maxInterval : _interval * 2;
    _successes = 0;

    final replayable = job.request.method == 'GET' || job.request.method == 'HEAD';
    if (replayable &&
        job.attempt < maxRetries &&
        resume.difference(now) <= _maxWaitFor(job.priority)) {
      job.attempt++;
      _queueFor(job.priority).addFirst(job); // retried first, so JSON stays ASAP
    } else {
      job.completer.completeError(RateLimitedException(resume));
    }
    _failWaiting();
  }

  void _onSuccess() {
    _strikes = 0;
    if (_interval > minInterval && ++_successes >= recoverAfter) {
      final eased = _interval ~/ 2;
      _interval = eased < minInterval ? minInterval : eased;
      _successes = 0;
    }
  }

  /// Fails queued requests that would have to wait longer than they may.
  void _failWaiting() {
    final until = _pausedUntil;
    if (until == null) return;
    final remaining = until.difference(DateTime.now());
    for (final priority in RequestPriority.values) {
      if (remaining <= _maxWaitFor(priority)) continue;
      final queue = _queueFor(priority);
      for (final job in queue) {
        job.completer.completeError(RateLimitedException(until));
      }
      queue.clear();
    }
  }

  Duration _remainingPause() {
    final until = _pausedUntil;
    if (until == null) return Duration.zero;
    final left = until.difference(DateTime.now());
    return left.isNegative ? Duration.zero : left;
  }

  Duration _maxWaitFor(RequestPriority priority) =>
      priority == RequestPriority.high ? maxWait : lowMaxWait;

  Queue<_Job> _queueFor(RequestPriority priority) =>
      priority == RequestPriority.high ? _high : _low;

  /// A request can only be sent once, so retries send a copy (GET/HEAD: no body).
  BaseRequest _copy(BaseRequest r) => AbortableRequest(
    r.method,
    r.url,
    abortTrigger: r is Abortable ? r.abortTrigger : null,
  )..headers.addAll(r.headers);

  @override
  void close() {
    _closed = true;
    _wake?.cancel();
    for (final queue in [_high, _low]) {
      for (final job in queue) {
        job.completer.completeError(ClientException('The client was closed', job.request.url));
      }
      queue.clear();
    }
    _inner.close();
  }
}

final class _Job {
  _Job(this.request, this.priority);

  final BaseRequest request;
  final RequestPriority priority;
  final completer = Completer<StreamedResponse>();
  var attempt = 0;
}