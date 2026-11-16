import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pauln10v_rick_and_morty_api/dto/resource_base.dart';
part 'episode.freezed.dart';
part 'episode.g.dart';

@JsonSerializable(includeIfNull: false)
class EpisodeFilter {
  String? name;
  String? episode;

  EpisodeFilter({
    this.name,
    this.episode,
  });

  Map<String, dynamic> toJson() => _$EpisodeFilterToJson(this);

  Map<String, String> toQuery() =>
      toJson().map((k, v) => MapEntry(k, v.toString()));
}

@freezed
sealed class Episode with _$Episode implements ResourceBase {
  const factory Episode({
    required int id,
    required String name,
    required String air_date,
    required String episode,
    required List<Uri> characters,
    required Uri url,
    required DateTime created,
  }) = _Episode;

  factory Episode.fromJson(Map<String, dynamic> json) =>
      _$EpisodeFromJson(json);
}