// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_message_server.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ChatMessageServer _$ChatMessageServerFromJson(Map<String, dynamic> json) =>
    ChatMessageServer(
      content: json['content'] as String,
      id: json['id'] as int,
      sender: json['sender'] as String,
      type: json['type'] as String,
      createdAt: json['createdAt'] as int,
      mediaId: json['mediaId'] as int?,
      mediaName: json['mediaName'] as String?,
      customerId: json['customerId'] as int?,
      replyTo: json['replyTo'] as int?,
    );

Map<String, dynamic> _$ChatMessageServerToJson(ChatMessageServer instance) =>
    <String, dynamic>{
      'id': instance.id,
      'content': instance.content,
      'sender': instance.sender,
      'type': instance.type,
      'mediaId': instance.mediaId,
      'mediaName': instance.mediaName,
      'customerId': instance.customerId,
      'replyTo': instance.replyTo,
      'createdAt': instance.createdAt,
    };
