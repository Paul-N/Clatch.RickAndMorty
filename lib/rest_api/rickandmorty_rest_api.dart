import 'dart:convert';
import 'dart:math';
import 'package:extension_type_unions/extension_type_unions.dart';
import 'package:http/http.dart';
import 'package:problem_details/problem_details.dart';
import 'package:rick_and_morty/dto/endpoints_response.dart';
import 'package:rick_and_morty/dto/paged_response.dart';
import 'package:rick_and_morty/dto/character.dart';
import 'api_exception.dart';

typedef ApiResult<T> = Union3<T, ProblemDetails, Exception>;

abstract interface class IRickAndMortyRestApi {
  Future<ApiResult<EndpointsResponse>> getEndpoints({bool force = false});
  Future<ApiResult<PagedResponse<Character>>> getCharacters({CharacterFilter? filter});
  Future<ApiResult<PagedResponse<Character>>> getCharactersByUri(Uri uri);
  Future<ApiResult<Character>> getCharacterById(int id);
}

final class RickAndMortyRestApi implements IRickAndMortyRestApi {
  RickAndMortyRestApi({required this._client, required String baseUrl})
      : _api = Uri.parse(baseUrl).replace(pathSegments: ['api']);

  final Client _client;
  final Uri _api;
  Future<ApiResult<EndpointsResponse>>? _endpoints;

  @override
  Future<ApiResult<EndpointsResponse>> getEndpoints({bool force = false}) async {
    if (force) _endpoints = null;
    final pending = _endpoints ??= _get(_api, (j) => EndpointsResponse.fromJson(j));
    final result = await pending;

    if (!result.is1 && identical(_endpoints, pending)) _endpoints = null;
    return result;
  }

  @override
  Future<ApiResult<PagedResponse<Character>>> getCharacters({CharacterFilter? filter}) async {
    final e = (await getEndpoints()).value;
    if (e is! EndpointsResponse) return e as ApiResult<PagedResponse<Character>>;

    final query = filter?.toQuery();
    return getCharactersByUri(
      query == null || query.isEmpty
          ? e.characters
          : e.characters.replace(queryParameters: query),
    );
  }

  //@override
  // Future<ApiResult<PagedResponse<Character>>> getCharactersByUri(Uri uri) =>
  //     _get(uri, (j) => PagedResponse<Character>.fromJson(
  //         j, (o) => Character.fromJson(o as Map<String, dynamic>)));

  @override
  Future<ApiResult<PagedResponse<Character>>> getCharactersByUri(Uri uri) async {
    if (Random().nextBool()) {
      return ApiException(statusCode: 0, message: 'Simulated 50% failure').u33;
    } return _get(uri, (j) => PagedResponse.fromJson( j, (o) => Character.fromJson(o as Map<String, dynamic>)));
  }

  @override
  Future<ApiResult<Character>> getCharacterById(int id) async {
    final e = (await getEndpoints()).value;
    if (e is! EndpointsResponse) return e as ApiResult<Character>;

    final uri = e.characters;
    return _get(
      uri.replace(pathSegments: [...uri.pathSegments, '$id']),
          (j) => Character.fromJson(j),
    );
  }

  Future<ApiResult<T>> _get<T>(Uri uri, T Function(dynamic json) parse) async {
    try {
      final response = await _client.get(uri).timeout(const Duration(seconds: 15));
      final body = utf8.decode(response.bodyBytes);
      if (response.statusCode == 200) return parse(jsonDecode(body)).u31;
      //if (response.statusCode >= 400 && response.statusCode <= 499 && ) return Exception('Not found').u33;
      if (response.hasProblemDetails) return ProblemDetails.fromJson(jsonDecode(body)).u32;
      return ApiException.fromResponse(response).u33;
    } on Exception catch (e) {
      return e.u33;
    }
  }
}

extension on Response {
  bool get hasProblemDetails =>
      (headers['content-type'] ?? '').startsWith('application/problem+json');
}