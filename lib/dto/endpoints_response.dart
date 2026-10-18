import 'package:freezed_annotation/freezed_annotation.dart';

part 'endpoints_response.freezed.dart';
part 'endpoints_response.g.dart';

@freezed
abstract class EndpointsResponse with _$EndpointsResponse {
  const factory EndpointsResponse({
    @JsonKey(name: 'characters') required String characters,
    @JsonKey(name: 'locations') required String locations,
    @JsonKey(name: 'episodes') required String episodes,
  }) = _EndpointsResponse;

  factory EndpointsResponse.fromJson(Map<String, dynamic> json) =>
      _$EndpointsResponseFromJson(json);
}

// @freezed
// abstract class ChatMessagesResponse with _$ChatMessagesResponse {
//   const factory ChatMessagesResponse({
//     @JsonKey(name: 'chat_msgs') required List<ChatMessage> messages,
//     @Default(0) int totalCount,
//   }) = _ChatMessagesResponse;
//
//   factory ChatMessagesResponse.fromJson(Map<String, dynamic> json) =>
//       _$ChatMessagesResponseFromJson(json);
// }
//
// @freezed
// abstract class Chat with _$Chat {
//   const factory Chat({
//     @JsonKey(name: 'from') required String from,
//     @JsonKey(name: 'last_message') required String lastMessageText,
//     @JsonKey(name: 'date') required DateTime date,
//   }) = _Chat;
//
//   factory Chat.fromJson(Map<String, dynamic> json) => _$ChatFromJson(json);
// }
//
// @freezed
// abstract class ChatMessage with _$ChatMessage {
//   const factory ChatMessage({
//     @JsonKey(name: 'text') required String? text,
//     @JsonKey(name: 'date') required DateTime date,
//   }) = _ChatMessage;
//
//   factory ChatMessage.fromJson(Map<String, dynamic> json) =>
//       _$ChatMessageFromJson(json);
// }