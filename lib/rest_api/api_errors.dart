import 'dart:convert';

import 'package:extension_type_unions/extension_type_unions.dart';
import 'package:http/http.dart' as http;
import 'package:problem_details/problem_details.dart';
import 'package:rick_and_morty/rest_api/too_many_requests.dart';

sealed class ApiError {

}

class ApiResponseError implements ApiError {
  final int statusCode;
  late final String message;
  final Union3<Map<String, dynamic>, List<dynamic>, String>? body;

  ApiResponseError({
    required this.statusCode,
    required this.message,
    this.body,
  });

  factory ApiResponseError.fromResponse(http.Response response) {
    if (response.body.isEmpty) {
      return ApiResponseError(
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

    return ApiResponseError(
      statusCode: response.statusCode,
      message: response.reasonPhrase ?? 'Unknown Error',
      body: parsedBody,
    );
  }

  @override
  String toString() => 'ApiException: $statusCode $message${body != null ? '\nBody: $body' : ''}';
}

final class ApiExceptionError implements ApiError {
  final Exception exception;

  const ApiExceptionError({
    required this.exception
  });

  factory ApiExceptionError.fromException(Exception exception) => ApiExceptionError(exception: exception);
}

/// An HTTP 429 response, with the Cloudflare problem details (error 1015 for
/// rate limits) when the body has them. Building it never throws.
final class CloudflareTooManyRequestsError implements ApiError {
  const CloudflareTooManyRequestsError({
    required this.statusCode,
    required this.headers,
    required this.cloudflareProblemDetails,
  });

  factory CloudflareTooManyRequestsError.fromResponse(http.Response r) =>
      CloudflareTooManyRequestsError(
        statusCode: r.statusCode,
        headers: TooManyRequestsErrorHeaders.fromHeaders(r.headers),
        cloudflareProblemDetails: _tryProblem(r.body),
      );

  final int statusCode;
  final TooManyRequestsErrorHeaders headers;

  /// Null when the body is not a JSON object that parses as problem details.
  final ProblemDetails? cloudflareProblemDetails;

  /// Cloudflare error 1015 ("You are being rate limited").
  bool get isRateLimited {
    final problem = cloudflareProblemDetails;
    return problem != null &&
        problem.cloudflareError &&
        problem.errorCode == 1015;
  }

  /// How long to wait. The header comes first, because Cloudflare documents
  /// that a rate-limiting rule's dynamic value takes precedence over the
  /// default (30 s for 1015) that the body carries. Then the body, then
  /// [fallback].
  Duration retryAfter({Duration fallback = const Duration(seconds: 30)}) =>
      headers.retryAfter ?? cloudflareProblemDetails?.retryAfter ?? fallback;
}

ProblemDetails? _tryProblem(String body) {
  try {
    final json = jsonDecode(body);
    return json is Map<String, dynamic> ? ProblemDetails.fromJson(json) : null;
  } on FormatException {
    return null;
  } on TypeError {
    return null;
  }
}