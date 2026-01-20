import 'dart:developer';
import 'dart:io';

import 'package:auto_master/app/domain/states/chat/chat_bloc.dart';
import 'package:auto_master/app/domain/states/master/master_profile_state.dart';
import 'package:auto_master/app/ui/theme/theme.dart';
import 'package:auto_master/app/ui/utils/pick_image.dart';
import 'package:auto_master/app/ui/widgets/dialogs/show_select_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ChatInputIcon extends StatelessWidget {
  const ChatInputIcon({
    required this.fillColor,
    required this.foregroundColor,
    required this.iconData,
    required this.onPressed,
    super.key,
  });

  final void Function()? onPressed;
  final IconData iconData;
  final Color fillColor;
  final Color foregroundColor;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 42,
      height: 42,
      child: CircleAvatar(
        backgroundColor: fillColor,
        radius: 20,
        child: IconButton(
          padding: EdgeInsets.zero,
          // constraints: const BoxConstraints(),
          color: foregroundColor,
          onPressed: onPressed,
          splashRadius: 20,
          icon: Icon(iconData, size: 22),
        ),
      ),
    );
  }
}

class AddPhotoInputIcon extends StatelessWidget {
  const AddPhotoInputIcon({super.key});

  @override
  Widget build(BuildContext context) {
    return ChatInputIcon(
      fillColor: Colors.transparent,
      iconData: Icons.add,
      foregroundColor: AppColors.main,
      onPressed: () {
        final chatBloc = BlocProvider.of<ChatBloc>(context);
        showSelectImage(
          context,
          onGalleryPress: () async {
            final PickImageState? image = await pickImageOrVideoOrFile();

            if (image != null) {
              switch (image.type) {
                case AttachType.photo:
                  chatBloc.add(ChooseImage(image.data, image.name));
                  break;
                case AttachType.video:
                  chatBloc.add(ChooseFile(image.data, image.name));
                  break;
                case AttachType.file:
                case AttachType.voice:
                  break;
              }

              // Navigator.of(context).pop();
            }
          },
          onCameraPress: () async {
            pickImageCamera(context, enableRecordingTmp: true,
                onGetCaptureDataTmp: (image) {
              if (image != null) {
                switch (image.type) {
                  case AttachType.photo:
                    chatBloc.add(ChooseImage(image.data, image.name));
                    break;
                  case AttachType.video:
                    chatBloc.add(ChooseFile(image.data, image.name));
                    break;
                  case AttachType.file:
                  case AttachType.voice:
                    break;
                }

                // Navigator.of(context).pop();
              }
            });
          },
        );
      },
    );
  }
}

class StartVoiceInputIcon extends StatelessWidget {
  const StartVoiceInputIcon({super.key});

  @override
  Widget build(BuildContext context) {
    return ChatInputIcon(
      fillColor: Colors.transparent,
      iconData: Icons.mic,
      foregroundColor: AppColors.main,
      onPressed: () async {
        try {
          final chatBloc = BlocProvider.of<ChatBloc>(context);
          chatBloc.add(const StartRecording());
        } on Object catch (e) {
          Fluttertoast.showToast(msg: e.toString());
          log(e.toString());
          return;
        }
      },
    );
  }
}

class FinishVoiceInputIcon extends StatelessWidget {
  const FinishVoiceInputIcon({super.key});

  @override
  Widget build(BuildContext context) {
    return ChatInputIcon(
      fillColor: AppColors.grey,
      iconData: Icons.mic,
      foregroundColor: Colors.white,
      onPressed: () {
        try {
          final chatBloc = BlocProvider.of<ChatBloc>(context);
          chatBloc.add(const StopRecording());
        } on Object catch (e) {
          Fluttertoast.showToast(msg: e.toString());
          log(e.toString());
          return;
        }
      },
    );
  }
}

class DeleteRecordingInputIcon extends StatelessWidget {
  const DeleteRecordingInputIcon({super.key});

  @override
  Widget build(BuildContext context) {
    return ChatInputIcon(
      fillColor: Colors.transparent,
      iconData: Icons.close,
      foregroundColor: AppColors.main,
      onPressed: () {
        final chatBloc = BlocProvider.of<ChatBloc>(context);
        chatBloc.add(const DeleteRecording());
        chatBloc.add(const StopCurrentVoice());
      },
    );
  }
}

class SendVoiceInputIcon extends StatelessWidget {
  const SendVoiceInputIcon({super.key});

  @override
  Widget build(BuildContext context) {
    return ChatInputIcon(
      fillColor: AppColors.main,
      iconData: Icons.send,
      foregroundColor: Colors.white,
      onPressed: () {
        final chatBloc = BlocProvider.of<ChatBloc>(context);
        final read = context.read<MasterProfileState>();
        final senderId = read.profile!.id;

        // final isMe = read.profile!.id == senderId;

        final path = cachePathProvider.recordPath;
        final file = File(path);
        final bytes = file.readAsBytesSync();
        chatBloc.add(
          SendVoiceMessage(
            file: bytes,
            fileName: 'user_record.wav',
            masterId: senderId,
          ),
        );
      },
    );
  }
}

class RemoveReplyInputIcon extends StatelessWidget {
  const RemoveReplyInputIcon({super.key});

  @override
  Widget build(BuildContext context) {
    return ChatInputIcon(
      fillColor: Colors.transparent,
      iconData: Icons.close,
      foregroundColor: AppColors.main,
      onPressed: () {
        final chatBloc = BlocProvider.of<ChatBloc>(context);
        chatBloc.add(const RemoveReply());
      },
    );
  }
}

class SendMsgInputIcon extends StatelessWidget {
  const SendMsgInputIcon({super.key});

  @override
  Widget build(BuildContext context) {
    return ChatInputIcon(
      fillColor: AppColors.main,
      iconData: Icons.send,
      foregroundColor: Colors.white,
      onPressed: () async {
        final chatBloc = BlocProvider.of<ChatBloc>(context);
        final read = context.read<MasterProfileState>();
        final senderId = read.profile!.id;

        final chatState = chatBloc.state;
        final chosenImage = chatState.chosenImage;
        // final isMe = read.profile!.id == senderId;
        if (chosenImage != null) {
          // final path = cachePathProvider.saveImage(-1, chosenImage);
          chatBloc.add(
            SendMediaMessage(
              file: chosenImage,
              fileName: chatState.imageName ?? 'image',
              masterId: senderId,
            ),
          );
        }
        final chosenFile = chatState.chosenFile;
        if (chosenFile != null) {
          // final path = cachePathProvider.saveImage(-1, chosenImage);
          chatBloc.add(
            SendMediaMessage(
              file: chosenFile,
              fileName: chatState.filename ?? 'file',
              masterId: senderId,
            ),
          );
        }
        final inputText = chatBloc.controller.text.trim();
        if (inputText.isNotEmpty) {
          chatBloc.add(
            SendTextMessage(
              TextChatMessage(
                text: inputText,
                dateTime: DateTime.now(),
                senderId: senderId,
                id: null,
                replyTo: null,
              ),
              senderId,
            ),
          );
        }
      },
    );
  }
}

class PhotoVariantInputIcon extends StatelessWidget {
  const PhotoVariantInputIcon({
    required this.text,
    required this.asset,
    required this.onTap,
    super.key,
  });

  final String text;
  final String asset;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: const BorderRadius.all(Radius.circular(25)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: SizedBox(
          width: 80,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SvgPicture.asset(
                asset,
                height: 48,
                width: 48,
              ),
              const SizedBox(height: 8),
              Text(
                text,
                style: const TextStyle(
                  fontFamily: 'Montserrat',
                  fontWeight: FontWeight.w400,
                  fontSize: 10,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
