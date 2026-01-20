// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_room.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ChatRoom _$ChatRoomFromJson(Map<String, dynamic> json) => ChatRoom(
      id: json['id'] as int,
      chatId: json['chatId'] as int?,
      nameOfCategory: json['nameOfCategory'] as String?,
      chatRegister: json['chatRegister'] as String?,
      chatTopic: json['chatTopic'] as String?,
      chatName: json['chatName'] as String?,
    );

Map<String, dynamic> _$ChatRoomToJson(ChatRoom instance) => <String, dynamic>{
      'id': instance.id,
      'chatId': instance.chatId,
      'nameOfCategory': instance.nameOfCategory,
      'chatRegister': instance.chatRegister,
      'chatTopic': instance.chatTopic,
      'chatName': instance.chatName,
    };
