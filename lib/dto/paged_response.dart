import 'package:freezed_annotation/freezed_annotation.dart';

part 'paged_response.freezed.dart';
part 'paged_response.g.dart';

@Freezed(genericArgumentFactories: true, makeCollectionsUnmodifiable: true)
abstract class PagedResponse<T> with _$PagedResponse<T> {
  const factory PagedResponse({
    @JsonKey(name: 'info') required Info? info,
    @JsonKey(name: 'results') required List<T> results,
  }) = _PagedResponse;

  factory PagedResponse.fromJson(Map<String, dynamic> json, T Function(Object? json) fromJsonT) =>
      _$PagedResponseFromJson(json, fromJsonT);
}

@freezed
abstract class Info with _$Info {
  const factory Info({
    @JsonKey(name: 'count') required int count,
    @JsonKey(name: 'pages') required int pages,
    @JsonKey(name: 'next') required String? next,
    @JsonKey(name: 'prev') required String? prev
  }) = _Info;

  factory Info.fromJson(Map<String, dynamic> json) => _$InfoFromJson(json);

}