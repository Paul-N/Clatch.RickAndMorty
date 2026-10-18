import 'dart:convert';
import 'dart:io';

import 'package:extension_type_unions/extension_type_unions.dart';
import 'package:http/http.dart';
import 'package:problem_details/problem_details.dart';
import 'package:rick_and_morty/dto/endpoints_response.dart';
import 'package:rick_and_morty/dto/paged_response.dart';
import 'package:rick_and_morty/dto/character.dart';
import 'package:rick_and_morty/model/results.dart';
import 'api_exception.dart';

abstract interface class IRickAndMortyRestApi {
  Future<Union3<EndpointsResponse, ProblemDetails, Exception>> getEndpoints();
  Future<Union3<PagedResponse<Character>, ProblemDetails, Exception>> getCharacters({CharacterFilter? filter});
  Future<Union3<PagedResponse<Character>, ProblemDetails, Exception>> getCharactersByUri(Uri uri);
  Future<Union3<Character, ProblemDetails, Exception>> getCharacterById(int id);
}

final class RickAndMortyRestApi implements IRickAndMortyRestApi {
  final String _baseUrl;
  final Client _client;
  late final EndpointsResponse? _endpoints;

  RickAndMortyRestApi({required Client client, required String baseUrl}):
        _client = client,
        _baseUrl = baseUrl;

  @override
  Future<Union3<EndpointsResponse, ProblemDetails, Exception>> getEndpoints() async {
    final underlined = await _obtainEndpoints();
    return underlined.split((success) => _endpoints!.u31, (pb) => pb.u32, (exc) => exc.u33);
  }

  Future<Union3<Success, ProblemDetails, Exception>> _obtainEndpoints({bool force = false}) async {
    try {
      final uri = Uri.parse(_baseUrl).replace(pathSegments: ['api']);
      final response = await _client.get(uri);

      if (response.statusCode == 200) {
        _endpoints = EndpointsResponse.fromJson(jsonDecode(response.body));
        return Success().u31;
      } else if (response.hasProblemDetails) {
        return ProblemDetails.fromJson(jsonDecode(response.body)).u32;
      } else {
        return ApiException.fromResponse(response).u33;
      }
    } on Exception catch (error) {
      return error.u33;
    }
  }

  @override
  Future<Union3<PagedResponse<Character>, ProblemDetails, Exception>> getCharacters({CharacterFilter? filter}) async {
    final res1 = await _obtainEndpoints();
    if(!res1.is1){
      return res1.value as Union3<PagedResponse<Character>, ProblemDetails, Exception>;
    }

    if(filter == null) {
      return getCharactersByUri(_endpoints!.characters);
    } else {
      var filterUri = _endpoints!.characters.replace(queryParameters: filter.toQuery());
      return getCharactersByUri(filterUri);
    }
  }

  @override
  Future<Union3<PagedResponse<Character>, ProblemDetails, Exception>> getCharactersByUri(Uri uri) async {
    try {
      final response = await _client.get(uri);
      if (response.statusCode == 200) {
        return PagedResponse<Character>.fromJson(jsonDecode(response.body), (o) => Character.fromJson(o as Map<String, dynamic>)).u31;
      } else if (response.hasProblemDetails) {
        return ProblemDetails.fromJson(jsonDecode(response.body)).u32;
      } else {
        return ApiException.fromResponse(response).u33;
      }
    } on Exception catch (error) {
      return error.u33;
    }
  }

  @override
  Future<Union3<Character, ProblemDetails, Exception>> getCharacterById(int id) async {
    final res1 = await _obtainEndpoints();
    if(!res1.is1){
      return res1.value as Union3<Character, ProblemDetails, Exception>;
    }

    try {
      final uri = _endpoints!.characters;
      final response = await _client.get(uri.replace(pathSegments: uri.pathSegments + [id.toString()]));
      if (response.statusCode == 200) {
        return Character.fromJson(jsonDecode(response.body)).u31;
      } else if (response.hasProblemDetails) {
        return ProblemDetails.fromJson(jsonDecode(response.body)).u32;
      } else {
        return ApiException.fromResponse(response).u33;
      }
    } on Exception catch (error) {
      return error.u33;
    }
  }
}

extension on Response {
  bool get hasProblemDetails
    => headers[HttpHeaders.contentTypeHeader] == ContentType("application", "problem+json").toString();
}