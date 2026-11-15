// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'character_location.dart';

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
