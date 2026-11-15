// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'episode.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

EpisodeFilter _$EpisodeFilterFromJson(Map<String, dynamic> json) =>
    EpisodeFilter(
      name: json['name'] as String?,
      episode: json['episode'] as String?,
    );

Map<String, dynamic> _$EpisodeFilterToJson(EpisodeFilter instance) =>
    <String, dynamic>{'name': ?instance.name, 'episode': ?instance.episode};

_Episode _$EpisodeFromJson(Map<String, dynamic> json) => _Episode(
  id: (json['id'] as num).toInt(),
  name: json['name'] as String,
  air_date: json['air_date'] as String,
  episode: json['episode'] as String,
  characters: (json['characters'] as List<dynamic>)
      .map((e) => Uri.parse(e as String))
      .toList(),
  url: Uri.parse(json['url'] as String),
  created: DateTime.parse(json['created'] as String),
);

Map<String, dynamic> _$EpisodeToJson(_Episode instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'air_date': instance.air_date,
  'episode': instance.episode,
  'characters': instance.characters.map((e) => e.toString()).toList(),
  'url': instance.url.toString(),
  'created': instance.created.toIso8601String(),
};
