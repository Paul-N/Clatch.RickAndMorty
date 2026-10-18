import 'dart:convert';
import 'dart:io';

import 'package:extension_type_unions/extension_type_unions.dart';
import 'package:http/http.dart' as http;

class ApiException implements Exception {
  final int statusCode;
  final String message;
  final Union2<Map<String, dynamic>, String>? body;

  ApiException({
    required this.statusCode,
    required this.message,
    this.body,
  });

  factory ApiException.fromResponse(http.Response response) {
    final body = response.headers[HttpHeaders.contentTypeHeader] == ContentType("application", "json").toString()
        ? jsonDecode(response.body).u21
        : (response.body.isNotEmpty ? response.body.u22 : null);

    return ApiException(
      statusCode: response.statusCode,
      message: response.reasonPhrase ?? '',
      body: body,
    );
  }

  @override
  String toString() => 'ApiException: $statusCode $message${body != null ? '\nBody: $body' : ''}';
}