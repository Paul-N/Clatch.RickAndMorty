// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'character.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_CharacterLocation _$CharacterLocationFromJson(Map<String, dynamic> json) =>
    _CharacterLocation(
      name: json['name'] as String,
      url: Uri.parse(json['url'] as String),
    );

Map<String, dynamic> _$CharacterLocationToJson(_CharacterLocation instance) =>
    <String, dynamic>{'name': instance.name, 'url': instance.url.toString()};

_Character _$CharacterFromJson(Map<String, dynamic> json) => _Character(
  id: (json['id'] as num).toInt(),
  name: json['name'] as String,
  url: Uri.parse(json['url'] as String),
  created: DateTime.parse(json['created'] as String),
  status: $enumDecode(
    _$CharacterStatusEnumMap,
    json['status'],
    unknownValue: CharacterStatus.unknown,
  ),
  species: json['species'] as String,
  type: json['type'] as String? ?? '',
  gender: $enumDecode(
    _$CharacterGenderEnumMap,
    json['gender'],
    unknownValue: CharacterGender.unknown,
  ),
  origin: CharacterLocation.fromJson(json['origin'] as Map<String, dynamic>),
  location: CharacterLocation.fromJson(
    json['location'] as Map<String, dynamic>,
  ),
  image: json['image'] as String,
  episode: (json['episode'] as List<dynamic>).map((e) => e as String).toList(),
);

Map<String, dynamic> _$CharacterToJson(_Character instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'url': instance.url.toString(),
      'created': instance.created.toIso8601String(),
      'status': _$CharacterStatusEnumMap[instance.status]!,
      'species': instance.species,
      'type': instance.type,
      'gender': _$CharacterGenderEnumMap[instance.gender]!,
      'origin': instance.origin,
      'location': instance.location,
      'image': instance.image,
      'episode': instance.episode,
    };

const _$CharacterStatusEnumMap = {
  CharacterStatus.alive: 'Alive',
  CharacterStatus.dead: 'Dead',
  CharacterStatus.unknown: 'unknown',
};

const _$CharacterGenderEnumMap = {
  CharacterGender.female: 'Female',
  CharacterGender.male: 'Male',
  CharacterGender.genderless: 'Genderless',
  CharacterGender.unknown: 'unknown',
};
