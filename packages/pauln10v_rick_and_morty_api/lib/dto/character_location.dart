import 'package:freezed_annotation/freezed_annotation.dart';

import 'character.dart';
import 'location_base.dart';

part 'character_location.freezed.dart';
part 'character_location.g.dart';

@freezed
abstract class CharacterLocation
    with _$CharacterLocation
    implements LocationBase {
  const factory CharacterLocation({
    required String name,
    required Uri url,
  }) = _CharacterLocation;

  factory CharacterLocation.fromJson(Map<String, dynamic> json) =>
      _$CharacterLocationFromJson(json);
}