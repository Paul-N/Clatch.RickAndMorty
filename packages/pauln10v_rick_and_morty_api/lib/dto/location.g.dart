// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'location.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LocationFilter _$LocationFilterFromJson(Map<String, dynamic> json) =>
    LocationFilter(
      name: json['name'] as String?,
      type: json['type'] as String?,
      dimension: json['dimension'] as String?,
    );

Map<String, dynamic> _$LocationFilterToJson(LocationFilter instance) =>
    <String, dynamic>{
      'name': ?instance.name,
      'type': ?instance.type,
      'dimension': ?instance.dimension,
    };

_Location _$LocationFromJson(Map<String, dynamic> json) => _Location(
  id: (json['id'] as num).toInt(),
  name: json['name'] as String,
  type: json['type'] as String,
  dimension: json['dimension'] as String,
  residents: (json['residents'] as List<dynamic>)
      .map((e) => Uri.parse(e as String))
      .toList(),
  url: Uri.parse(json['url'] as String),
  created: DateTime.parse(json['created'] as String),
);

Map<String, dynamic> _$LocationToJson(_Location instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'type': instance.type,
  'dimension': instance.dimension,
  'residents': instance.residents.map((e) => e.toString()).toList(),
  'url': instance.url.toString(),
  'created': instance.created.toIso8601String(),
};
