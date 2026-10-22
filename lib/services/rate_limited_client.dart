import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:http/http.dart' as http;

import '../rest_api/api_errors.dart';
import '../rest_api/too_many_requests.dart';

/// Shares a 429 cooldown across requests and retries safe GET/HEAD requests
/// only when the server's requested wait fits within [maxAutomaticRetryDelay].
/// Longer cooldowns are returned locally as 429s instead of queuing a request
/// that may outlive the caller's timeout.
final class RateLimitedClient extends http.BaseClient {
  RateLimitedClient(
    this._inner, {
    this.maxRetries = 1,
    this.maxAutomaticRetryDelay = const Duration(seconds: 5),
    this.fallbackDelay = const Duration(seconds: 30),
    this.maxFallbackDelay = const Duration(minutes: 2),
    DateTime Function()? now,
    Future<void> Function(Duration)? sleep,
    double Function()? random,
  }) : _now = now ?? DateTime.now,
       _sleep = sleep ?? Future<void>.delayed,
       _random = random ?? Random().nextDouble;

  final http.Client _inner;
  final DateTime Function() _now;
  final Future<void> Function(Duration) _sleep;
  final double Function() _random;
  final int maxRetries;
  final Duration maxAutomaticRetryDelay;
  final Duration fallbackDelay;
  final Duration maxFallbackDelay;

  DateTime? _cooldownUntil;

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) async {
    final retryTemplate = _retryTemplate(request);
    var retries = 0;

    while (true) {
      final blocked = await _waitForCooldown(request);
      if (blocked != null) return blocked;
      final outgoing = retryTemplate == null
          ? request
          : _copyRequest(retryTemplate);
      final response = await _inner.send(outgoing);
      if (response.statusCode != 429) return response;

      final bytes = await response.stream.toBytes();
      final body = utf8.decode(bytes, allowMalformed: true);
      final error = CloudflareTooManyRequestsError.fromResponse(
        http.Response(
          body,
          response.statusCode,
          headers: response.headers,
          request: response.request,
          reasonPhrase: response.reasonPhrase,
        ),
      );
      final delay = _retryDelay(error, retries);
      _extendCooldown(delay);

      final canRetry =
          retryTemplate != null &&
          retries < maxRetries &&
          delay <= maxAutomaticRetryDelay;
      if (!canRetry) return _withBody(response, bytes);

      retries++;
    }
  }

  http.Request? _retryTemplate(http.BaseRequest request) {
    if (request is! http.Request ||
        (request.method != 'GET' && request.method != 'HEAD') ||
        request.bodyBytes.isNotEmpty) {
      return null;
    }
    return _copyRequest(request);
  }

  http.Request _copyRequest(http.Request source) =>
      http.Request(source.method, source.url)
        ..headers.addAll(source.headers)
        ..followRedirects = source.followRedirects
        ..maxRedirects = source.maxRedirects
        ..persistentConnection = source.persistentConnection;

  Duration _retryDelay(CloudflareTooManyRequestsError error, int retries) {
    final serverDelay =
        error.headers.retryAfter ?? error.cloudflareProblemDetails?.retryAfter;
    if (serverDelay != null) {
      return serverDelay.isNegative ? Duration.zero : serverDelay;
    }

    final exponentialMs =
        fallbackDelay.inMilliseconds * pow(2, retries).toInt();
    final boundedMs = min(exponentialMs, maxFallbackDelay.inMilliseconds);
    final jitteredMs = boundedMs * (0.5 + _random());
    return Duration(milliseconds: jitteredMs.round());
  }

  void _extendCooldown(Duration delay) {
    final deadline = _now().add(delay);
    if (_cooldownUntil == null || deadline.isAfter(_cooldownUntil!)) {
      _cooldownUntil = deadline;
    }
  }

  Future<http.StreamedResponse?> _waitForCooldown(
    http.BaseRequest request,
  ) async {
    while (true) {
      final until = _cooldownUntil;
      if (until == null) return null;
      final remaining = until.difference(_now());
      if (remaining <= Duration.zero) {
        _cooldownUntil = null;
        return null;
      }
      if (remaining > maxAutomaticRetryDelay) {
        return _localRateLimitResponse(request, remaining);
      }
      await _sleep(remaining);
    }
  }

  http.StreamedResponse _localRateLimitResponse(
    http.BaseRequest request,
    Duration retryAfter,
  ) {
    final seconds = (retryAfter.inMilliseconds / 1000).ceil();
    final body = utf8.encode(
      jsonEncode({
        'status': 429,
        'error': 'Rate-limit cooldown is active.',
        'retry_after': seconds,
      }),
    );
    return http.StreamedResponse(
      Stream<List<int>>.value(body),
      429,
      contentLength: body.length,
      request: request,
      headers: {
        'cache-control': 'no-store',
        'content-type': 'application/json; charset=utf-8',
        'retry-after': '$seconds',
        'x-app-rate-limit': 'cooldown',
      },
      reasonPhrase: 'Too Many Requests',
    );
  }

  http.StreamedResponse _withBody(
    http.StreamedResponse response,
    List<int> bytes,
  ) => http.StreamedResponse(
    Stream<List<int>>.value(bytes),
    response.statusCode,
    contentLength: bytes.length,
    request: response.request,
    headers: response.headers,
    isRedirect: response.isRedirect,
    persistentConnection: response.persistentConnection,
    reasonPhrase: response.reasonPhrase,
  );

  @override
  void close() {
    _inner.close();
    super.close();
  }
}
