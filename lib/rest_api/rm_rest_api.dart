import 'dart:convert';
import 'dart:io';

import 'package:extension_type_unions/extension_type_unions.dart';
import 'package:http/http.dart';
import 'package:problem_details/problem_details.dart';
import 'package:rick_and_morty/dto/endpoints_response.dart';
import 'package:rick_and_morty/dto/paged_response.dart';
import 'package:rick_and_morty/dto/character.dart';
import 'api_exception.dart';
//import 'dto.dart';

abstract interface class IRickAndMortyRestApi {
  // Future<Union3<ChatListResponse, ProblemDetails, Exception>> getChatList();
  // Future<Union3<ChatMessagesResponse, ProblemDetails, Exception>> getChat(String from);
  Future<Union3<EndpointsResponse, ProblemDetails, Exception>> getEndpoints();
  Future<Union3<PagedResponse<Character>, ProblemDetails, Exception>> getCharacters(EndpointsResponse endpointsResponse);
}

final class RickAndMortyRestApi implements IRickAndMortyRestApi {
  final String _baseUrl;
  final Client _client;

  RickAndMortyRestApi({required Client client, required String baseUrl}):
        _client = client,
        _baseUrl = baseUrl;

  @override
  Future<Union3<EndpointsResponse, ProblemDetails, Exception>> getEndpoints() async {
    try {

      final uri = Uri.parse('$_baseUrl/api');

      final response = await _client.get(uri);
      if (response.statusCode == 200) {
        return EndpointsResponse.fromJson(jsonDecode(response.body)).u31;
      } else if (response.hasProblemDetails) {
        return ProblemDetails.fromJson(jsonDecode(response.body)).u32;
      } else {
        return ApiException.fromResponse(response).u33;
      }
    } on Exception catch (error) {
      return error.u33;
    }
  }

  Future<Union3<PagedResponse<Character>, ProblemDetails, Exception>> getCharacters(EndpointsResponse endpointsResponse) async {
    try {

      final response = await _client.get(endpointsResponse.characters);
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
}

extension on Response {
  bool get hasProblemDetails
    => headers[HttpHeaders.contentTypeHeader] == ContentType("application", "problem+json").toString();
}