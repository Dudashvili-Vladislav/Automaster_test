import 'dart:typed_data';
import 'dart:ui';

import 'package:auto_master/app/app.dart';
import 'package:auto_master/app/domain/states/chat/chat_bloc.dart';
import 'package:auto_master/app/ui/widgets/camera_page.dart';
import 'package:camerawesome/camerawesome_plugin.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mime/mime.dart';
// import 'package:wechat_camera_picker/wechat_camera_picker.dart' as wechat;

class PickImageState {
  final Uint8List data;
  final String name;
  final AttachType type;
  final String? path;

  const PickImageState(this.data, this.name,
      [this.type = AttachType.photo, this.path]);
}

enum AttachType { photo, video, file, voice }

Future<PickImageState?> pickImageGallery() async {
  final res = await ImagePicker().pickImage(source: ImageSource.gallery);
  if (res != null) {
    return PickImageState(await res.readAsBytes(), res.name);
  } else {
    return null;
  }
}

Future<PickImageState?> pickImageOrVideoOrFile() async {
  final res = await ImagePicker().pickMedia();

  if (res != null) {
    final bytes = await res.readAsBytes();

    AttachType? type;

    String? mimeStr = lookupMimeType(res.path);
    var fileType = mimeStr?.split('/');

    if (fileType != null && fileType[0] == 'video') {
      type = AttachType.video;
    } else if (fileType != null && fileType[0] == 'image') {
      type = AttachType.photo;
    } else {
      type = AttachType.file;
    }
    print('file type ${fileType}');
    // try {
    //   final codec = await instantiateImageCodec(bytes, targetWidth: 32);
    //   final frameInfo = await codec.getNextFrame();
    //   isPhoto = frameInfo.image.width > 0;
    // } on Object {}

    return PickImageState(bytes, res.name, type);
  } else {
    return null;
  }
}

bool enableRecording = false;
PickImageState? captureData;
void Function(PickImageState?)? onGetCaptureData;
// Future<PickImageState?> pickImageCamera(BuildContext context,
//     [bool enableRecording = false]) async {push
void pickImageCamera(
  BuildContext context, {
  final bool enableRecordingTmp = false,
  required final void Function(PickImageState?)? onGetCaptureDataTmp,
  // final bool useNavigator = false,
}) async {
  enableRecording = enableRecordingTmp;
  print('enableRecording $enableRecording tmp= $enableRecordingTmp');
  captureData = null;
  onGetCaptureData = onGetCaptureDataTmp;
  // if (useNavigator) {
  //   Navigator.push(
  //     context,
  //     CupertinoPageRoute(
  //       builder: (_) => CameraExampleHome(),
  //     ),
  //   );
  // } else {
  routemaster.push(CameraExampleHome.routeName);
  // }
  print('afert push');
}

// Future<CaptureRequest> photoPathBuilder(List<Sensor> sensors) {
//   final String filePath = cachePathProvider.imagePath(-1) + '.jpg';

//   print('photoBuilder');
//   // 3.
//   return Future.value(SingleCaptureRequest(filePath, sensors.first));
// }

// Future<PickImageState?> pickImageCamera(BuildContext context,
//     [bool enableRecording = false]) async {
//   final config = enableRecording
//       ? SaveConfig.photoAndVideo(
//           photoPathBuilder: photoPathBuilder,
//           videoPathBuilder: photoPathBuilder)
//       : SaveConfig.photo(
//           pathBuilder: photoPathBuilder,
//         );

//   Navigator.of(context).push(
//     MaterialPageRoute(
//       builder: (_) => CameraAwesomeBuilder.awesome(
//         saveConfig: config,
//         topActionsBuilder: (state) => const SizedBox(),
//         middleContentBuilder: (state) => Column(
//           children: [
//             const Spacer(),
//             // if (state is PhotoCameraState && state.hasFilters)
//             //   AwesomeFilterWidget(state: state)
//             // else if (!kIsWeb && Platform.isAndroid)
//             //   AwesomeZoomSelector(state: state),
//             SizedBox(
//               height: 100,
//               child: NCameraModePager(
//                 initialMode: state.captureMode,
//                 availableModes: state.saveConfig!.captureModes,
//                 onChangeCameraRequest: (mode) {
//                   state.setState(mode);
//                 },
//               ),
//               //  AwesomeCameraModeSelector(state: state),
//             ),
//           ],
//         ),

//         // bottomActionsBuilder: (state) => SizedBox(),
//         availableFilters: [],
//         onMediaTap: (a) {
//           print('tap');
//         },
//         sensorConfig: SensorConfig.single(),
//       ),
//     ),
//   );

//   return null;
// }

// class NCameraModePager extends StatefulWidget {
//   final OnChangeCameraRequest onChangeCameraRequest;

//   final List<CaptureMode> availableModes;
//   final CaptureMode? initialMode;

//   const NCameraModePager({
//     super.key,
//     required this.onChangeCameraRequest,
//     required this.availableModes,
//     required this.initialMode,
//   });

//   @override
//   State<NCameraModePager> createState() => _CameraModePagerState();
// }

// class _CameraModePagerState extends State<NCameraModePager> {
//   late PageController _pageController;

//   int _index = 0;

//   @override
//   void initState() {
//     super.initState();
//     _index = widget.initialMode != null
//         ? widget.availableModes.indexOf(widget.initialMode!)
//         : 0;
//     _pageController =
//         PageController(viewportFraction: 0.25, initialPage: _index);
//   }

//   @override
//   void dispose() {
//     _pageController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     if (widget.availableModes.length <= 1) {
//       return const SizedBox.shrink();
//     }
//     return Row(
//       children: [
//         Expanded(
//           child: SizedBox(
//             height: 60,
//             child: PageView.builder(
//               scrollDirection: Axis.horizontal,
//               controller: _pageController,
//               onPageChanged: (index) {
//                 final cameraMode = widget.availableModes[index];
//                 widget.onChangeCameraRequest(cameraMode);
//                 setState(() {
//                   _index = index;
//                 });
//               },
//               itemCount: widget.availableModes.length,
//               itemBuilder: ((context, index) {
//                 final cameraMode = widget.availableModes[index];
//                 return AnimatedOpacity(
//                   duration: const Duration(milliseconds: 300),
//                   opacity: index == _index ? 1 : 0.2,
//                   child: AwesomeBouncingWidget(
//                     child: Center(
//                       child: Padding(
//                         padding: const EdgeInsets.symmetric(vertical: 8),
//                         child: icon(cameraMode),
//                         // Text(
//                         //   cameraMode..toUpperCase(),
//                         //   style: const TextStyle(
//                         //     color: Colors.white,
//                         //     fontWeight: FontWeight.bold,
//                         //     shadows: [
//                         //       Shadow(
//                         //         blurRadius: 4,
//                         //         color: Colors.black,
//                         //       )
//                         //     ],
//                         //   ),
//                         // ),
//                       ),
//                     ),
//                     onTap: () {
//                       _pageController.animateToPage(
//                         index,
//                         curve: Curves.easeIn,
//                         duration: const Duration(milliseconds: 200),
//                       );
//                     },
//                   ),
//                 );
//               }),
//             ),
//           ),
//         )
//       ],
//     );
//   }
// }

// Widget icon(CaptureMode mode) {
//   switch (mode) {
//     case CaptureMode.photo:
//       return const Icon(
//         Icons.photo,
//         size: 32,
//         color: Colors.white,
//       );
//     case CaptureMode.video:
//       return const Icon(
//         Icons.videocam_sharp,
//         size: 32,
//         color: Colors.white,
//       );
//     case CaptureMode.preview:
//     case CaptureMode.analysis_only:
//       return const SizedBox();
//   }
// }

//

// Future<PickImageState?> pickImageCamera(BuildContext context,
//     [bool enableRecording = false]) async {
//   final wechat.AssetEntity? entity = await wechat.CameraPicker.pickFromCamera(
//     context,
//     pickerConfig: wechat.CameraPickerConfig(
//       maximumRecordingDuration: Duration(seconds: 60),
//       onError: (error, stackTrace) => print('$error $stackTrace'),
//       textDelegate: RussianCameraPickerTextDelegate(),
//       enableRecording: enableRecording,
//       enableAudio: false,
//       enableSetExposure: false,
//       enableExposureControlOnPoint: false,
//       enablePinchToZoom: false,
//       enablePullToZoomInRecord: false,
//       enableScaledPreview: false,
//     ),
//   );

//   final bytes = await entity?.originBytes;
//   if (bytes != null) {
//     return PickImageState(
//       bytes,
//       entity?.title ?? 'no_name',
//       entity!.duration != 0,
//     );
//   }

//   return null;
// }

// class RussianCameraPickerTextDelegate
//     implements wechat.CameraPickerTextDelegate {
//   const RussianCameraPickerTextDelegate();

//   @override
//   String get languageCode => 'ru';

//   @override
//   String get confirm => 'ОК';

//   @override
//   String get shootingTips => 'Нажмите, чтобы сделать фото';

//   @override
//   String get shootingWithRecordingTips =>
//       'Нажмите, чтобы сделать фото. Удерживайте для записи видео.';

//   @override
//   String get shootingOnlyRecordingTips => 'Long press to record video.';

//   @override
//   String get shootingTapRecordingTips => 'Tap to record video.';

//   @override
//   String get loadFailed => 'Загрузка не удалась';

//   @override
//   String get loading => 'Загрузка...';

//   @override
//   String get saving => 'Сохранение...';

//   @override
//   String get sActionManuallyFocusHint => 'ручной фокус';

//   @override
//   String get sActionPreviewHint => 'preview';

//   @override
//   String get sActionRecordHint => 'record';

//   @override
//   String get sActionShootHint => 'take picture';

//   @override
//   String get sActionShootingButtonTooltip => 'shooting button';

//   @override
//   String get sActionStopRecordingHint => 'stop recording';

//   @override
//   String sCameraLensDirectionLabel(wechat.CameraLensDirection value) =>
//       value.name;

//   @override
//   String? sCameraPreviewLabel(wechat.CameraLensDirection? value) {
//     if (value == null) {
//       return null;
//     }
//     return '${sCameraLensDirectionLabel(value)} camera preview';
//   }

//   @override
//   String sFlashModeLabel(wechat.FlashMode mode) =>
//       'Режим вспышки: ${mode.name}';

//   @override
//   String sSwitchCameraLensDirectionLabel(wechat.CameraLensDirection value) =>
//       'Переключитесь на ${sCameraLensDirectionLabel(value)} камеру';
// }

// Future<XFile?> pickImageCamera() async {
//   PermissionStatus cameraPermissionStatus = await Permission.camera.status;

//   print('Camera ${cameraPermissionStatus.isGranted}');
// // && storagePermissionStatus.isGranted
//   if (cameraPermissionStatus.isGranted) {
//     // Permissions are already granted, proceed to pick file
//     return pickImage(ImageSource.camera);
//   } else {
//     Map<Permission, PermissionStatus> permissionStatuses = await [
//       Permission.camera,
//     ].request();

//     if (permissionStatuses[Permission.camera]!.isGranted) {
//       // Permissions granted, proceed to pick file
//       return pickImage(ImageSource.camera);
//     } else {
//       Fluttertoast.showToast(msg: 'Разрешите доступ к камере');
//     }
//   }
//   return null;
// }

