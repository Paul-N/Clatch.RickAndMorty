import 'dart:convert';
import 'dart:io';

import 'package:extension_type_unions/extension_type_unions.dart';
import 'package:http/http.dart';
import 'package:problem_details/problem_details.dart';
import 'api_exception.dart';
//import 'dto.dart';

abstract interface class IRickAndMortyRestApi {
  // Future<Union3<ChatListResponse, ProblemDetails, Exception>> getChatList();
  // Future<Union3<ChatMessagesResponse, ProblemDetails, Exception>> getChat(String from);
}

final class RickAndMortyRestApi implements IRickAndMortyRestApi {
  final String _baseUrl;
  final Client _client;

  RickAndMortyRestApi({required Client client, required String baseUrl}):
        _client = client,
        _baseUrl = baseUrl;

  // @override
  // Future<Union3<ChatMessagesResponse, ProblemDetails, Exception>> getChat(String from) async {
  //   try {
  //
  //     final uri = Uri.parse('$_baseUrl/chat').replace(
  //       queryParameters: {'from': from},
  //     );
  //
  //     final response = await _client.get(uri);
  //     if (response.statusCode == 200) {
  //       return ChatMessagesResponse.fromJson(jsonDecode(response.body)).u31;
  //     } else if (response.hasProblemDetails) {
  //       return ProblemDetails.fromJson(jsonDecode(response.body)).u32;
  //     } else {
  //       return ApiException.fromResponse(response).u33;
  //     }
  //   } on Exception catch (error) {
  //     return error.u33;
  //   }
  // }
  //
  // @override
  // Future<Union3<ChatListResponse, ProblemDetails, Exception>> getChatList() async {
  //   try {
  //     final response = await _client.get(Uri.parse('$_baseUrl/chats'));
  //     if (response.statusCode == 200) {
  //       return ChatListResponse.fromJson(jsonDecode(response.body)).u31;
  //     } else if (response.hasProblemDetails) {
  //       return ProblemDetails.fromJson(jsonDecode(response.body)).u32;
  //     } else {
  //       return ApiException.fromResponse(response).u33;
  //     }
  //   } on Exception catch (error) {
  //     return error.u33;
  //   }
  // }

}

extension on Response {
  bool get hasProblemDetails
    => headers[HttpHeaders.contentTypeHeader] == ContentType("application", "problem+json").toString();
}