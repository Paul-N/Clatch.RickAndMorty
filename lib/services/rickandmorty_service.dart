import 'dart:async';

import 'package:async/async.dart';
import 'package:extension_type_unions/extension_type_unions.dart';
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
  CancelableMaybeData<PagedResponse<Character>> getCharacters({CharacterFilter? filter});
  CancelableMaybeData<PagedResponse<Character>> getCharactersByUri(Uri uri);
  CancelableMaybeData<Character> getCharacterById(int id);
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
  CancelableOperation<Object?>? _latestList;

  @override
  CancelableMaybeData<PagedResponse<Character>> getCharacters({CharacterFilter? filter}) =>
      _run(() => _client.getCharacters(filter: filter), latestWins: true);

  @override
  CancelableMaybeData<PagedResponse<Character>> getCharactersByUri(Uri uri) =>
      _run(() => _client.getCharactersByUri(uri), latestWins: true);

  @override
  CancelableMaybeData<Character> getCharacterById(int id) =>
      _run(() => _client.getCharacterById(id));

  @override
  void cancelPending() => _latestList?.cancel();

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
    CloudflareTooManyRequestsError() => _describeTooManyRequests(error),
    ApiResponseError apiExc => _describeApiException(apiExc)
  };

  String _describeApiException(ApiResponseError error) {
    if (error.oneLineError != null) {
      return error.oneLineError!;
    } else {
      return error.toString();
    }
  }

  String _describeTooManyRequests(CloudflareTooManyRequestsError tooManyRequests)
    => tooManyRequests.details?.split((pd) => pd.detail, (str) => str) ?? "Too many requests.";
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