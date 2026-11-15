import 'package:extension_type_unions/extension_type_unions.dart';
import 'package:problem_details/problem_details.dart';
import '../dto/character.dart';
import '../dto/endpoints_response.dart';
import '../dto/paged_response.dart';
import '../errors/api_errors.dart';

typedef ApiResult<T> = Union3<T, ProblemDetails, ApiError>;

abstract interface class IRickAndMortyRestApi {
  Future<ApiResult<EndpointsResponse>> getEndpoints({bool force = false});
  Future<ApiResult<PagedResponse<Character>>> getCharacters({CharacterFilter? filter});
  Future<ApiResult<PagedResponse<Character>>> getCharactersByUri(Uri uri);
  Future<ApiResult<Character>> getCharacterById(int id);
}