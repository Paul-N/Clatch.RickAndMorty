// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'endpoints_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_EndpointsResponse _$EndpointsResponseFromJson(Map<String, dynamic> json) =>
    _EndpointsResponse(
      characters: Uri.parse(json['characters'] as String),
      locations: Uri.parse(json['locations'] as String),
      episodes: Uri.parse(json['episodes'] as String),
    );

Map<String, dynamic> _$EndpointsResponseToJson(_EndpointsResponse instance) =>
    <String, dynamic>{
      'characters': instance.characters.toString(),
      'locations': instance.locations.toString(),
      'episodes': instance.episodes.toString(),
    };
