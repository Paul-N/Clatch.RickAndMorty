import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pauln10v_rick_and_morty_api/dto/resource_base.dart';

import 'character_location.dart';
import 'location_base.dart';

part 'character.freezed.dart';
part 'character.g.dart';

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
    @_LocationConverter() required LocationBase origin,
    @_LocationConverter() required LocationBase location,
    required String image,
    // Freezed forces this List to be a readonly UnmodifiableListView at runtime
    required List<Uri> episode,
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

  Map<String, dynamic> toJson() => _$CharacterFilterToJson(this);

  Map<String, String> toQuery() =>
      toJson().map((k, v) => MapEntry(k, v.toString()));
}

class _LocationConverter
    implements JsonConverter<LocationBase, Map<String, dynamic>> {
  const _LocationConverter();

  @override
  LocationBase fromJson(Map<String, dynamic> json) =>
      CharacterLocation.fromJson(json);

  @override
  Map<String, dynamic> toJson(LocationBase object) => {
    'name': object.name,
    'url': object.url.toString(),
  };
}