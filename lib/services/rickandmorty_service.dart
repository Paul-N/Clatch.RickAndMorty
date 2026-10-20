import 'dart:async';

import 'package:async/async.dart';
import 'package:extension_type_unions/extension_type_unions.dart';
import 'package:rick_and_morty/dto/character.dart';
import 'package:rick_and_morty/dto/paged_response.dart';
import 'package:rick_and_morty/model/results.dart';
import '../rest_api/rickandmorty_rest_api.dart';

typedef ServiceOperation<T> = CancelableOperation<Union2<T, Fail>>;

abstract interface class IRickAndMortyService {

  ServiceOperation<PagedResponse<Character>> getCharacters({CharacterFilter? filter});
  ServiceOperation<PagedResponse<Character>> getCharactersByUri(Uri uri);
  ServiceOperation<Character> getCharacterById(int id);
  void cancelPending();
}

final Fail _canceled = Fail.withDescription('The operation was canceled.');

extension ServiceFail on Fail {
  bool get isCanceled => identical(this, _canceled);
}

extension ServiceOperationResult<T> on ServiceOperation<T> {
  Future<Union2<T, Fail>> get result async =>
      (await valueOrCancellation(_canceled.u22))!;
}

final class RickAndMortyService implements IRickAndMortyService {
  RickAndMortyService({required this._client});

  final IRickAndMortyRestApi _client;
  CancelableOperation<Object?>? _latestList;

  @override
  ServiceOperation<PagedResponse<Character>> getCharacters({CharacterFilter? filter}) =>
      _run(() => _client.getCharacters(filter: filter), latestWins: true);

  @override
  ServiceOperation<PagedResponse<Character>> getCharactersByUri(Uri uri) =>
      _run(() => _client.getCharactersByUri(uri), latestWins: true);

  @override
  ServiceOperation<Character> getCharacterById(int id) =>
      _run(() => _client.getCharacterById(id));

  @override
  void cancelPending() => _latestList?.cancel();

  /// Canceling only stops this caller from receiving the result: the REST API
  /// has no abort hook yet, so the HTTP request itself still runs to the end.
  ServiceOperation<T> _run<T>(
      Future<ApiResult<T>> Function() call, {
        bool latestWins = false,
      }) {
    if (latestWins) _latestList?.cancel();
    final completer = CancelableCompleter<Union2<T, Fail>>();
    completer.complete(call().then((r) => _toService(r)));
    final operation = completer.operation;
    if (latestWins) _latestList = operation;
    return operation;
  }

  Union2<T, Fail> _toService<T>(ApiResult<T> result) => result.split<Union2<T, Fail>>(
        (value) => value.u21,
        (problem) => Fail.withDescription(
        problem.title ?? 'The server rejected the request.')
        .u22,
        (error) => Fail.withDescription(_describe(error)).u22,
  );

  String _describe(Exception error) => switch (error) {
    TimeoutException() => 'The request timed out.',
    _ => error.toString(),
  };
}