import 'dart:async';

import 'package:async/async.dart';
import 'package:extension_type_unions/extension_type_unions.dart';
import 'package:rick_and_morty/cache/ttl_cache.dart';
import 'package:rick_and_morty/dto/character.dart';
import 'package:rick_and_morty/dto/paged_response.dart';
import 'package:rick_and_morty/model/results.dart';
import 'package:rick_and_morty/rest_api/api_errors.dart';

import '../infrastructure/rickandmorty_rest_api.dart';

typedef MaybeSuccess = Union3<Success, NotFound, Fail>;
typedef MaybeData<T> = Union3<Data<T>, NotFound, Fail>;
typedef CancelableMaybeData<T> = CancelableOperation<MaybeData<T>>;
typedef CancelableMaybeSuccess = CancelableOperation<MaybeSuccess>;

abstract interface class IRickAndMortyService {
  CancelableMaybeData<PagedResponse<Character>> getCharacters({
    CharacterFilter? filter,
    bool refresh = false,
  });
  CancelableMaybeData<PagedResponse<Character>> getCharactersByUri(
    Uri uri, {
    bool refresh = false,
  });
  CancelableMaybeData<Character> getCharacterById(
    int id, {
    bool refresh = false,
  });
  void cancelPending();
}

final Fail _canceled = Fail.withDescription('The operation was canceled.');

extension ServiceFail on Fail {
  bool get isCanceled => identical(this, _canceled);
}

extension ServiceOperationResult<T> on CancelableMaybeData<T> {
  Future<MaybeData<T>> get result async =>
      (await valueOrCancellation(_canceled.u33))!;
}

final class RickAndMortyService implements IRickAndMortyService {
  RickAndMortyService({required this._client});

  final IRickAndMortyRestApi _client;
  final TtlCache<String> _cache = TtlCache(maxEntries: 200);
  CancelableOperation<Object?>? _latestList;

  static const _listTtl = Duration(minutes: 15);
  static const _characterTtl = Duration(hours: 1);

  @override
  CancelableMaybeData<PagedResponse<Character>> getCharacters({
    CharacterFilter? filter,
    bool refresh = false,
  }) => _run(
    () {
      final query = filter?.toQuery() ?? const <String, String>{};
      final entries = query.entries.toList()
        ..sort((a, b) => a.key.compareTo(b.key));
      final key = 'characters:${Uri(queryParameters: Map.fromEntries(entries))}';
      return _cached(
        key,
        () => _client.getCharacters(filter: filter),
        ttl: _listTtl,
        refresh: refresh,
      );
    },
    latestWins: true,
  );

  @override
  CancelableMaybeData<PagedResponse<Character>> getCharactersByUri(
    Uri uri, {
    bool refresh = false,
  }) => _run(
    () => _cached(
      'characters:$uri',
      () => _client.getCharactersByUri(uri),
      ttl: _listTtl,
      refresh: refresh,
    ),
    latestWins: true,
  );

  @override
  CancelableMaybeData<Character> getCharacterById(
    int id, {
    bool refresh = false,
  }) => _run(
    () => _cached(
      'character:$id',
      () => _client.getCharacterById(id),
      ttl: _characterTtl,
      refresh: refresh,
    ),
  );

  @override
  void cancelPending() => _latestList?.cancel();

  Future<ApiResult<T>> _cached<T>(
    String key,
    Future<ApiResult<T>> Function() load, {
    required Duration ttl,
    required bool refresh,
  }) => _cache.fetch<ApiResult<T>>(
    key,
    load,
    ttl: ttl,
    refresh: refresh,
    cacheable: (result) => result.is1,
  );

  /// Canceling only stops this caller from receiving the result: the REST API
  /// has no abort hook yet, so the HTTP request itself still runs to the end.
  CancelableMaybeData<T> _run<T>(
    Future<ApiResult<T>> Function() call, {
    bool latestWins = false,
  }) {
    if (latestWins) _latestList?.cancel();
    final completer = CancelableCompleter<MaybeData<T>>();
    completer.complete(call().then((r) => _toService(r)));
    final operation = completer.operation;
    if (latestWins) _latestList = operation;
    return operation;
  }

  MaybeData<T> _toService<T>(ApiResult<T> result) => result.split<MaybeData<T>>(
    (value) => Data(value).u31,
    (problem) => Fail.withDescription(
      problem.title ?? 'The server rejected the request.',
    ).u33,
    (error) {
      if (error is ApiResponseError) {
        if (error.statusCode == 404) {
          return error.oneLineError != null
              ? NotFound.withDescription(error.oneLineError!).u32
              : NotFound().u32;
        } else {
          return Fail.withDescription(_describeApiException(error)).u33;
        }
      }
      return Fail.withDescription(_describe(error)).u33;
    },
  );

  String _describe(ApiError error) => switch (error) {
    ApiExceptionError() when error.exception is TimeoutException => 'The request timed out.',
    ApiExceptionError() => error.exception.toString(),
    ApiResponseError apiExc => _describeApiException(apiExc),
    _ => error.toString(),
  };

  String _describeApiException(ApiResponseError error) {
    if (error.oneLineError != null) {
      return error.oneLineError!;
    } else {
      return error.toString();
    }
  }
}

extension on ApiResponseError {
  String? get oneLineError {
    if (body?.is1 == true && body!.as1.keys.contains('error')) {
      return body!.as1['error'];
    } else if (body?.is3 == true) {
      return body!.as3;
    } else if (body == null) {
      return message;
    } else {
      return null;
    }
  }
}
