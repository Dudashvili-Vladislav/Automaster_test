import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:auto_master/app/domain/models/server_master_profile.dart';
import 'package:collection/collection.dart' show ListEquality;
import 'package:auto_master/app/data/api_client.dart';
import 'package:auto_master/app/data/app_interceptor.dart';
import 'package:auto_master/app/domain/models/chat_message_server.dart';
import 'package:auto_master/app/domain/models/chat_room.dart';
import 'package:auto_master/app/ui/utils/get_token.dart';
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:just_audio/just_audio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:record/record.dart';

part 'chat_events.dart';
part 'chat_state.dart';

part 'chat_bloc.g.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  ChatBloc() : super(ChatState.initial()) {
    on<SetTextInput>(_setTextInput);
    on<SetInitialInput>(_setInitialInput);
    on<ChooseImage>(_chooseImage);
    on<RemoveImage>(_removeImage);
    on<ChooseFile>(_chooseFile);
    on<RemoveFile>(_removeFile);
    on<StartRecording>(_startRecording);
    on<StopRecording>(_finishRecording);
    on<DeleteRecording>(_deleteRecording);
    on<AddTextMessage>(_addTextMessage);
    on<AddMediaMessage>(_addMediaMessage);
    on<SendTextMessage>(_sendTextMessage);
    on<SendMediaMessage>(_sendMediaMessage);
    on<AddListOfMessages>(_addListOfMessages);
    on<IsInitialized>(_setLoading);
    on<SendVoiceMessage>(_sendVoiceMessage);
    on<StopCurrentVoice>(_stopCurrentVoice);
    on<StartListeningToVoice>(_startListeningToVoice);
    on<AddReply>(_addReply);
    on<RemoveReply>(_removeReply);
    on<SetMasterName>(_setMasterName);
    on<SetChatName>(_setChatName);
  }

  late Dio dioGlobal;
  late Dio dioNoLogs;

  bool isSendingMsg = false;

  final Map<int, ServerMasterProfile> masters = {};

  Timer? timer;

  Future<void> init(BuildContext context) async {
    try {
      final token = await getToken(context);
      dioGlobal = Dio(
        BaseOptions(
            baseUrl: ApiClient.baseUrl, headers: {'Authorization': token}),
      );
      dioNoLogs = Dio(
        BaseOptions(
            baseUrl: ApiClient.baseUrl, headers: {'Authorization': token}),
      );
      dioGlobal.interceptors.addAll([
        AppInterceptors(dioGlobal),
      ]);
      // Fluttertoast.showToast(msg: 'DEBUG: ChatBloc init');
    } on Object catch (e) {
      Fluttertoast.showToast(msg: e.toString());
      log(e.toString());
      return;
    }
  }

  Future<ServerMasterProfile?> getMasterById(final int id) async {
    if (masters.containsKey(id)) {
      return masters[id];
    }
    try {
      final response = await dioGlobal
          .get('/mobil/get_user_info', queryParameters: {'masterId': id});
      final data = ServerMasterProfile.fromJson(response.data);
      masters[id] = data;
      return data;
    } on Object catch (e) {
      // Fluttertoast.showToast(msg: e.toString());
      log(e.toString());
      return null;
    }
  }

  FutureOr<void> _setMasterName(SetMasterName event, Emitter<ChatState> emit) {
    emit(state.copyWith(masterName: event.name));
    print('CHAT: Set master name success');
  }

  FutureOr<void> _setChatName(
      SetChatName event, Emitter<ChatState> emit) async {
    // Future<void> setChatName(String spec, String extraSpec) async {
    // try {
    // Fluttertoast.showToast(msg: 'DEBUG: ChatBloc setChatName');
    final response = await dioGlobal.get('/api/get_specialization_list');
    final rooms = (response.data as List).map((e) => ChatRoom.fromJson(e));

    if (event.extraSpec.isNotEmpty) {
      final pattern = '${event.spec}/${event.extraSpec}';

      print('Looking for $pattern chat');
      // ChatRoom? room;
      final room = rooms.firstWhere((element) =>
          element.nameOfCategory?.toLowerCase() == pattern.toLowerCase());

      // for (var element in rooms) {
      //   print(
      //       '${element.nameOfCategory} eq ${pattern == element.nameOfCategory}');
      //   if (pattern == element.nameOfCategory) {
      //     room = element;
      //   }
      // }
      // print("DATA FOR CHAT ${room?.chatId} ${room?.chatName}");
      emit(state.copyWith(
          chatName: room!.chatName!.replaceFirst('/', ''),
          chatId: room.chatId));
      // print('Emmited extra spec chat name');
    } else {
      final room = rooms.firstWhere((element) =>
          element.nameOfCategory?.toLowerCase() == event.spec.toLowerCase());
      emit(state.copyWith(
          chatName: room.chatName!.replaceFirst('/', ''), chatId: room.chatId));
    }
    // } on Object catch (e) {
    //   log(e.toString());
    // }
    restartTimer();
    getMessages();
  }

  Future<void> cancelTimer() async {
    timer?.cancel();
  }

  restartTimer() async {
    cancelTimer();
    timer = Timer.periodic(const Duration(seconds: 3), (_) {
      print('Update chat messages. ChatName=${state.chatName}');
      getMessages(showLogs: false);
    });
  }

  Future<void> getMessages({bool showLogs = true}) async {
    try {
      final response = showLogs
          ? await dioGlobal.get('/api/chats/${state.chatName}')
          : await dioNoLogs.get('/api/chats/${state.chatName}');
      final messages =
          (response.data as List).map((e) => ChatMessageServer.fromJson(e));
      final localMessages = <ChatMessage>[];
      for (final message in messages) {
        // final date = DateTime.fromMillisecondsSinceEpoch(message.createdAt);
        // print('date $date');
        if (message.mediaId != null) {
          localMessages.add(
            MediaChatMessage(
              mediaId: message.mediaId!,
              mediaName: message.mediaName!,
              senderId: message.customerId,
              dateTime: DateTime.fromMillisecondsSinceEpoch(message.createdAt),
              id: message.id,
              replyTo: message.replyTo,
            ),
          );
        } else {
          localMessages.add(
            TextChatMessage(
              text: message.content,
              senderId: message.customerId,
              dateTime: DateTime.fromMillisecondsSinceEpoch(message.createdAt),
              id: message.id,
              replyTo: message.replyTo,
            ),
          );
        }
      }
      Function eq = const ListEquality().equals;

      if (!eq(state.messages, localMessages)) {
        add(AddListOfMessages(localMessages));
        print('Update messages');
      }
      if (!state.isInitialized) {
        add(const IsInitialized(true));
      }
    } catch (e) {
      log(e.toString());
      cancelTimer();
    }
  }

  final TextEditingController controller = TextEditingController();
  final record = AudioRecorder();
  // final RecorderController recorderController = RecorderController();

  Future<Uint8List?> downloadMedia(int mediaId, String mediaName) async {
    try {
      final path = cachePathProvider.imagePath(mediaId, mediaName);
      final file = File(path);

      final response = await dioGlobal.download('/api/download/$mediaId', path);

      final bytes = file.readAsBytesSync();
      return bytes;
    } on Object catch (e) {
      log(e.toString());
      return null;
    }
  }

  Future<void> sendMessage(
    String chatName, {
    required int customerId,
    required int? mediaId,
    required String? mediaName,
    required String content,
  }) async {
    final replyTo = state.reply?.id;
    try {
      final data = {
        "content": content,
        "customerId": customerId,
        // "id": 0,
        "mediaId": mediaId,
        "mediaName": mediaName,
        "replyTo": replyTo,
        "sender": state.masterName,
        "type": "CHAT"
      };

      final response = await dioGlobal.post('/api/chats/$chatName', data: data);

      if (response.statusCode == 200 || response.statusCode == 201) {
        add(RemoveReply());
      }

      return;
    } on Object catch (e) {
      Fluttertoast.showToast(msg: e.toString());
      log(e.toString());
      return;
    }
  }

  Future<int?> uploadMedia(int chatId, Uint8List file, String fileName) async {
    try {
      FormData formData = FormData.fromMap({
        "file": MultipartFile.fromBytes(file, filename: fileName),
      });

      final response =
          await dioGlobal.post('/api/upload/chat/$chatId', data: formData);

      return response.data['id'];
    } on Object catch (e) {
      log(e.toString());
      return null;
    }
  }

  //   Future<List<int>?> uploadMedia(int mediaId) async {
  //   try {
  //     final response = await dioGlobal.get('/api/download/$mediaId');

  //     print(response.data);
  //     return [];
  //   } on Object catch (e) {
  //     log(e.toString());
  //   }
  // }

  FutureOr<void> _setTextInput(SetTextInput event, Emitter<ChatState> emit) {
    if (state.inputState != ChatInputState.inputText) {
      emit(state.copyWith(inputState: ChatInputState.inputText));
    }
  }

  FutureOr<void> _setInitialInput(
    SetInitialInput event,
    Emitter<ChatState> emit,
  ) {
    if (state.inputState != ChatInputState.initial) {
      emit(state.copyWith(inputState: ChatInputState.initial));
      // Fluttertoast.showToast(msg: 'DEBUG: ChatBloc _setInitialInput');
    }
  }

  FutureOr<void> _chooseImage(
    ChooseImage event,
    Emitter<ChatState> emit,
  ) {
    if (state.chosenFile != null) {
      add(RemoveFile(state.chosenFile!));
    }
    emit(
      state.copyWith(
        chosenImage: event.image,
        imageName: event.fileName,
      ),
    );
  }

  FutureOr<void> _removeImage(
    RemoveImage event,
    Emitter<ChatState> emit,
  ) {
    emit(state.copyWith(chosenImage: null, imageName: null));
  }

  FutureOr<void> _chooseFile(
    ChooseFile event,
    Emitter<ChatState> emit,
  ) {
    if (state.chosenImage != null) {
      add(RemoveImage(state.chosenImage!));
    }
    emit(state.copyWith(
      chosenFile: event.file,
      filename: event.fileName,
    ));
  }

  FutureOr<void> _removeFile(
    RemoveFile event,
    Emitter<ChatState> emit,
  ) {
    emit(state.copyWith(
      chosenFile: null,
      filename: null,
    ));
  }

  FutureOr<void> _startRecording(
    StartRecording event,
    Emitter<ChatState> emit,
  ) async {
    try {
      // Fluttertoast.showToast(msg: 'DEBUG: ChatBloc _startRecording 0');
      final d1EnSupport = await record.isEncoderSupported(AudioEncoder.wav);
      // Fluttertoast.showToast(    msg: 'DEBUG: ChatBloc _startRecording 0.1 $d1EnSupport');
      final d2HasPerms = await record.hasPermission();
      // Fluttertoast.showToast(msg: 'DEBUG: ChatBloc _startRecording 0.2 $d1EnSupport $d2HasPerms');
      final d3IsRec = await record.isRecording();
      // Fluttertoast.showToast(msg:'DEBUG: ChatBloc _startRecording 1 ${cachePathProvider.recordPath} enSupport=$d1EnSupport perms=${d2HasPerms} isrec=$d3IsRec');
      emit(state.copyWith(inputState: ChatInputState.recordingVoice));
      final chached = File(cachePathProvider.recordPath);
      if (chached.existsSync()) {
        chached.deleteSync();
      }
      // Fluttertoast.showToast(msg: 'DEBUG: ChatBloc _startRecording 1.1 ${cachePathProvider.recordPath} enSupport=$d1EnSupport perms=${d2HasPerms} isrec=$d3IsRec');
      await record.start(
        const RecordConfig(encoder: AudioEncoder.wav),
        path: cachePathProvider.recordPath,
      );
      final d4IsRec = await record.isRecording();
      // Fluttertoast.showToast(msg:  'DEBUG: ChatBloc _startRecording 2 ${cachePathProvider.recordPath} enSupport=$d1EnSupport perms=${d2HasPerms} isrec=$d4IsRec');
    } on Object catch (e) {
      Fluttertoast.showToast(msg: '_startRecording $e');
    }
  }

  Future<FutureOr<void>> _finishRecording(
    StopRecording event,
    Emitter<ChatState> emit,
  ) async {
    try {
      final d3IsRec = await record.isRecording();
      // Fluttertoast.showToast( msg: 'DEBUG: ChatBloc _finishRecording 1 isrec=$d3IsRec');
      String? d5Path;
      if (d3IsRec) {
        d5Path = await record.stop();
      }
      final d4IsRec = await record.isRecording();
      // Fluttertoast.showToast(msg: 'DEBUG: ChatBloc _finishRecording 2 isrec=$d4IsRec path=$d5Path');
      emit(state.copyWith(inputState: ChatInputState.finishedVoice));
    } on Object catch (e) {
      Fluttertoast.showToast(msg: e.toString());
    }
  }

  Future<FutureOr<void>> _deleteRecording(
    DeleteRecording event,
    Emitter<ChatState> emit,
  ) async {
    controller.clear();
    record.stop();
    final chached = File(cachePathProvider.recordPath);
    chached.deleteSync();
    emit(state.copyWith(inputState: ChatInputState.initial));
  }

  FutureOr<void> _addTextMessage(
    AddTextMessage event,
    Emitter<ChatState> emit,
  ) {
    emit(state.copyWith(messages: [...state.messages, event.textChatMessage]));
  }

  FutureOr<void> _addMediaMessage(
    AddMediaMessage event,
    Emitter<ChatState> emit,
  ) {
    emit(state.copyWith(messages: [...state.messages, event.mediaChatMessage]));
  }

  FutureOr<void> _sendTextMessage(
    SendTextMessage event,
    Emitter<ChatState> emit,
  ) async {
    if (isSendingMsg) return;
    isSendingMsg = true;
    // emit(state.copyWith(messages: [...state.messages, event.textChatMessage]));
    // add(AddTextMessage(event.textChatMessage));
    await sendMessage(
      state.chatName,
      customerId: event.masterId,
      mediaId: null,
      mediaName: null,
      content: event.textChatMessage.text,
    );
    getMessages();
    controller.clear();
    emit(state.copyWith(inputState: ChatInputState.initial));
    isSendingMsg = false;
  }

  FutureOr<void> _sendMediaMessage(
    SendMediaMessage event,
    Emitter<ChatState> emit,
  ) async {
    if (isSendingMsg) return;
    isSendingMsg = true;
    // emit(state.copyWith(messages: [...state.messages, event.textChatMessage]));
    // AddMediaMessage(event.mediaChatMessage);
    final id = await uploadMedia(state.chatId, event.file, event.fileName);
    if (state.chosenImage != null) {
      add(RemoveImage(state.chosenImage!));
    }
    if (state.chosenFile != null) {
      add(RemoveFile(state.chosenFile!));
    }

    if (id != null) {
      await sendMessage(
        state.chatName,
        customerId: event.masterId,
        mediaId: id,
        mediaName: event.fileName,
        content: '',
      );
      getMessages();
      // add()
      // add(AddMediaMessage(
      //   MediaChatMessage(
      //     mediaId: id,
      //     mediaName: event.fileName,
      //     dateTime: DateTime.now(),
      //     senderId: event.masterId,
      //   ),
      // ),
    }
    isSendingMsg = false;
  }

  FutureOr<void> _addListOfMessages(
    AddListOfMessages event,
    Emitter<ChatState> emit,
  ) {
    emit(state.copyWith(messages: event.messages));
  }

  FutureOr<void> _setLoading(
    IsInitialized event,
    Emitter<ChatState> emit,
  ) {
    emit(state.copyWith(isInitialized: event.isInitialized));
  }

  FutureOr<void> _sendVoiceMessage(
    SendVoiceMessage event,
    Emitter<ChatState> emit,
  ) async {
    if (isSendingMsg) return;
    isSendingMsg = true;
    // emit(state.copyWith(messages: [...state.messages, event.textChatMessage]));
    // AddMediaMessage(event.mediaChatMessage);
    final id = await uploadMedia(state.chatId, event.file, event.fileName);
    if (id != null) {
      add(const DeleteRecording());
      await sendMessage(
        state.chatName,
        customerId: event.masterId,
        mediaId: id,
        mediaName: event.fileName,
        content: '',
      );
      getMessages();
      // add(AddMediaMessage(
      //   MediaChatMessage(
      //     mediaId: id,
      //     mediaName: event.fileName,
      //     dateTime: DateTime.now(),
      //     senderId: event.masterId,
      //   ),
      // ));
    }
    isSendingMsg = false;
  }

  FutureOr<void> _stopCurrentVoice(
    StopCurrentVoice event,
    Emitter<ChatState> emit,
  ) {
    if (state.currentVoicePlayer != null) {
      state.currentVoicePlayer!.stop();
      emit(state.copyWith(currentVoicePlayer: null));
    }
  }

  FutureOr<void> _startListeningToVoice(
    StartListeningToVoice event,
    Emitter<ChatState> emit,
  ) {
    emit(state.copyWith(currentVoicePlayer: event.player));
    event.player.play();
  }

  FutureOr<void> _addReply(
    AddReply event,
    Emitter<ChatState> emit,
  ) {
    emit(state.copyWith(reply: event.msg));
  }

  FutureOr<void> _removeReply(
    RemoveReply event,
    Emitter<ChatState> emit,
  ) {
    emit(state.copyWith(reply: null));
  }
}

final cachePathProvider = CachePathProvider();

class CachePathProvider {
  String basePath = '';

  init() async {
    Directory appDocDirectory = await getApplicationDocumentsDirectory();

    final dir =
        await Directory('${appDocDirectory.path}').create(recursive: true);
    basePath = dir.absolute.uri.toFilePath();
    basePath = basePath.substring(0, basePath.lastIndexOf('/'));
    print('basePath=$basePath');
  }

  String get recordPath => '$basePath/record.mpeg4';

  String imagePath(final int id, final String name) {
    return '$basePath/$id-$name';
  }

  // String get videoTmp => '$basePath/tmp.mp4';

  // String saveImage(final int id, final Uint8List bytes) {
  //   final file = File(imagePath(id));
  //   if (file.existsSync()) {
  //     file.deleteSync();
  //   }
  //   file.createSync();
  //   file.writeAsBytesSync(bytes);
  //   return '$basePath/img-$id';
  // }

  // Uint8List getSavedImage(final int id) {
  //   return File(imagePath(id)).readAsBytesSync();
  // }
}
