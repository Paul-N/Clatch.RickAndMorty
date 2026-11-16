import 'dart:convert';
//import 'dart:math';
//import 'package:clock/clock.dart';
import 'package:extension_type_unions/extension_type_unions.dart';
import 'package:http/http.dart';
import 'package:problem_details/problem_details.dart';
import 'package:pauln10v_rick_and_morty_api/service/rickandmorty_api.dart';
import '../dto/character.dart';
import '../dto/endpoints_response.dart';
import '../dto/episode.dart';
import '../dto/location.dart';
import '../dto/paged_response.dart';
import '../errors/api_errors.dart';

final class RickAndMortyRestApi implements RickAndMortyApi {
  RickAndMortyRestApi({required this._client, required String baseUrl/*, required this._clock*/})
      : _api = Uri.parse(baseUrl).replace(pathSegments: ['api']);

  final Client _client;
  final Uri _api;
  //final Clock _clock;
  Future<ApiResult<EndpointsResponse>>? _endpoints;

  @override
  Future<ApiResult<EndpointsResponse>> getEndpoints({bool force = false}) async {
    if (force) _endpoints = null;
    final pending = _endpoints ??= _get(_api, (j) => EndpointsResponse.fromJson(j));
    final result = await pending;

    if (!result.is1 && identical(_endpoints, pending)) _endpoints = null;
    return result;
  }


  // @override
  // Future<ApiResult<PagedResponse<Character>>> getCharactersByUri(Uri uri) async {
  //   if (Random().nextBool()) {
  //     return ApiException(statusCode: 0, message: 'Simulated 50% failure').u33;
  //   } return _get(uri, (j) => PagedResponse.fromJson( j, (o) => Character.fromJson(o as Map<String, dynamic>)));
  // }

  // ---- characters ----

  @override
  Future<ApiResult<PagedResponse<Character>>> getCharacters(
      {CharacterFilter? filter}) =>
      _list((e) => e.characters, filter?.toQuery(), Character.fromJson);

  @override
  Future<ApiResult<PagedResponse<Character>>> getCharactersByUri(Uri uri) =>
      _page(uri, Character.fromJson);

  @override
  Future<ApiResult<Character>> getCharacterById(int id) =>
      _byId((e) => e.characters, id, Character.fromJson);

  @override
  Future<ApiResult<Iterable<Character>>> getCharacterByIds(
      Iterable<int> ids) =>
      _byIds((e) => e.characters, ids, Character.fromJson);

  // ---- locations ----

  @override
  Future<ApiResult<PagedResponse<Location>>> getLocations(
      {LocationFilter? filter}) =>
      _list((e) => e.locations, filter?.toQuery(), Location.fromJson);

  @override
  Future<ApiResult<PagedResponse<Location>>> getLocationsByUri(Uri uri) =>
      _page(uri, Location.fromJson);

  @override
  Future<ApiResult<Location>> getLocationById(int id) =>
      _byId((e) => e.locations, id, Location.fromJson);

  @override
  Future<ApiResult<Iterable<Location>>> getLocationByIds(Iterable<int> ids) =>
      _byIds((e) => e.locations, ids, Location.fromJson);

  // ---- episodes ----

  @override
  Future<ApiResult<PagedResponse<Episode>>> getEpisodes(
      {EpisodeFilter? filter}) =>
      _list((e) => e.episodes, filter?.toQuery(), Episode.fromJson);

  @override
  Future<ApiResult<PagedResponse<Episode>>> getEpisodesByUri(Uri uri) =>
      _page(uri, Episode.fromJson);

  @override
  Future<ApiResult<Episode>> getEpisodeById(int id) =>
      _byId((e) => e.episodes, id, Episode.fromJson);

  @override
  Future<ApiResult<Iterable<Episode>>> getEpisodeByIds(Iterable<int> ids) =>
      _byIds((e) => e.episodes, ids, Episode.fromJson);

  // ---- shared helpers ----

  /// Resolves the resource endpoint from the (cached) endpoints response,
  /// or forwards the failure if the endpoints request failed.
  Future<ApiResult<T>> _withEndpoint<T>(
      Uri Function(EndpointsResponse e) pick,
      Future<ApiResult<T>> Function(Uri base) request,
      ) async {
    final e = (await getEndpoints()).value;
    if (e is! EndpointsResponse) return e as ApiResult<T>;
    return request(pick(e));
  }

  Future<ApiResult<PagedResponse<T>>> _list<T>(
      Uri Function(EndpointsResponse e) pick,
      Map<String, String>? query,
      T Function(Map<String, dynamic> json) fromJson,
      ) =>
      _withEndpoint<PagedResponse<T>>(
        pick,
            (base) => _page(
          query == null || query.isEmpty
              ? base
              : base.replace(queryParameters: query),
          fromJson,
        ),
      );

  Future<ApiResult<PagedResponse<T>>> _page<T>(
      Uri uri,
      T Function(Map<String, dynamic> json) fromJson,
      ) =>
      _get(
        uri,
            (j) => PagedResponse<T>.fromJson(
            j, (o) => fromJson(o as Map<String, dynamic>)),
      );

  Future<ApiResult<T>> _byId<T>(
      Uri Function(EndpointsResponse e) pick,
      int id,
      T Function(Map<String, dynamic> json) fromJson,
      ) =>
      _withEndpoint<T>(
        pick,
            (base) => _get(
          base.replace(pathSegments: [...base.pathSegments, '$id']),
              (j) => fromJson(j as Map<String, dynamic>),
        ),
      );

  Future<ApiResult<Iterable<T>>> _byIds<T>(
      Uri Function(EndpointsResponse e) pick,
      Iterable<int> ids,
      T Function(Map<String, dynamic> json) fromJson,
      ) async {
    if (ids.isEmpty) {
      final Iterable<T> none = const [];
      return none.u31; // /character/ would return the paged list instead
    }
    return _withEndpoint<Iterable<T>>(
      pick,
          (base) => _get<Iterable<T>>(
        base.replace(pathSegments: [...base.pathSegments, ids.join(',')]),
            (j) => switch (j) {
        // several ids -> array
          List() => [for (final o in j) fromJson(o as Map<String, dynamic>)],
        // a single id -> object, not an array
          Map<String, dynamic>() => [fromJson(j)],
          _ => throw FormatException('Unexpected JSON for ids: $j'),
        },
      ),
    );
  }

  Future<ApiResult<T>> _get<T>(Uri uri, T Function(dynamic json) parse) async {
    try {
      final response = await _client.get(uri, headers: {'Accept': 'application/json'}).timeout(const Duration(seconds: 15));
      final body = utf8.decode(response.bodyBytes);
      if (response.statusCode == 200) return parse(jsonDecode(body)).u31;
      if (response.statusCode == 429) return CloudflareTooManyRequestsError.fromResponse(response/*, _clock.now()*/).u33;
      if (response.hasProblemDetails) return ProblemDetails.fromJson(jsonDecode(body)).u32;
      return ApiResponseError.fromResponse(response).u33;
    } on Exception catch (e) {
      return ApiExceptionError.fromException(e).u33;
    }
  }
}

extension on Response {
  bool get hasProblemDetails =>
      (headers['content-type'] ?? '').startsWith('application/problem+json');
}