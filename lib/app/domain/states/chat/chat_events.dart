part of 'chat_bloc.dart';

abstract class ChatEvent {
  const ChatEvent();
}

class IsInitialized extends ChatEvent {
  final bool isInitialized;

  const IsInitialized(this.isInitialized);
}

class AddListOfMessages extends ChatEvent {
  final List<ChatMessage> messages;

  const AddListOfMessages(this.messages);
}

class AddTextMessage extends ChatEvent {
  final TextChatMessage textChatMessage;

  const AddTextMessage(this.textChatMessage);
}

class AddMediaMessage extends ChatEvent {
  final MediaChatMessage mediaChatMessage;

  const AddMediaMessage(this.mediaChatMessage);
}

class SendTextMessage extends ChatEvent {
  final TextChatMessage textChatMessage;
  final int masterId;

  const SendTextMessage(
    this.textChatMessage,
    this.masterId,
  );
}

class SendMediaMessage extends ChatEvent {
  final String fileName;
  final Uint8List file;
  final int masterId;

  const SendMediaMessage({
    required this.file,
    required this.fileName,
    required this.masterId,
  });
}

class SendVoiceMessage extends ChatEvent {
  final String fileName;
  final Uint8List file;
  final int masterId;

  const SendVoiceMessage({
    required this.file,
    required this.fileName,
    required this.masterId,
  });
}

class SetTextInput extends ChatEvent {
  const SetTextInput();
}

class SetInitialInput extends ChatEvent {
  const SetInitialInput();
}

class ChooseImage extends ChatEvent {
  final Uint8List image;
  final String fileName;

  const ChooseImage(
    this.image,
    this.fileName,
  );
}

class ChooseFile extends ChatEvent {
  final Uint8List file;
  final String fileName;

  const ChooseFile(
    this.file,
    this.fileName,
  );
}

class RemoveFile extends ChatEvent {
  final Uint8List file;

  const RemoveFile(this.file);
}

class RemoveImage extends ChatEvent {
  final Uint8List image;

  const RemoveImage(this.image);
}

class StartRecording extends ChatEvent {
  const StartRecording();
}

class StopRecording extends ChatEvent {
  const StopRecording();
}

class DeleteRecording extends ChatEvent {
  const DeleteRecording();
}

class StopCurrentVoice extends ChatEvent {
  const StopCurrentVoice();
}

class StartListeningToVoice extends ChatEvent {
  final AudioPlayer player;

  const StartListeningToVoice(this.player);
}

class AddReply extends ChatEvent {
  final ChatMessage msg;

  const AddReply(this.msg);
}

class RemoveReply extends ChatEvent {
  const RemoveReply();
}

class SetMasterName extends ChatEvent {
  final String name;

  const SetMasterName(this.name);
}

class SetChatName extends ChatEvent {
  final String spec;
  final String extraSpec;

  const SetChatName(this.spec, this.extraSpec);
}
