import 'package:json_annotation/json_annotation.dart';

part 'chat_message_server.g.dart';

@JsonSerializable()
class ChatMessageServer {
  final int id;
  final String content;
  final String sender;
  final String type;
  final int? mediaId;
  final String? mediaName;
  final int? customerId;
  final int? replyTo;
  final int createdAt;

  const ChatMessageServer({
    required this.content,
    required this.id,
    required this.sender,
    required this.type,
    required this.createdAt,
    this.mediaId,
    this.mediaName,
    this.customerId,
    this.replyTo,
  });

  Map<String, dynamic> toJson() => _$ChatMessageServerToJson(this);

  factory ChatMessageServer.fromJson(Map<String, dynamic> json) =>
      _$ChatMessageServerFromJson(json);
}
