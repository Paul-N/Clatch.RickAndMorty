import 'dart:convert';

import 'package:extension_type_unions/extension_type_unions.dart';
import 'package:http/http.dart' as http;

class ApiException implements Exception {
  final int statusCode;
  late final String message;
  final Union3<Map<String, dynamic>, List<dynamic>, String>? body;

  ApiException({
    required this.statusCode,
    required this.message,
    this.body,
  });

  factory ApiException.fromResponse(http.Response response) {
    if (response.body.isEmpty) {
      return ApiException(
        statusCode: response.statusCode,
        message: response.reasonPhrase ?? 'Unknown Error',
        body: null,
      );
    }

    final isJson = response.headers['content-type']?.contains('application/json') == true;
    Union3<Map<String, dynamic>, List<dynamic>, String>? parsedBody;

    if (isJson) {
      try {
        final decoded = jsonDecode(response.body);
        if (decoded is Map<String, dynamic>) {
          parsedBody = decoded.u31;
        } else if (decoded is List<dynamic>) {
          parsedBody = decoded.u32;
        } else {
          parsedBody = response.body.u33;
        }
      } catch (_) {
        parsedBody = response.body.u33;
      }
    } else {
      parsedBody = response.body.u33;
    }

    return ApiException(
      statusCode: response.statusCode,
      message: response.reasonPhrase ?? 'Unknown Error',
      body: parsedBody,
    );
  }

  @override
  String toString() => 'ApiException: $statusCode $message${body != null ? '\nBody: $body' : ''}';
}
