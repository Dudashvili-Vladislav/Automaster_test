// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_bloc.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$ChatStateCWProxy {
  ChatState chatId(int chatId);

  ChatState chatName(String chatName);

  ChatState chosenFile(Uint8List? chosenFile);

  ChatState chosenImage(Uint8List? chosenImage);

  ChatState currentVoicePlayer(AudioPlayer? currentVoicePlayer);

  ChatState filename(String? filename);

  ChatState imageName(String? imageName);

  ChatState inputState(ChatInputState inputState);

  ChatState isInitialized(bool isInitialized);

  ChatState masterName(String masterName);

  ChatState messages(List<ChatMessage> messages);

  ChatState reply(ChatMessage? reply);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `ChatState(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// ChatState(...).copyWith(id: 12, name: "My name")
  /// ````
  ChatState call({
    int? chatId,
    String? chatName,
    Uint8List? chosenFile,
    Uint8List? chosenImage,
    AudioPlayer? currentVoicePlayer,
    String? filename,
    String? imageName,
    ChatInputState? inputState,
    bool? isInitialized,
    String? masterName,
    List<ChatMessage>? messages,
    ChatMessage? reply,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfChatState.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfChatState.copyWith.fieldName(...)`
class _$ChatStateCWProxyImpl implements _$ChatStateCWProxy {
  final ChatState _value;

  const _$ChatStateCWProxyImpl(this._value);

  @override
  ChatState chatId(int chatId) => this(chatId: chatId);

  @override
  ChatState chatName(String chatName) => this(chatName: chatName);

  @override
  ChatState chosenFile(Uint8List? chosenFile) => this(chosenFile: chosenFile);

  @override
  ChatState chosenImage(Uint8List? chosenImage) =>
      this(chosenImage: chosenImage);

  @override
  ChatState currentVoicePlayer(AudioPlayer? currentVoicePlayer) =>
      this(currentVoicePlayer: currentVoicePlayer);

  @override
  ChatState filename(String? filename) => this(filename: filename);

  @override
  ChatState imageName(String? imageName) => this(imageName: imageName);

  @override
  ChatState inputState(ChatInputState inputState) =>
      this(inputState: inputState);

  @override
  ChatState isInitialized(bool isInitialized) =>
      this(isInitialized: isInitialized);

  @override
  ChatState masterName(String masterName) => this(masterName: masterName);

  @override
  ChatState messages(List<ChatMessage> messages) => this(messages: messages);

  @override
  ChatState reply(ChatMessage? reply) => this(reply: reply);

  @override

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `ChatState(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// ChatState(...).copyWith(id: 12, name: "My name")
  /// ````
  ChatState call({
    Object? chatId = const $CopyWithPlaceholder(),
    Object? chatName = const $CopyWithPlaceholder(),
    Object? chosenFile = const $CopyWithPlaceholder(),
    Object? chosenImage = const $CopyWithPlaceholder(),
    Object? currentVoicePlayer = const $CopyWithPlaceholder(),
    Object? filename = const $CopyWithPlaceholder(),
    Object? imageName = const $CopyWithPlaceholder(),
    Object? inputState = const $CopyWithPlaceholder(),
    Object? isInitialized = const $CopyWithPlaceholder(),
    Object? masterName = const $CopyWithPlaceholder(),
    Object? messages = const $CopyWithPlaceholder(),
    Object? reply = const $CopyWithPlaceholder(),
  }) {
    return ChatState(
      chatId: chatId == const $CopyWithPlaceholder() || chatId == null
          ? _value.chatId
          // ignore: cast_nullable_to_non_nullable
          : chatId as int,
      chatName: chatName == const $CopyWithPlaceholder() || chatName == null
          ? _value.chatName
          // ignore: cast_nullable_to_non_nullable
          : chatName as String,
      chosenFile: chosenFile == const $CopyWithPlaceholder()
          ? _value.chosenFile
          // ignore: cast_nullable_to_non_nullable
          : chosenFile as Uint8List?,
      chosenImage: chosenImage == const $CopyWithPlaceholder()
          ? _value.chosenImage
          // ignore: cast_nullable_to_non_nullable
          : chosenImage as Uint8List?,
      currentVoicePlayer: currentVoicePlayer == const $CopyWithPlaceholder()
          ? _value.currentVoicePlayer
          // ignore: cast_nullable_to_non_nullable
          : currentVoicePlayer as AudioPlayer?,
      filename: filename == const $CopyWithPlaceholder()
          ? _value.filename
          // ignore: cast_nullable_to_non_nullable
          : filename as String?,
      imageName: imageName == const $CopyWithPlaceholder()
          ? _value.imageName
          // ignore: cast_nullable_to_non_nullable
          : imageName as String?,
      inputState:
          inputState == const $CopyWithPlaceholder() || inputState == null
              ? _value.inputState
              // ignore: cast_nullable_to_non_nullable
              : inputState as ChatInputState,
      isInitialized:
          isInitialized == const $CopyWithPlaceholder() || isInitialized == null
              ? _value.isInitialized
              // ignore: cast_nullable_to_non_nullable
              : isInitialized as bool,
      masterName:
          masterName == const $CopyWithPlaceholder() || masterName == null
              ? _value.masterName
              // ignore: cast_nullable_to_non_nullable
              : masterName as String,
      messages: messages == const $CopyWithPlaceholder() || messages == null
          ? _value.messages
          // ignore: cast_nullable_to_non_nullable
          : messages as List<ChatMessage>,
      reply: reply == const $CopyWithPlaceholder()
          ? _value.reply
          // ignore: cast_nullable_to_non_nullable
          : reply as ChatMessage?,
    );
  }
}

extension $ChatStateCopyWith on ChatState {
  /// Returns a callable class that can be used as follows: `instanceOfChatState.copyWith(...)` or like so:`instanceOfChatState.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$ChatStateCWProxy get copyWith => _$ChatStateCWProxyImpl(this);
}
