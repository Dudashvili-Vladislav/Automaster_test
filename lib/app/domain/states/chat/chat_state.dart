part of 'chat_bloc.dart';

abstract class ChatMessage {
  final DateTime dateTime;
  final int? senderId;
  final int? id;
  final int? replyTo;

  const ChatMessage({
    required this.dateTime,
    required this.senderId,
    required this.id,
    required this.replyTo,
  });

  ChatMessageType get msgType;
}

class TextChatMessage extends ChatMessage {
  final String text;

  const TextChatMessage({
    required this.text,
    required super.dateTime,
    required super.senderId,
    required super.replyTo,
    required super.id,
  });

  @override
  final ChatMessageType msgType = ChatMessageType.text;

  @override
  bool operator ==(Object other) =>
      other is TextChatMessage &&
      runtimeType == other.runtimeType &&
      text == other.text &&
      senderId == other.senderId;

  @override
  int get hashCode => text.hashCode ^ senderId.hashCode;
}

class MediaChatMessage extends ChatMessage {
  final int mediaId;
  final String mediaName;

  const MediaChatMessage({
    required this.mediaId,
    required this.mediaName,
    required super.dateTime,
    required super.senderId,
    required super.replyTo,
    required super.id,
  });

  @override
  final ChatMessageType msgType = ChatMessageType.media;

  @override
  bool operator ==(Object other) =>
      other is MediaChatMessage &&
      runtimeType == other.runtimeType &&
      mediaId == other.mediaId &&
      senderId == other.senderId;

  @override
  int get hashCode => mediaId.hashCode ^ senderId.hashCode;
}

// class ImageChatMessage extends ChatMessage {
//   final String imageUrl;

//   const ImageChatMessage({
//     required this.imageUrl,
//     required super.dateTime,
//     required super.senderId,
//   });

//   @override
//   final ChatMessageType msgType = ChatMessageType.image;
// }

// class VoiceChatMessage extends ChatMessage {
//   final String voiceUrl;

//   const VoiceChatMessage({
//     required this.voiceUrl,
//     required super.dateTime,
//     required super.senderId,
//   });

//   @override
//   final ChatMessageType msgType = ChatMessageType.voice;
// }

enum ChatMessageType {
  text,
  media,
}

@CopyWith()
class ChatState {
  final List<ChatMessage> messages;
  final ChatInputState inputState;
  final Uint8List? chosenImage;
  final Uint8List? chosenFile;
  final String? filename;
  final String? imageName;
  final AudioPlayer? currentVoicePlayer;
  final ChatMessage? reply;

  final String chatName;
  final int chatId;
  final String masterName;

  final bool isInitialized;

  const ChatState({
    required this.messages,
    required this.inputState,
    required this.chosenImage,
    required this.chatName,
    required this.chatId,
    required this.isInitialized,
    required this.imageName,
    required this.currentVoicePlayer,
    required this.reply,
    required this.chosenFile,
    required this.filename,
    required this.masterName,
  });

  ChatState.initial()
      : inputState = ChatInputState.initial,
        currentVoicePlayer = null,
        chosenImage = null,
        chatName = '',
        chosenFile = null,
        filename = null,
        chatId = -1,
        reply = null,
        messages = [],
        masterName = 'Мастер',
        imageName = null,
        isInitialized = false;
}

enum ChatInputState {
  initial,
  inputText,
  recordingVoice,
  finishedVoice,
}
