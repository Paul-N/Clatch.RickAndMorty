import 'dart:convert';

import 'package:http_parser/http_parser.dart';
import 'package:problem_details/problem_details.dart';

final class TooManyRequestsErrorHeaders {
  const TooManyRequestsErrorHeaders({
    this.retryAfter,
    this.date,
    this.reportTo,
    this.nel,
    this.serverTiming,
    this.server,
    this.cfRay,
  });

  /// Expects lower-case keys, as `Response.headers` provides.
  factory TooManyRequestsErrorHeaders.fromHeaders(Map<String, String> headers) {
    final seconds = int.tryParse(headers['retry-after']?.trim() ?? '');
    return TooManyRequestsErrorHeaders(
      retryAfter: seconds == null ? null : Duration(seconds: seconds),
      date: _tryHttpDate(headers['date']),
      reportTo: NelReportTo.tryParse(headers['report-to']),
      nel: Nel.tryParse(headers['nel']),
      serverTiming: headers['server-timing'],
      server: headers['server'],
      cfRay: headers['cf-ray'],
    );
  }

  /// `Retry-After` header: seconds to wait (the HTTP-date form reads as null).
  final Duration? retryAfter;

  /// `Date` header: server timestamp.
  final DateTime? date;

  /// `Report-To` header: Cloudflare error reporting config (first group only).
  final NelReportTo? reportTo;

  /// `NEL` header: Network Error Logging config.
  final Nel? nel;

  /// `Server-Timing` header.
  final String? serverTiming;

  /// `Server` header.
  final String? server;

  /// `CF-Ray` header: Cloudflare Ray ID.
  final String? cfRay;
}

/// `Date` is an HTTP-date (`Wed, 21 Oct 2026 00:06:35 GMT`), which
/// `DateTime.tryParse` does not understand.
DateTime? _tryHttpDate(String? value) {
  if (value == null) return null;
  try {
    return parseHttpDate(value);
  } on FormatException {
    return null;
  }
}

final class Nel {
  const Nel({this.reportTo, this.successFraction, this.maxAge});

  factory Nel.fromJson(Map<String, dynamic> json) => Nel(
    reportTo: json['report_to'] as String?,
    successFraction: (json['success_fraction'] as num?)?.toDouble(),
    maxAge: (json['max_age'] as num?)?.toInt(),
  );

  /// Null when [value] is absent or malformed.
  static Nel? tryParse(String? value) {
    if (value == null) return null;
    try {
      final json = jsonDecode(value);
      return json is Map<String, dynamic> ? Nel.fromJson(json) : null;
    } on FormatException {
      return null;
    } on TypeError {
      return null;
    }
  }

  final String? reportTo;
  final double? successFraction;
  final int? maxAge;
}

final class NelEndpoint {
  const NelEndpoint({this.url});

  factory NelEndpoint.fromJson(Map<String, dynamic> json) {
    final url = json['url'];
    return NelEndpoint(url: url is String ? Uri.tryParse(url) : null);
  }

  final Uri? url;
}

final class NelReportTo {
  const NelReportTo({this.group, this.maxAge, this.endpoints = const []});

  factory NelReportTo.fromJson(Map<String, dynamic> json) => NelReportTo(
    group: json['group'] as String?,
    maxAge: (json['max_age'] as num?)?.toInt(),
    endpoints: [
      for (final e in json['endpoints'] as List<dynamic>? ?? const [])
        NelEndpoint.fromJson(e as Map<String, dynamic>),
    ],
  );

  /// `Report-To` is a comma-separated list of JSON objects (one per group), so
  /// it is decoded as a list and only the first group is kept. Null when
  /// [value] is absent or malformed.
  static NelReportTo? tryParse(String? value) {
    if (value == null) return null;
    try {
      if (jsonDecode('[$value]') case [final Map<String, dynamic> first, ...]) {
        return NelReportTo.fromJson(first);
      }
      return null;
    } on FormatException {
      return null;
    } on TypeError {
      return null;
    }
  }

  final String? group;
  final int? maxAge;
  final List<NelEndpoint> endpoints;
}

extension CloudflareProblemDetails on ProblemDetails {
  // Documented in https://developers.cloudflare.com/fundamentals/reference/error-responses/#cloudflare-extension-members
  // Every getter is null-safe: a body that is not a Cloudflare error simply
  // reads as "absent" instead of throwing.
  T? _ext<T>(String key) {
    final value = extensions[key];
    return value is T ? value : null;
  }

  int? get errorCode => _ext<int>('error_code');
  String? get errorName => _ext<String>('error_name');
  CloudflareErrorCategory get errorCategory =>
      CloudflareErrorCategory.parse(_ext<String>('error_category'));
  String? get rayId => _ext<String>('ray_id');
  DateTime? get timestamp {
    final value = _ext<String>('timestamp');
    return value == null ? null : DateTime.tryParse(value);
  }

  String? get zone => _ext<String>('zone');
  bool get cloudflareError => _ext<bool>('cloudflare_error') ?? false;
  bool get retryable => _ext<bool>('retryable') ?? false;
  Duration? get retryAfter {
    final seconds = _ext<num>('retry_after');
    return seconds == null ? null : Duration(seconds: seconds.ceil());
  }

  bool get ownerActionRequired => _ext<bool>('owner_action_required') ?? false;
  String? get whatYouShouldDo => _ext<String>('what_you_should_do');
  String? get footer => _ext<String>('footer');
}

/// `error_category` values documented by Cloudflare. The field is documented
/// as stable, but unknown values map to [unknown] instead of failing.
enum CloudflareErrorCategory {
  // 1xxx errors
  accessDenied('access_denied'),
  rateLimit('rate_limit'),
  dns('dns'),
  config('config'),
  tls('tls'),
  legal('legal'),
  worker('worker'),
  rewrite('rewrite'),
  snippet('snippet'),
  unsupported('unsupported'),
  // 5xx errors
  origin('origin'),
  cloudflare('cloudflare'),
  ssl('ssl'),
  // anything else
  unknown('unknown');

  const CloudflareErrorCategory(this.value);

  final String value;

  static CloudflareErrorCategory parse(String? value) =>
      values.firstWhere((c) => c.value == value, orElse: () => unknown);
}