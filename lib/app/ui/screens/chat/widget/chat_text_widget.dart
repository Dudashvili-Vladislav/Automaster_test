import 'dart:io';
import 'dart:math';
import 'dart:typed_data';
import 'dart:ui';

import 'package:auto_master/app/app.dart';
import 'package:auto_master/app/data/api_client.dart';
import 'package:auto_master/app/domain/models/server_master_profile.dart';
import 'package:auto_master/app/domain/states/chat/chat_bloc.dart';
import 'package:auto_master/app/domain/states/master/master_profile_state.dart';
import 'package:auto_master/app/ui/theme/theme.dart';
import 'package:auto_master/app/ui/utils/pick_image.dart';
import 'package:auto_master/app/ui/widgets/camera_page.dart';
import 'package:auto_master/resources/resources.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:photo_view/photo_view.dart';
import 'package:just_audio/just_audio.dart';
import 'package:share_plus/share_plus.dart';
import 'package:swipeable_tile/swipeable_tile.dart';

class ChatMessageWidget extends StatelessWidget {
  const ChatMessageWidget({
    required this.chatMessage,
    super.key,
  });

  final ChatMessage chatMessage;

  @override
  Widget build(BuildContext context) {
    Widget? child;
    switch (chatMessage.msgType) {
      case ChatMessageType.text:
        child = ChatText(chatMessage: chatMessage as TextChatMessage);
      case ChatMessageType.media:
        child = ChatMedia(mediaMessage: chatMessage as MediaChatMessage);
    }

    return SwipeableTile.swipeToTrigger(
      color: Colors.white,
      swipeThreshold: 0.2,
      isElevated: false,
      direction: SwipeDirection.endToStart,
      // confirmSwipe: (direction) => Future.value(false),
      onSwiped: (direction) {
        print('add reply');
        BlocProvider.of<ChatBloc>(context).add(AddReply(chatMessage));
        // Here call setState to update state
      },
      backgroundBuilder: (context, direction, progress) {
        return const SizedBox();
        if (direction == SwipeDirection.endToStart) {
          // return your widget
        } else if (direction == SwipeDirection.startToEnd) {
          // return your widget
        }
        return Container();
      },
      key: UniqueKey(),
      child: child,
    );
    // return child;
  }
}

class BasicContainer extends StatelessWidget {
  const BasicContainer({
    required this.child,
    required this.senderId,
    required this.bg,
    required this.padding,
    required this.replyTo,
    required this.moreLeftPadding,
    required this.msgDateTime,
    required this.isTextMessage,
    super.key,
  });

  final int? replyTo;
  final Widget child;
  final int? senderId;
  final Color bg;
  final EdgeInsets padding;
  final double moreLeftPadding;
  final DateTime msgDateTime;
  final bool isTextMessage;

  @override
  Widget build(BuildContext context) {
    final read = context.read<MasterProfileState>();
    final isMe = read.profile!.id == senderId;
    final chatBloc = BlocProvider.of<ChatBloc>(context);

    print('$isTextMessage $senderId');

    ChatMessage? reply;
    ServerMasterProfile? replyProfile;
    if (replyTo != null) {
      for (var element in chatBloc.state.messages) {
        if (element.id == replyTo) {
          reply = element;
        }
      }
    }

    final Future<ServerMasterProfile?> calculation =
        Future<ServerMasterProfile?>.microtask(() async {
      if (reply != null) {
        if (reply.senderId == null) {
          replyProfile =
              ServerMasterProfile(name: 'Админ', phone: '', avatarUrl: '');
        } else {
          final resReply = await chatBloc.getMasterById(reply.senderId!);
          if (resReply == null) {
            replyProfile = ServerMasterProfile(
                name: 'Пользователь удалён', phone: '', avatarUrl: '');
          } else {
            replyProfile = resReply;
          }
        }
      }

      if (senderId == null) {
        return ServerMasterProfile(name: 'Админ', phone: '', avatarUrl: '');
      }
      final res = await chatBloc.getMasterById(senderId!);
      if (res == null) {
        return ServerMasterProfile(
            name: 'Пользователь удалён', phone: '', avatarUrl: '');
      }
      return res;
      // final path = cachePathProvider.imagePath(mediaMessage.mediaId);
      // Uint8List? bytes;
      // if (File(path).existsSync()) {
      //   bytes = File(path).readAsBytesSync();
      // } else {
      // bytes = await BlocProvider.of<ChatBloc>(context)
      //     .downloadMedia(mediaMessage.mediaId);
      // }
    });

    return FutureBuilder(
      future: calculation,
      builder: (context, snapshot) {
        String masterAvatar = '';
        String? masterName;
        if (snapshot.hasData) {
          masterName = snapshot.data!.name;
          masterAvatar = snapshot.data!.avatarUrl ?? '';
        }

        return Align(
          alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisSize: MainAxisSize.min,
            children: [
              if (!isMe)
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8),
                  child: MasterAvatar(
                    masterAvatar: masterAvatar,
                  ),
                ),
              Flexible(
                child: Container(
                  decoration: BoxDecoration(
                    color: bg,
                    // border: Border.all(color: Colors.white),
                    borderRadius: BorderRadius.only(
                      topLeft: const Radius.circular(16),
                      topRight: const Radius.circular(16),
                      bottomLeft: isMe
                          ? const Radius.circular(16)
                          : const Radius.circular(4),
                      bottomRight: isMe
                          ? const Radius.circular(4)
                          : const Radius.circular(16),
                    ),
                  ),
                  padding: padding,
                  margin: EdgeInsets.only(
                    left: isMe ? 40 : 8,
                    right: isMe ? 8 : 40,
                  ),
                  child: IntrinsicWidth(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        MasterName(
                          moreLeftPadding: moreLeftPadding,
                          masterName: masterName ?? '...',
                        ),
                        ReplyFragment(
                          masterName: replyProfile?.name ?? 'В ответ',
                          reply: reply,
                          moreLeftPadding: moreLeftPadding,
                        ),
                        child,
                        if (isTextMessage)
                          Align(
                            alignment: Alignment.bottomRight,
                            child: MessageTimeRow(
                              msgDateTime,
                              color: Colors.white,
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class MasterAvatar extends StatelessWidget {
  final String masterAvatar;

  const MasterAvatar({required this.masterAvatar});

  @override
  Widget build(BuildContext context) {
    if (masterAvatar.isEmpty) {
      return Container(
        height: 24,
        width: 24,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: AppColors.main,
        ),
      );
    }
    return Container(
      width: 24.0,
      height: 24.0,
      // margin: EdgeInsets.only(right: 12),
      clipBehavior: Clip.hardEdge,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
      ),
      child: CachedNetworkImage(
        imageUrl: '${ApiClient.baseImageUrl}${masterAvatar}',
        fit: BoxFit.cover,
        width: 24,
        height: 24,
      ),
    );
  }
}

class MasterName extends StatelessWidget {
  final double moreLeftPadding;
  final String masterName;

  const MasterName({
    super.key,
    required this.moreLeftPadding,
    required this.masterName,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: moreLeftPadding, top: 4, bottom: 4),
      child: SizedBox(
        height: 24,
        child: Text(
          masterName,
          style: AppTextStyle.s14w700.copyWith(
            color: Colors.white,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ),
    );
  }
}

class MessageTimeRow extends StatelessWidget {
  const MessageTimeRow(this.dateTime, {required this.color, super.key});

  final DateTime dateTime;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final hours = dateTime.hour.toString().padLeft(2, '0');
    final minutes = dateTime.minute.toString().padLeft(2, '0');
    final data = '$hours:$minutes';
    return Text(
      data,
      style: AppTextStyle.s12w400.copyWith(
        color: color,
      ),
    );
  }
}

class ReplyFragment extends StatelessWidget {
  const ReplyFragment({
    required this.reply,
    required this.moreLeftPadding,
    required this.masterName,
    super.key,
  });

  final ChatMessage? reply;
  final double moreLeftPadding;
  final String masterName;

  @override
  Widget build(BuildContext context) {
    // print(reply?.id);

    if (reply != null) {
      String replyBody;
      switch (reply!.msgType) {
        case ChatMessageType.text:
          final rt = reply as TextChatMessage;
          replyBody = rt.text;
        case ChatMessageType.media:
          replyBody = 'файл';
      }
      return Container(
        decoration: const BoxDecoration(
          border: Border(
            left: BorderSide(color: Colors.white, width: 2),
          ),
        ),
        padding: const EdgeInsets.only(left: 8),
        margin: EdgeInsets.only(
          bottom: 8,
          top: 8,
          left: moreLeftPadding,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              masterName,
              style: AppTextStyle.s14w400.copyWith(
                color: Colors.white,
              ),
            ),
            Flexible(
              child: Text(
                replyBody,
                style: AppTextStyle.s14w400.copyWith(
                  color: Colors.white,
                ),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
            ),
            // Text('В ответ'),
            // Text(replyBody),
          ],
        ),
      );
    } else {
      return const SizedBox();
    }
  }
}

class ChatText extends StatelessWidget {
  const ChatText({
    required this.chatMessage,
    super.key,
  });

  final TextChatMessage chatMessage;

  @override
  Widget build(BuildContext context) {
    return BasicContainer(
      senderId: chatMessage.senderId,
      replyTo: chatMessage.replyTo,
      msgDateTime: chatMessage.dateTime,
      moreLeftPadding: 0,
      bg: resolveMSGColor(chatMessage.senderId, context),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      isTextMessage: true,
      child:
          // IntrinsicWidth(
          //   child: Column(
          //     mainAxisSize: MainAxisSize.min,
          //     children: [
          //       Flexible(
          //         child: Align(
          //           alignment: Alignment.centerLeft,
          //           child:
          Text(
        chatMessage.text,
        style: const TextStyle(
          fontFamily: 'Montserrat',
          fontSize: 12.0,
          fontWeight: FontWeight.w500,
          color: Colors.white,
        ),
      ),
      //         ),
      //       ),
      //       Align(
      //         alignment: Alignment.bottomRight,
      //         child: MessageTimeRow(chatMessage.dateTime),
      //       ),
      //     ],
      //   ),
      // ),
    );
  }
}

class _Resolve {
  final Uint8List data;
  final AttachType type;
  final String path;

  const _Resolve({
    required this.data,
    required this.path,
    required this.type,
  });
}

class ChatMedia extends StatelessWidget {
  const ChatMedia({
    required this.mediaMessage,
    super.key,
  });

  final MediaChatMessage mediaMessage;

  @override
  Widget build(BuildContext context) {
    final Future<_Resolve?> calculation = Future<_Resolve?>.microtask(() async {
      final path = cachePathProvider.imagePath(
          mediaMessage.mediaId, mediaMessage.mediaName);
      // print('MEDIA NAME: ${mediaMessage.mediaName}');
      Uint8List? bytes;
      if (File(path).existsSync()) {
        bytes = File(path).readAsBytesSync();
      } else {
        bytes = await BlocProvider.of<ChatBloc>(context)
            .downloadMedia(mediaMessage.mediaId, mediaMessage.mediaName);
      }

      bool isImage = false;
      if (bytes != null) {
        AttachType type = AttachType.file;
        if (mediaMessage.mediaName.endsWith('.wav') ||
            mediaMessage.mediaName == 'blob') {
          type = AttachType.voice;
        }
        if (mediaMessage.mediaName.endsWith('.mp4')) {
          type = AttachType.video;
        }
        try {
          final codec = await instantiateImageCodec(bytes, targetWidth: 32);
          final frameInfo = await codec.getNextFrame();
          isImage = frameInfo.image.width > 0;
          if (isImage) {
            type = AttachType.photo;
          }
        } on Object {}

        return _Resolve(data: bytes, type: type, path: path);
      }

      throw Exception('Could not find mediaId ${mediaMessage.mediaId}');
    });

    return FutureBuilder<_Resolve?>(
        future: calculation,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return SizedBox(
              child: Center(
                child: Text(snapshot.error.toString()),
              ),
            );
          }

          if (snapshot.hasData) {
            switch (snapshot.data!.type) {
              case AttachType.photo:
                return ChatImage(
                  mediaChatMessage: mediaMessage,
                  senderId: mediaMessage.senderId,
                  bytes: snapshot.data!.data,
                  replyTo: mediaMessage.replyTo,
                );
              case AttachType.voice:
                // return SizedBox();
                return ChatVoice(
                  mediaChatMessage: mediaMessage,
                  path: snapshot.data!.path,
                  senderId: mediaMessage.senderId,
                  replyTo: mediaMessage.replyTo,
                );

              case AttachType.video:
                return ChatVideo(
                  mediaChatMessage: mediaMessage,
                  // bytes: snapshot!.data!.data,
                  path: snapshot.data!.path,
                );
              case AttachType.file:
                return ChatFile(
                  mediaChatMessage: mediaMessage,
                  bytes: snapshot!.data!.data,
                  path: snapshot.data!.path,
                );
            }
          }

          return const SizedBox(
            child: Center(
              child: CircularProgressIndicator(
                color: AppColors.main,
              ),
            ),
          );
        });
  }
}

class ChatVideo extends StatelessWidget {
  const ChatVideo({
    required this.mediaChatMessage,
    // required this.bytes,
    required this.path,
    super.key,
  });

  final MediaChatMessage mediaChatMessage;
  // final Uint8List bytes;
  final String path;

  @override
  Widget build(BuildContext context) {
    return BasicContainer(
      senderId: mediaChatMessage.senderId,
      replyTo: mediaChatMessage.replyTo,
      msgDateTime: mediaChatMessage.dateTime,
      moreLeftPadding: 0,
      bg: resolveMSGColor(mediaChatMessage.senderId, context),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      isTextMessage: true,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              onPressed: () {
                BlocProvider.of<ChatBloc>(context).add(StopCurrentVoice());
                videoPreviewPath = path;
                routemaster.push(
                  VideoPreviewPage.routeName,
                );
              },
              icon: Icon(
                Icons.play_circle_fill_outlined,
                color: Colors.white,
              ),
            ),
            Text(
              mediaChatMessage.mediaName,
              style: Theme.of(context)
                  .textTheme
                  .bodySmall!
                  .copyWith(color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}

class ChatFile extends StatelessWidget {
  const ChatFile({
    required this.mediaChatMessage,
    required this.bytes,
    required this.path,
    super.key,
  });

  final MediaChatMessage mediaChatMessage;
  final Uint8List bytes;
  final String path;

  @override
  Widget build(BuildContext context) {
    return BasicContainer(
      senderId: mediaChatMessage.senderId,
      replyTo: mediaChatMessage.replyTo,
      msgDateTime: mediaChatMessage.dateTime,
      moreLeftPadding: 0,
      bg: resolveMSGColor(mediaChatMessage.senderId, context),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      isTextMessage: true,
      child: GestureDetector(
        onTap: () {
          Share.shareXFiles(
            [
              XFile.fromData(
                bytes,
                name: mediaChatMessage.mediaName,
                path: path,
              ),
            ],
          );
        },
        child: Row(
          children: [
            Icon(
              Icons.file_present_rounded,
              color: Colors.white,
            ),
            SizedBox(width: 8),
            Flexible(
              child: Text(
                mediaChatMessage.mediaName,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontFamily: 'Montserrat',
                  fontSize: 12.0,
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
      // IntrinsicWidth(
      //   child: Column(
      //     mainAxisSize: MainAxisSize.min,
      //     children: [
      //       Flexible(
      //         child: Align(
      //           alignment: Alignment.centerLeft,
      //           child:
    );
  }
}

class ChatImage extends StatelessWidget {
  const ChatImage({
    required this.bytes,
    required this.senderId,
    required this.replyTo,
    required this.mediaChatMessage,
    super.key,
  });

  final int? replyTo;
  final Uint8List bytes;
  final int? senderId;
  final MediaChatMessage mediaChatMessage;

  @override
  Widget build(BuildContext context) {
    final read = context.read<MasterProfileState>();
    final isMe = read.profile!.id == senderId;
    return BasicContainer(
      moreLeftPadding: 16,
      isTextMessage: false,
      msgDateTime: mediaChatMessage.dateTime,
      replyTo: replyTo,
      bg: resolveMSGColor(mediaChatMessage.senderId, context),
      padding: const EdgeInsets.all(2),
      senderId: senderId,
      child: GestureDetector(
        onTap: () {
          print('Open image');
          imageBytes = bytes;
          routemaster.push(HeroPhotoViewRouteWrapper.routeName);
        },
        child: Container(
          height: 200,
          width: 200,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: const Radius.circular(16),
              topRight: const Radius.circular(16),
              bottomLeft:
                  isMe ? const Radius.circular(16) : const Radius.circular(4),
              bottomRight:
                  isMe ? const Radius.circular(4) : const Radius.circular(16),
            ),
            // color: AppColors.main,
            image: DecorationImage(
              image: MemoryImage(bytes),
              fit: BoxFit.cover,
            ),
          ),
          child: Align(
            alignment: Alignment.bottomRight,
            child: Container(
              padding: const EdgeInsets.all(4),
              margin: const EdgeInsets.all(4),
              decoration: const BoxDecoration(
                color: AppColors.main,
                borderRadius: BorderRadius.all(
                  Radius.circular(16),
                ),
              ),
              child: MessageTimeRow(
                mediaChatMessage.dateTime,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

String videoPreviewPath = '';

class VideoPreviewPage extends StatelessWidget {
  const VideoPreviewPage({super.key});

  static const String routeName = '/video_preview_page';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: CupertinoButton(
          padding: EdgeInsets.zero,
          onPressed: () => routemaster.history.back(),
          child: SvgPicture.asset(
            Svgs.arrow,
            color: AppColors.black,
          ),
        ),
        foregroundColor: Colors.black,
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: VideoPreview(
        path: videoPreviewPath,
      ),
    );
  }
}

Uint8List? imageBytes;

class HeroPhotoViewRouteWrapper extends StatelessWidget {
  const HeroPhotoViewRouteWrapper();
  // required this.imageProvider,
  // this.backgroundDecorati);

  static const String routeName = '/hero_photo_view_route';

  // final ImageProvider imageProvider;
  // final BoxDecoration? backgroundDecoration;
  // final dynamic minScale;
  // final dynamic maxScale;

  @override
  Widget build(BuildContext context) {
    final image = MemoryImage(imageBytes!);
    return WillPopScope(
      onWillPop: () {
        print('yes');
        return Future.value(false);
      },
      child: Scaffold(
        appBar: AppBar(
          leading: CupertinoButton(
            padding: EdgeInsets.zero,
            onPressed: () => routemaster.history.back(),
            child: SvgPicture.asset(
              Svgs.arrow,
              color: AppColors.black,
            ),
          ),
          foregroundColor: Colors.black,
          backgroundColor: Colors.white,
          elevation: 0,
        ),
        body: Stack(
          children: [
            Hero(
              tag: "someTag",
              child: Container(
                constraints: BoxConstraints.expand(
                  height: MediaQuery.of(context).size.height,
                ),
                child: PhotoView(
                  imageProvider: image,
                  // backgroundDecoration: backgroundDecoration,
                  // minScale: minScale,
                  // maxScale: maxScale,
                  // heroAttributes: const PhotoViewHeroAttributes(tag: "someTag"),
                ),
              ),
            ),
            // SizedBox(
            //   height: kToolbarHeight,
            //   child: Align(
            //     alignment: Alignment.centerLeft,
            //     child: CupertinoButton(
            //       padding: EdgeInsets.zero,
            //       onPressed: () => Navigator.pop(context),
            //       child: SvgPicture.asset(
            //         Svgs.arrow,
            //         color: AppColors.red,
            //       ),
            //     ),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}

class ChatVoice extends StatefulWidget {
  const ChatVoice({
    required this.path,
    required this.senderId,
    required this.replyTo,
    required this.mediaChatMessage,
    super.key,
  });

  final int? replyTo;
  final String path;
  final int? senderId;
  final MediaChatMessage mediaChatMessage;

  @override
  State<StatefulWidget> createState() => _ChatVoiceState();
}

class _ChatVoiceState extends State<ChatVoice> {
  // final PlayerController controller = PlayerController();
  final player = AudioPlayer();

  bool isReady = false;

  @override
  void initState() {
    super.initState();
    loadAudio();
  }

  @override
  void dispose() {
    player.dispose();
    super.dispose();
  }

  loadAudio() async {
    print('LOADING AUDIO ${widget.path} ${File(widget.path).existsSync()}');
    await player.setFilePath(widget.path);

    setState(() {
      isReady = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BasicContainer(
      isTextMessage: false,
      msgDateTime: widget.mediaChatMessage.dateTime,
      replyTo: widget.replyTo,
      moreLeftPadding: 16,
      bg: resolveVoiceColor(widget.senderId, context),
      padding: EdgeInsets.zero,
      senderId: widget.senderId,
      child: Container(
        height: 97,
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: isReady
            ? Column(
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
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
                            return IconButton(
                                icon: const Icon(Icons.play_arrow),
                                color: Colors.white,
                                onPressed: () {
                                  BlocProvider.of<ChatBloc>(context)
                                      .add(const StopCurrentVoice());
                                  BlocProvider.of<ChatBloc>(context)
                                      .add(StartListeningToVoice(player));
                                });
                          } else if (processingState !=
                              ProcessingState.completed) {
                            return IconButton(
                              icon: const Icon(Icons.pause),
                              color: Colors.white,
                              onPressed: player.pause,
                            );
                          } else {
                            return IconButton(
                              icon: const Icon(Icons.replay),
                              color: Colors.white,
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
                  ),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      margin: const EdgeInsets.symmetric(
                        vertical: 4,
                        horizontal: 12,
                      ),
                      decoration: const BoxDecoration(
                        color: AppColors.main,
                        borderRadius: BorderRadius.all(
                          Radius.circular(16),
                        ),
                      ),
                      child: MessageTimeRow(
                        widget.mediaChatMessage.dateTime,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              )
            : const Center(
                child: CircularProgressIndicator(color: AppColors.main),
              ),
      ),
    );
  }
}

class SeekBar extends StatefulWidget {
  final Duration duration;
  final Duration position;
  final Duration bufferedPosition;
  final ValueChanged<Duration>? onChanged;
  final ValueChanged<Duration>? onChangeEnd;

  const SeekBar({
    Key? key,
    required this.duration,
    required this.position,
    required this.bufferedPosition,
    this.onChanged,
    this.onChangeEnd,
  }) : super(key: key);

  @override
  SeekBarState createState() => SeekBarState();
}

class SeekBarState extends State<SeekBar> {
  double? _dragValue;
  late SliderThemeData _sliderThemeData;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    _sliderThemeData = SliderTheme.of(context).copyWith(
      trackHeight: 2.0,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SliderTheme(
          data: _sliderThemeData.copyWith(
            thumbShape: HiddenThumbComponentShape(),
            activeTrackColor: Colors.grey.shade100,
            inactiveTrackColor: Colors.grey.shade300,
          ),
          child: ExcludeSemantics(
            child: Slider(
              min: 0.0,
              max: widget.duration.inMilliseconds.toDouble(),
              value: min(widget.bufferedPosition.inMilliseconds.toDouble(),
                  widget.duration.inMilliseconds.toDouble()),
              onChanged: (value) {
                setState(() {
                  _dragValue = value;
                });
                if (widget.onChanged != null) {
                  widget.onChanged!(Duration(milliseconds: value.round()));
                }
              },
              onChangeEnd: (value) {
                if (widget.onChangeEnd != null) {
                  widget.onChangeEnd!(Duration(milliseconds: value.round()));
                }
                _dragValue = null;
              },
            ),
          ),
        ),
        SliderTheme(
          data: _sliderThemeData.copyWith(
            inactiveTrackColor: Colors.transparent,
          ),
          child: Slider(
            activeColor: AppColors.main,
            thumbColor: AppColors.main,
            min: 0.0,
            max: widget.duration.inMilliseconds.toDouble(),
            value: min(_dragValue ?? widget.position.inMilliseconds.toDouble(),
                widget.duration.inMilliseconds.toDouble()),
            onChanged: (value) {
              setState(() {
                _dragValue = value;
              });
              if (widget.onChanged != null) {
                widget.onChanged!(Duration(milliseconds: value.round()));
              }
            },
            onChangeEnd: (value) {
              if (widget.onChangeEnd != null) {
                widget.onChangeEnd!(Duration(milliseconds: value.round()));
              }
              _dragValue = null;
            },
          ),
        ),
        Positioned(
          right: 16.0,
          bottom: 0.0,
          child: Text(
              RegExp(r'((^0*[1-9]\d*:)?\d{2}:\d{2})\.\d+$')
                      .firstMatch("$_remaining")
                      ?.group(1) ??
                  '$_remaining',
              style: Theme.of(context)
                  .textTheme
                  .bodySmall!
                  .copyWith(color: Colors.white)),
        ),
      ],
    );
  }

  Duration get _remaining => widget.duration - widget.position;
}

class HiddenThumbComponentShape extends SliderComponentShape {
  @override
  Size getPreferredSize(bool isEnabled, bool isDiscrete) => Size.zero;

  @override
  void paint(
    PaintingContext context,
    Offset center, {
    required Animation<double> activationAnimation,
    required Animation<double> enableAnimation,
    required bool isDiscrete,
    required TextPainter labelPainter,
    required RenderBox parentBox,
    required SliderThemeData sliderTheme,
    required TextDirection textDirection,
    required double value,
    required double textScaleFactor,
    required Size sizeWithOverflow,
  }) {}
}

Color resolveMSGColor(int? senderId, BuildContext context) {
  final read = context.read<MasterProfileState>();
  final isMe = read.profile!.id == senderId;
  // final chatBloc = BlocProvider.of<ChatBloc>(context);

  if (isMe) {
    return AppColors.main;
  } else {
    return Color(0xFF801C1C);
  }
}

Color resolveVoiceColor(int? senderId, BuildContext context) {
  return resolveMSGColor(senderId, context);
  // final read = context.read<MasterProfileState>();
  // final isMe = read.profile!.id == senderId;
  // // final chatBloc = BlocProvider.of<ChatBloc>(context);

  // if (isMe) {
  //   return AppColors.grey;
  // } else {
  //   return Color(0xFFBFA6A2);
  // }
}
