import 'dart:async';
import 'dart:io';

import 'package:auto_master/app/domain/states/chat/chat_bloc.dart';
import 'package:auto_master/app/ui/screens/chat/widget/chat_input_icons.dart';
import 'package:auto_master/app/ui/screens/chat/widget/chat_text_widget.dart';
import 'package:auto_master/app/ui/theme/app_colors.dart';
import 'package:auto_master/app/ui/theme/app_text_style.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:just_audio/just_audio.dart';

class ChatUserInput extends StatelessWidget {
  const ChatUserInput({super.key});

  @override
  Widget build(BuildContext context) {
    final chatBloc = BlocProvider.of<ChatBloc>(context);
    return BlocBuilder<ChatBloc, ChatState>(builder: (context, state) {
      print('Build input');

      Widget prefixIcon = const SizedBox();
      switch (state.inputState) {
        case ChatInputState.initial:
        case ChatInputState.inputText:
          prefixIcon = const AddPhotoInputIcon();
          break;
        case ChatInputState.recordingVoice:
          prefixIcon = const SizedBox();
          break;
        case ChatInputState.finishedVoice:
          prefixIcon = const DeleteRecordingInputIcon();
          break;
      }

      Widget suffixIcon = const SizedBox();
      switch (state.inputState) {
        case ChatInputState.initial:
          if (state.chosenImage != null || state.chosenFile != null) {
            suffixIcon = const SendMsgInputIcon();
          } else {
            suffixIcon = const StartVoiceInputIcon();
          }
          break;
        case ChatInputState.inputText:
          suffixIcon = const SendMsgInputIcon();
          break;
        case ChatInputState.recordingVoice:
          suffixIcon = const FinishVoiceInputIcon();
          break;
        case ChatInputState.finishedVoice:
          suffixIcon = const SendVoiceInputIcon();
          break;
      }

      Widget mainStuff = const SizedBox();
      switch (state.inputState) {
        case ChatInputState.recordingVoice:
          mainStuff = Padding(
            padding:
                const EdgeInsets.only(left: 8, right: 8, bottom: 4, top: 4),
            child: Row(
              // mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // prefixIcon,
                const SizedBox(width: 16),
                const TimerText(),
                const SizedBox(width: 16),
                const Text('Идёт запись'),
                const Spacer(),
                suffixIcon,
              ],
            ),
          );
          break;
        case ChatInputState.finishedVoice:
          mainStuff = Padding(
            padding:
                const EdgeInsets.only(left: 8, right: 8, bottom: 4, top: 4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                prefixIcon,
                Flexible(
                  child: ListenRecordedVoice(
                    path: cachePathProvider.recordPath,
                  ),
                ),
                suffixIcon,
              ],
            ),
          );
          break;
        default:
          mainStuff = Padding(
            padding:
                const EdgeInsets.only(left: 8, right: 8, bottom: 4, top: 4),
            child: TextField(
              controller: chatBloc.controller,
              onChanged: (value) => value.isNotEmpty
                  ? chatBloc.add(const SetTextInput())
                  : chatBloc.add(const SetInitialInput()),
              maxLines: 1,
              clipBehavior: Clip.antiAlias,
              cursorColor: AppColors.main,
              decoration: InputDecoration(
                hintText: 'Введите сообщение',
                hintStyle: AppTextStyle.s14w400.copyWith(
                  color: AppColors.grey,
                ),
                prefixIcon: prefixIcon,
                suffixIcon: suffixIcon,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
              ),
            ),
          );
      }

      return Padding(
        padding: const EdgeInsets.only(left: 16, right: 16, top: 8),
        child: SizedBox(
          // height: state.chosenImage != null ? 168 : 56,
          child: Ink(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(35),
              boxShadow: [
                BoxShadow(
                  blurRadius: 4,
                  color: Colors.black.withOpacity(.25),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ShowReply(reply: state.reply),
                ChosenImages(state: state),
                ChosenFile(state: state),
                mainStuff,
              ],
            ),
          ),
        ),
      );
    });
  }
}

class ShowReply extends StatelessWidget {
  const ShowReply({required this.reply, super.key});

  final ChatMessage? reply;

  @override
  Widget build(BuildContext context) {
    if (reply == null) {
      return const SizedBox();
    } else {
      switch (reply!.msgType) {
        case ChatMessageType.text:
          final rt = reply as TextChatMessage;
          return ReplyWidget(rt.text);
        case ChatMessageType.media:
          return const ReplyWidget("файл");
      }
    }
  }
}

class ReplyWidget extends StatelessWidget {
  final String text;

  const ReplyWidget(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const SizedBox(width: 16),
        const Icon(Icons.reply),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'В ответ',
                style: AppTextStyle.s14w400,
              ),
              Flexible(
                child: Text(
                  text,
                  style: AppTextStyle.s14w400.copyWith(
                    color: AppColors.grey,
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              ),
            ],
          ),
        ),
        // Spacer(),
        const SizedBox(width: 8),
        const RemoveReplyInputIcon(),
        const SizedBox(width: 8),
      ],
    );
  }
}

class TimerText extends StatefulWidget {
  const TimerText({super.key});

  @override
  State<StatefulWidget> createState() => TimerState();
}

class TimerState extends State<TimerText> {
  Timer? _timer;

  int seconds = 0;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(Durations.extralong4, (timer) {
      setState(() {
        seconds++;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final minutesText = seconds ~/ 60;
    final secondsText = (seconds - minutesText * 60).toString().padLeft(2, '0');
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        AnimatedOpacity(
          opacity: seconds % 2,
          duration: const Duration(milliseconds: 900),
          child: Container(
            height: 8,
            width: 8,
            decoration: const BoxDecoration(
              color: Colors.red,
              shape: BoxShape.circle,
            ),
          ),
        ),
        const SizedBox(width: 8),
        Text('$minutesText:$secondsText')
      ],
    );
  }

  @override
  dispose() {
    _timer?.cancel();
    super.dispose();
  }
}

class ChosenFile extends StatelessWidget {
  final ChatState state;

  const ChosenFile({required this.state, super.key});

  @override
  Widget build(BuildContext context) {
    if (state.chosenFile != null) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.only(left: 8, top: 8, bottom: 2),
            height: 90,
            width: 90,
            child: Stack(
              children: [
                Container(
                  margin: const EdgeInsets.all(5),
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(25),
                    color: Colors.grey.shade100,
                    // image: DecorationImage(
                    //   fit: BoxFit.cover,
                    //   image: MemoryImage(
                    //     state.chosenImage!,
                    //   ),
                    // ),
                  ),
                  child: Icon(Icons.file_present_sharp),
                ),
                Positioned(
                  right: 0,
                  top: 0,
                  child: CircleAvatar(
                    radius: 12,
                    backgroundColor: AppColors.grey,
                    child: IconButton.filled(
                      style:
                          IconButton.styleFrom(backgroundColor: AppColors.grey),
                      color: Colors.white,
                      iconSize: 16,
                      constraints: const BoxConstraints(),
                      padding: EdgeInsets.zero,
                      onPressed: () {
                        final chatBloc = BlocProvider.of<ChatBloc>(context);
                        chatBloc.add(RemoveFile(state.chosenFile!));
                      },
                      icon: const Icon(Icons.close),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const Divider(
            indent: 8,
            endIndent: 8,
            height: 12,
          ),
        ],
      );
    } else {
      return const SizedBox();
    }
  }
}

class ChosenImages extends StatelessWidget {
  final ChatState state;

  const ChosenImages({required this.state, super.key});

  @override
  Widget build(BuildContext context) {
    if (state.chosenImage != null &&
        !(state.inputState == ChatInputState.recordingVoice ||
            state.inputState == ChatInputState.finishedVoice)) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.only(left: 8, top: 8, bottom: 2),
            height: 90,
            width: 90,
            child: Stack(
              children: [
                Container(
                  margin: const EdgeInsets.all(5),
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(25),
                    image: DecorationImage(
                      fit: BoxFit.cover,
                      image: MemoryImage(
                        state.chosenImage!,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  right: 0,
                  top: 0,
                  child: CircleAvatar(
                    radius: 12,
                    backgroundColor: AppColors.grey,
                    child: IconButton.filled(
                      style:
                          IconButton.styleFrom(backgroundColor: AppColors.grey),
                      color: Colors.white,
                      iconSize: 16,
                      constraints: const BoxConstraints(),
                      padding: EdgeInsets.zero,
                      onPressed: () {
                        final chatBloc = BlocProvider.of<ChatBloc>(context);
                        chatBloc.add(RemoveImage(state.chosenImage!));
                      },
                      icon: const Icon(Icons.close),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const Divider(
            indent: 8,
            endIndent: 8,
            height: 12,
          ),
        ],
      );
    } else {
      return const SizedBox();
    }
  }
}

class ListenRecordedVoice extends StatefulWidget {
  const ListenRecordedVoice({required this.path, super.key});

  final String path;

  @override
  State<StatefulWidget> createState() => _State();
}

class _State extends State<ListenRecordedVoice> {
  final player = AudioPlayer();

  bool isReady = false;

  @override
  void initState() {
    super.initState();
    loadAudio();
  }

  loadAudio() async {
    print('LOADING AUDIO ${widget.path} ${File(widget.path).existsSync()}');
    try {
      await player.setFilePath(widget.path);
    } on Object catch (e) {
      print(e);
      Fluttertoast.showToast(msg: "Ошибка при загрузке аудио: $e");
    }

    setState(() {
      isReady = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48,
      // padding: const EdgeInsets.symmetric(vertical: 8),
      child: isReady
          ? Row(
              children: [
                // const SizedBox(width: 16),
                StreamBuilder<PlayerState>(
                  stream: player.playerStateStream,
                  builder: (context, snapshot) {
                    final playerState = snapshot.data;
                    final processingState = playerState?.processingState;
                    final playing = playerState?.playing;
                    if (processingState == ProcessingState.loading ||
                        processingState == ProcessingState.buffering) {
                      return const SizedBox(
                        width: 24.0,
                        height: 24.0,
                        child: Center(
                          child: CircularProgressIndicator(),
                        ),
                      );
                    } else if (playing != true) {
                      return FastIconButton(
                          icon: Icons.play_arrow,
                          onPressed: () {
                            BlocProvider.of<ChatBloc>(context)
                                .add(const StopCurrentVoice());
                            BlocProvider.of<ChatBloc>(context)
                                .add(StartListeningToVoice(player));
                          });
                    } else if (processingState != ProcessingState.completed) {
                      return FastIconButton(
                          icon: Icons.pause, onPressed: player.pause);
                    } else {
                      return FastIconButton(
                        icon: Icons.replay,
                        onPressed: () => player.seek(Duration.zero),
                      );
                    }
                  },
                ),
                Flexible(
                  child: StreamBuilder<Duration>(
                    stream: player.positionStream,
                    builder: (context, snapshot) {
                      final playerState = snapshot.data;
                      return SeekBar(
                        duration: player.duration ?? Duration.zero,
                        position: playerState ?? Duration.zero,
                        bufferedPosition: playerState ?? Duration.zero,
                        onChangeEnd: player.seek,
                      );
                    },
                  ),
                ),
                // const SizedBox(width: 16),
              ],
            )
          : const Center(
              child: CircularProgressIndicator(color: AppColors.main),
            ),
    );
  }
}

class FastIconButton extends StatelessWidget {
  final void Function()? onPressed;

  final IconData icon;

  const FastIconButton(
      {required this.icon, required this.onPressed, super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      padding: EdgeInsets.zero,
      constraints: const BoxConstraints(),
      icon: Icon(icon),
      color: AppColors.main,
      onPressed: onPressed,
    );
  }
}
