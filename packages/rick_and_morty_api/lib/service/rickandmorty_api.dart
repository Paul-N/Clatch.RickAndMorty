import 'package:extension_type_unions/extension_type_unions.dart';
import 'package:problem_details/problem_details.dart';
import '../dto/character.dart';
import '../dto/endpoints_response.dart';
import '../dto/episode.dart';
import '../dto/location.dart';
import '../dto/paged_response.dart';
import '../errors/api_errors.dart';

typedef ApiResult<T> = Union3<T, ProblemDetails, ApiError>;

abstract interface class RickAndMortyApi {
  Future<ApiResult<EndpointsResponse>> getEndpoints({bool force = false});

  Future<ApiResult<PagedResponse<Character>>> getCharacters({CharacterFilter? filter});
  Future<ApiResult<PagedResponse<Character>>> getCharactersByUri(Uri uri);
  Future<ApiResult<Character>> getCharacterById(int id);
  Future<ApiResult<Iterable<Character>>> getCharacterByIds(Iterable<int> ids);

  Future<ApiResult<PagedResponse<Location>>> getLocations({LocationFilter? filter});
  Future<ApiResult<PagedResponse<Location>>> getLocationsByUri(Uri uri);
  Future<ApiResult<Location>> getLocationById(int id);
  Future<ApiResult<Iterable<Location>>> getLocationByIds(Iterable<int> ids);

  Future<ApiResult<PagedResponse<Episode>>> getEpisodes({EpisodeFilter? filter});
  Future<ApiResult<PagedResponse<Episode>>> getEpisodesByUri(Uri uri);
  Future<ApiResult<Episode>> getEpisodeById(int id);
  Future<ApiResult<Iterable<Episode>>> getEpisodeByIds(Iterable<int> ids);
}