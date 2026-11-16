import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pauln10v_rick_and_morty_api/dto/resource_base.dart';

import 'location_base.dart';

part 'location.freezed.dart';
part 'location.g.dart';

@JsonSerializable(includeIfNull: false)
class LocationFilter {
  String? name;
  String? type;
  String? dimension;

  LocationFilter({
    this.name,
    this.type,
    this.dimension,
  });

  Map<String, dynamic> toJson() => _$LocationFilterToJson(this);

  Map<String, String> toQuery() =>
      toJson().map((k, v) => MapEntry(k, v.toString()));
}

@freezed
abstract class Location with _$Location implements LocationBase, ResourceBase {
  const factory Location({
    required int id,
    required String name,
    required String type,
    required String dimension,
    required List<Uri> residents,
    required Uri url,
    required DateTime created,
  }) = _Location;

  factory Location.fromJson(Map<String, dynamic> json) =>
      _$LocationFromJson(json);
}