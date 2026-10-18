import 'package:freezed_annotation/freezed_annotation.dart';

part 'character.freezed.dart';
part 'character.g.dart';

/// 1. Enums for String Literals
enum CharacterStatus {
  @JsonValue('Alive') alive,
  @JsonValue('Dead') dead,
  @JsonValue('unknown') unknown,
}

enum CharacterGender {
  @JsonValue('Female') female,
  @JsonValue('Male') male,
  @JsonValue('Genderless') genderless,
  @JsonValue('unknown') unknown,
}

/// 2. Supporting Placeholder Class
@freezed
abstract class CharacterLocation with _$CharacterLocation {
  const factory CharacterLocation({
    required String name,
    required Uri url,
  }) = _CharacterLocation;

  factory CharacterLocation.fromJson(Map<String, dynamic> json) =>
      _$CharacterLocationFromJson(json);
}

abstract class ResourceBase {
  int get id;
  String get name;
  Uri get url;
  DateTime get created;
}

@freezed
sealed class Character with _$Character implements ResourceBase {
  const factory Character({
    required int id,
    required String name,
    required Uri url,
    required DateTime created,


    @JsonKey(unknownEnumValue: CharacterStatus.unknown)
    required CharacterStatus status,
    required String species,
    @Default('') String type,
    @JsonKey(unknownEnumValue: CharacterGender.unknown)
    required CharacterGender gender,
    required CharacterLocation origin,
    required CharacterLocation location,
    required String image,
    // Freezed forces this List to be a readonly UnmodifiableListView at runtime
    required List<String> episode,
  }) = _Character;

  factory Character.fromJson(Map<String, dynamic> json) =>
      _$CharacterFromJson(json);
}

@JsonSerializable(includeIfNull: false)
class CharacterFilter {
  String? name;
  String? type;
  String? species;
  CharacterStatus? status;
  CharacterGender? gender;
  //int? page;

  CharacterFilter({
    this.name,
    this.status,
    this.species,
    this.type,
    this.gender,
  });

  // Map<String, Object> toQuery() => {
  //   if(name != null) 'name': '$name',
  //   if(type != null) 'type': '$type',
  //   if(species != null) 'species': '$species',
  //   //if(species != null) 'species': '$species',
  // };

  Map<String, dynamic> toJson() => _$CharacterFilterToJson(this);

  Map<String, String> toQuery() =>
      toJson().map((k, v) => MapEntry(k, v.toString()));
}
