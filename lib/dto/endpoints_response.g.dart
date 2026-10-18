// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'endpoints_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_EndpointsResponse _$EndpointsResponseFromJson(Map<String, dynamic> json) =>
    _EndpointsResponse(
      characters: json['characters'] as String,
      locations: json['locations'] as String,
      episodes: json['episodes'] as String,
    );

Map<String, dynamic> _$EndpointsResponseToJson(_EndpointsResponse instance) =>
    <String, dynamic>{
      'characters': instance.characters,
      'locations': instance.locations,
      'episodes': instance.episodes,
    };
