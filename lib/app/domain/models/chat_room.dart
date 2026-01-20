import 'package:json_annotation/json_annotation.dart';

part 'chat_room.g.dart';

@JsonSerializable()
class ChatRoom {
  final int id;
  final int? chatId;
  final String? nameOfCategory;
  final String? chatRegister;
  final String? chatTopic;
  final String? chatName;

  const ChatRoom({
    required this.id,
    required this.chatId,
    required this.nameOfCategory,
    required this.chatRegister,
    required this.chatTopic,
    required this.chatName,
  });

  Map<String, dynamic> toJson() => _$ChatRoomToJson(this);

  factory ChatRoom.fromJson(Map<String, dynamic> json) =>
      _$ChatRoomFromJson(json);
}
