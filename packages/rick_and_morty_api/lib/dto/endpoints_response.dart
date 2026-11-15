import 'package:freezed_annotation/freezed_annotation.dart';

part 'endpoints_response.freezed.dart';
part 'endpoints_response.g.dart';

@freezed
abstract class EndpointsResponse with _$EndpointsResponse {
  const factory EndpointsResponse({
    @JsonKey(name: 'characters') required Uri characters,
    @JsonKey(name: 'locations') required Uri locations,
    @JsonKey(name: 'episodes') required Uri episodes,
  }) = _EndpointsResponse;

  factory EndpointsResponse.fromJson(Map<String, dynamic> json) =>
      _$EndpointsResponseFromJson(json);
}