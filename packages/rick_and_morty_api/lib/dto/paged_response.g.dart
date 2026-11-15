// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'paged_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_PagedResponse<T> _$PagedResponseFromJson<T>(
  Map<String, dynamic> json,
  T Function(Object? json) fromJsonT,
) => _PagedResponse<T>(
  info: json['info'] == null
      ? null
      : Info.fromJson(json['info'] as Map<String, dynamic>),
  results: (json['results'] as List<dynamic>).map(fromJsonT).toList(),
);

Map<String, dynamic> _$PagedResponseToJson<T>(
  _PagedResponse<T> instance,
  Object? Function(T value) toJsonT,
) => <String, dynamic>{
  'info': instance.info,
  'results': instance.results.map(toJsonT).toList(),
};

_Info _$InfoFromJson(Map<String, dynamic> json) => _Info(
  count: (json['count'] as num).toInt(),
  pages: (json['pages'] as num).toInt(),
  next: json['next'] as String?,
  prev: json['prev'] as String?,
);

Map<String, dynamic> _$InfoToJson(_Info instance) => <String, dynamic>{
  'count': instance.count,
  'pages': instance.pages,
  'next': instance.next,
  'prev': instance.prev,
};
