// Copyright 2013 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:async';
import 'dart:io';

import 'package:auto_master/app/app.dart';
import 'package:auto_master/app/domain/states/chat/chat_bloc.dart';
import 'package:auto_master/app/ui/screens/chat/widget/chat_text_widget.dart';
import 'package:auto_master/app/ui/theme/app_colors.dart';
import 'package:auto_master/app/ui/theme/app_text_style.dart';
import 'package:auto_master/app/ui/utils/pick_image.dart';
import 'package:auto_master/resources/resources.dart';
import 'package:camera/camera.dart';
import 'package:chewie/chewie.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gal/gal.dart';
import 'package:video_player/video_player.dart';

/// Camera example home widget.
class CameraExampleHome extends StatefulWidget {
  static const routeName = '/camera_page';

  final bool usedNavigator;

  /// Default Constructor
  const CameraExampleHome({super.key, this.usedNavigator = false});

  @override
  State<CameraExampleHome> createState() {
    return _CameraExampleHomeState();
  }
}

/// Returns a suitable camera icon for [direction].
IconData getCameraLensIcon(CameraLensDirection direction) {
  switch (direction) {
    case CameraLensDirection.back:
      return Icons.camera_rear;
    case CameraLensDirection.front:
      return Icons.camera_front;
    case CameraLensDirection.external:
      return Icons.camera;
  }
  // This enum is from a different package, so a new value could be added at
  // any time. The example should keep working if that happens.
  // ignore: dead_code
  return Icons.camera;
}

void _logError(String code, String? message) {
  // ignore: avoid_print
  print('Error: $code${message == null ? '' : '\nError Message: $message'}');
}

class _CameraExampleHomeState extends State<CameraExampleHome>
    with WidgetsBindingObserver, TickerProviderStateMixin {
  CameraController? controller;
  XFile? imageFile;
  XFile? videoFile;
  // VideoPlayerController? videoController;
  VoidCallback? videoPlayerListener;
  bool enableAudio = true;
  double _minAvailableExposureOffset = 0.0;
  double _maxAvailableExposureOffset = 0.0;
  double _currentExposureOffset = 0.0;
  late AnimationController _flashModeControlRowAnimationController;
  late Animation<double> _flashModeControlRowAnimation;
  late AnimationController _exposureModeControlRowAnimationController;
  late Animation<double> _exposureModeControlRowAnimation;
  late AnimationController _focusModeControlRowAnimationController;
  late Animation<double> _focusModeControlRowAnimation;
  double _minAvailableZoom = 1.0;
  double _maxAvailableZoom = 1.0;
  double _currentScale = 1.0;
  double _baseScale = 1.0;
  FlashMode currentFlashMode = FlashMode.auto;
  bool isPhotoMode = true;
  CameraDescription chosenCamera = cameras.first;
  final PageController pageController = PageController(viewportFraction: 0.2);

  // Counting pointers (number of user fingers on screen)
  int _pointers = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    _flashModeControlRowAnimationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _flashModeControlRowAnimation = CurvedAnimation(
      parent: _flashModeControlRowAnimationController,
      curve: Curves.easeInCubic,
    );
    _exposureModeControlRowAnimationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _exposureModeControlRowAnimation = CurvedAnimation(
      parent: _exposureModeControlRowAnimationController,
      curve: Curves.easeInCubic,
    );
    _focusModeControlRowAnimationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _focusModeControlRowAnimation = CurvedAnimation(
      parent: _focusModeControlRowAnimationController,
      curve: Curves.easeInCubic,
    );

    if (cameras.isNotEmpty) {
      _initializeCameraController(chosenCamera);
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _flashModeControlRowAnimationController.dispose();
    _exposureModeControlRowAnimationController.dispose();
    super.dispose();
  }

  // #docregion AppLifecycle
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final CameraController? cameraController = controller;

    // App state changed before we got the chance to initialize.
    if (cameraController == null || !cameraController.value.isInitialized) {
      return;
    }

    if (state == AppLifecycleState.inactive) {
      cameraController.dispose();
    } else if (state == AppLifecycleState.resumed) {
      _initializeCameraController(cameraController.description);
    }
  }

  Widget flashControlBtn() {
    switch (currentFlashMode) {
      case FlashMode.off:
        return IconButton(
          icon: const Icon(Icons.flash_off),
          color: Colors.white,
          onPressed: controller != null
              ? () => onSetFlashModeButtonPressed(FlashMode.auto)
              : null,
        );
      case FlashMode.auto:
        return IconButton(
          icon: const Icon(Icons.flash_auto),
          color: Colors.white,
          onPressed: controller != null
              ? () => onSetFlashModeButtonPressed(FlashMode.always)
              : null,
        );
      case FlashMode.always:
        return IconButton(
          icon: const Icon(Icons.flash_on),
          color: Colors.white,
          onPressed: controller != null
              ? () => onSetFlashModeButtonPressed(FlashMode.torch)
              : null,
        );
      case FlashMode.torch:
        return IconButton(
          icon: const Icon(Icons.highlight),
          color: Colors.white,
          onPressed: controller != null
              ? () => onSetFlashModeButtonPressed(FlashMode.off)
              : null,
        );
    }
  }
  // #enddocregion AppLifecycle

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        automaticallyImplyLeading: false,
        backgroundColor: Colors.black,
        surfaceTintColor: Colors.black,
        titleSpacing: 0,
        leading: CupertinoButton(
          padding: EdgeInsets.zero,
          onPressed: () => routemaster.history.back(),
          child: SvgPicture.asset(
            Svgs.arrow,
            color: Colors.white,
          ),
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (controller?.value.isRecordingVideo ?? false)
              RecordingTimerText(),
            // Text(
            //   'Камера',
            //   style: AppTextStyle.s15w700.copyWith(
            //     color: AppColors.main,
            //   ),
            // ),
            // const SizedBox(width: 44),
          ],
        ),
        actions: [
          flashControlBtn(),
        ],
      ),
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Expanded(
              child: _cameraPreviewWidget(),
            ),
            _modeSelection(),
            _cameraActionRow(),
            SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _cameraActionRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        SizedBox(
          height: 48,
          width: 48,
        ),
        selectActionButton(),
        SizedBox(
          height: 48,
          width: 48,
          child: IconButton(
            onPressed: () {
              // print(cameras.length);
              // print(controller?.value.);
              if (chosenCamera == cameras[0]) {
                onNewCameraSelected(cameras[1]);
              } else {
                onNewCameraSelected(cameras[0]);
              }
            },
            icon: Icon(Icons.flip_camera_android_rounded),
          ),
        ),
      ],
    );
  }

  Widget selectActionButton() {
    if (isPhotoMode) {
      return takePhotoButton();
    } else {
      if (controller?.value.isRecordingVideo ?? false) {
        return stopVideoButton();
      } else {
        return takeVideoButton();
      }
    }
  }

  Widget takePhotoButton() {
    return basicActionButton(
        internalColor: Colors.white, onTap: onTakePictureButtonPressed);
  }

  Widget takeVideoButton() {
    return basicActionButton(
        internalColor: Colors.red, onTap: onVideoRecordButtonPressed);
  }

  Widget stopVideoButton() {
    return basicActionButton(
      internalColor: Colors.red,
      onTap: onStopButtonPressed,
      shape: BoxShape.rectangle,
      padding: 16,
      borderRadius: BorderRadius.circular(8),
    );
  }

  Widget basicActionButton({
    required final void Function() onTap,
    required final Color internalColor,
    final BoxShape shape = BoxShape.circle,
    final double padding = 2,
    final BorderRadius? borderRadius = null,
  }) {
    return InkWell(
      onTap: onTap,
      customBorder: const CircleBorder(),
      child: Ink(
        height: 64,
        width: 64,
        padding: EdgeInsets.all(padding),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white, width: 3),
        ),
        child: Ink(
          decoration: BoxDecoration(
            borderRadius: borderRadius,
            shape: shape,
            color: internalColor,
          ),
        ),
      ),
    );
  }

  Widget _modeSelection() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 16),
      height: 32,
      child: Center(
        child: PageView(
          onPageChanged: (p0) => setState(() {
            print('set mode');
            isPhotoMode = p0 == 0;
          }),
          controller: pageController,
          children: [
            // SizedBox(
            //   height: 32,
            //   width: 100,
            //   child:
            modeItem(
              'ФОТО',
              () => pageController.animateToPage(0,
                  duration: Duration(milliseconds: 200), curve: Curves.linear),
              isPhotoMode,
            ),
            // ),
            if (enableRecording)
              modeItem(
                'ВИДЕО',
                () => pageController.animateToPage(1,
                    duration: Duration(milliseconds: 200),
                    curve: Curves.linear),
                !isPhotoMode,
              ),
          ],
        ),
      ),
    );
  }

  Widget modeItem(final String text, void Function() onTap, bool isSelected) {
    return GestureDetector(
      onTap: onTap,
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: AppTextStyle.s14w600
            .copyWith(color: isSelected ? Colors.yellow : Colors.white),
      ),
    );
  }

  /// Display the preview from the camera (or a message if the preview is not available).
  Widget _cameraPreviewWidget() {
    final CameraController? cameraController = controller;

    if (cameraController == null || !cameraController.value.isInitialized) {
      return const Text(
        'Инициализация камеры...',
        style: TextStyle(
          color: Colors.white,
          fontSize: 24.0,
          fontWeight: FontWeight.w900,
        ),
      );
    } else {
      return Listener(
        onPointerDown: (_) => _pointers++,
        onPointerUp: (_) => _pointers--,
        child: CameraPreview(
          controller!,
          child: LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
            return GestureDetector(
              behavior: HitTestBehavior.opaque,
              onScaleStart: _handleScaleStart,
              onScaleUpdate: _handleScaleUpdate,
              onTapDown: (TapDownDetails details) =>
                  onViewFinderTap(details, constraints),
            );
          }),
        ),
      );
    }
  }

  void _handleScaleStart(ScaleStartDetails details) {
    _baseScale = _currentScale;
  }

  Future<void> _handleScaleUpdate(ScaleUpdateDetails details) async {
    // When there are not exactly two fingers on screen don't scale
    if (controller == null || _pointers != 2) {
      return;
    }

    _currentScale = (_baseScale * details.scale)
        .clamp(_minAvailableZoom, _maxAvailableZoom);

    await controller!.setZoomLevel(_currentScale);
  }

  /// Display the thumbnail of the captured image or video.
  // Widget _thumbnailWidget() {
  //   final VideoPlayerController? localVideoController = videoController;

  //   return Expanded(
  //     child: Align(
  //       alignment: Alignment.centerRight,
  //       child: Row(
  //         mainAxisSize: MainAxisSize.min,
  //         children: <Widget>[
  //           if (localVideoController == null && imageFile == null)
  //             Container()
  //           else
  //             SizedBox(
  //               width: 64.0,
  //               height: 64.0,
  //               child: (localVideoController == null)
  //                   ? (
  //                       // The captured image on the web contains a network-accessible URL
  //                       // pointing to a location within the browser. It may be displayed
  //                       // either with Image.network or Image.memory after loading the image
  //                       // bytes to memory.
  //                       kIsWeb
  //                           ? Image.network(imageFile!.path)
  //                           : Image.file(File(imageFile!.path)))
  //                   : Container(
  //                       decoration: BoxDecoration(
  //                           border: Border.all(color: Colors.pink)),
  //                       child: Center(
  //                         child: AspectRatio(
  //                             aspectRatio:
  //                                 localVideoController.value.aspectRatio,
  //                             child: VideoPlayer(localVideoController)),
  //                       ),
  //                     ),
  //             ),
  //         ],
  //       ),
  //     ),
  //   );
  // }

  /// Display a bar with buttons to change the flash and exposure modes
  Widget _modeControlRowWidget() {
    return Column(
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            IconButton(
              icon: const Icon(Icons.flash_on),
              color: Colors.blue,
              onPressed: controller != null ? onFlashModeButtonPressed : null,
            ),
            // The exposure and focus mode are currently not supported on the web.
            ...!kIsWeb
                ? <Widget>[
                    IconButton(
                      icon: const Icon(Icons.exposure),
                      color: Colors.blue,
                      onPressed: controller != null
                          ? onExposureModeButtonPressed
                          : null,
                    ),
                    IconButton(
                      icon: const Icon(Icons.filter_center_focus),
                      color: Colors.blue,
                      onPressed:
                          controller != null ? onFocusModeButtonPressed : null,
                    )
                  ]
                : <Widget>[],
            IconButton(
              icon: Icon(enableAudio ? Icons.volume_up : Icons.volume_mute),
              color: Colors.blue,
              onPressed: controller != null ? onAudioModeButtonPressed : null,
            ),
            IconButton(
              icon: Icon(controller?.value.isCaptureOrientationLocked ?? false
                  ? Icons.screen_lock_rotation
                  : Icons.screen_rotation),
              color: Colors.blue,
              onPressed: controller != null
                  ? onCaptureOrientationLockButtonPressed
                  : null,
            ),
          ],
        ),
        _flashModeControlRowWidget(),
        _exposureModeControlRowWidget(),
        _focusModeControlRowWidget(),
      ],
    );
  }

  Widget _flashModeControlRowWidget() {
    return SizeTransition(
      sizeFactor: _flashModeControlRowAnimation,
      child: ClipRect(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            IconButton(
              icon: const Icon(Icons.flash_off),
              color: controller?.value.flashMode == FlashMode.off
                  ? Colors.orange
                  : Colors.blue,
              onPressed: controller != null
                  ? () => onSetFlashModeButtonPressed(FlashMode.off)
                  : null,
            ),
            IconButton(
              icon: const Icon(Icons.flash_auto),
              color: controller?.value.flashMode == FlashMode.auto
                  ? Colors.orange
                  : Colors.blue,
              onPressed: controller != null
                  ? () => onSetFlashModeButtonPressed(FlashMode.auto)
                  : null,
            ),
            IconButton(
              icon: const Icon(Icons.flash_on),
              color: controller?.value.flashMode == FlashMode.always
                  ? Colors.orange
                  : Colors.blue,
              onPressed: controller != null
                  ? () => onSetFlashModeButtonPressed(FlashMode.always)
                  : null,
            ),
            IconButton(
              icon: const Icon(Icons.highlight),
              color: controller?.value.flashMode == FlashMode.torch
                  ? Colors.orange
                  : Colors.blue,
              onPressed: controller != null
                  ? () => onSetFlashModeButtonPressed(FlashMode.torch)
                  : null,
            ),
          ],
        ),
      ),
    );
  }

  Widget _exposureModeControlRowWidget() {
    final ButtonStyle styleAuto = TextButton.styleFrom(
      foregroundColor: controller?.value.exposureMode == ExposureMode.auto
          ? Colors.orange
          : Colors.blue,
    );
    final ButtonStyle styleLocked = TextButton.styleFrom(
      foregroundColor: controller?.value.exposureMode == ExposureMode.locked
          ? Colors.orange
          : Colors.blue,
    );

    return SizeTransition(
      sizeFactor: _exposureModeControlRowAnimation,
      child: ClipRect(
        child: ColoredBox(
          color: Colors.grey.shade50,
          child: Column(
            children: <Widget>[
              const Center(
                child: Text('Exposure Mode'),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  TextButton(
                    style: styleAuto,
                    onPressed: controller != null
                        ? () =>
                            onSetExposureModeButtonPressed(ExposureMode.auto)
                        : null,
                    onLongPress: () {
                      if (controller != null) {
                        controller!.setExposurePoint(null);
                        showInSnackBar('Resetting exposure point');
                      }
                    },
                    child: const Text('AUTO'),
                  ),
                  TextButton(
                    style: styleLocked,
                    onPressed: controller != null
                        ? () =>
                            onSetExposureModeButtonPressed(ExposureMode.locked)
                        : null,
                    child: const Text('LOCKED'),
                  ),
                  TextButton(
                    style: styleLocked,
                    onPressed: controller != null
                        ? () => controller!.setExposureOffset(0.0)
                        : null,
                    child: const Text('RESET OFFSET'),
                  ),
                ],
              ),
              const Center(
                child: Text('Exposure Offset'),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Text(_minAvailableExposureOffset.toString()),
                  Slider(
                    value: _currentExposureOffset,
                    min: _minAvailableExposureOffset,
                    max: _maxAvailableExposureOffset,
                    label: _currentExposureOffset.toString(),
                    onChanged: _minAvailableExposureOffset ==
                            _maxAvailableExposureOffset
                        ? null
                        : setExposureOffset,
                  ),
                  Text(_maxAvailableExposureOffset.toString()),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _focusModeControlRowWidget() {
    final ButtonStyle styleAuto = TextButton.styleFrom(
      foregroundColor: controller?.value.focusMode == FocusMode.auto
          ? Colors.orange
          : Colors.blue,
    );
    final ButtonStyle styleLocked = TextButton.styleFrom(
      foregroundColor: controller?.value.focusMode == FocusMode.locked
          ? Colors.orange
          : Colors.blue,
    );

    return SizeTransition(
      sizeFactor: _focusModeControlRowAnimation,
      child: ClipRect(
        child: ColoredBox(
          color: Colors.grey.shade50,
          child: Column(
            children: <Widget>[
              const Center(
                child: Text('Focus Mode'),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  TextButton(
                    style: styleAuto,
                    onPressed: controller != null
                        ? () => onSetFocusModeButtonPressed(FocusMode.auto)
                        : null,
                    onLongPress: () {
                      if (controller != null) {
                        controller!.setFocusPoint(null);
                      }
                      showInSnackBar('Resetting focus point');
                    },
                    child: const Text('AUTO'),
                  ),
                  TextButton(
                    style: styleLocked,
                    onPressed: controller != null
                        ? () => onSetFocusModeButtonPressed(FocusMode.locked)
                        : null,
                    child: const Text('LOCKED'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Display the control bar with buttons to take pictures and record videos.
  Widget _captureControlRowWidget() {
    final CameraController? cameraController = controller;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        IconButton(
          icon: const Icon(Icons.camera_alt),
          color: AppColors.main,
          onPressed: cameraController != null &&
                  cameraController.value.isInitialized &&
                  !cameraController.value.isRecordingVideo
              ? onTakePictureButtonPressed
              : null,
        ),
        IconButton(
          icon: const Icon(Icons.videocam),
          color: AppColors.main,
          onPressed: cameraController != null &&
                  cameraController.value.isInitialized &&
                  !cameraController.value.isRecordingVideo &&
                  enableRecording
              ? onVideoRecordButtonPressed
              : null,
        ),
        IconButton(
          icon: cameraController != null &&
                  cameraController.value.isRecordingPaused
              ? const Icon(Icons.play_arrow)
              : const Icon(Icons.pause),
          color: AppColors.main,
          onPressed: cameraController != null &&
                  cameraController.value.isInitialized &&
                  cameraController.value.isRecordingVideo
              ? (cameraController.value.isRecordingPaused)
                  ? onResumeButtonPressed
                  : onPauseButtonPressed
              : null,
        ),
        IconButton(
          icon: const Icon(Icons.stop),
          color: AppColors.main,
          onPressed: cameraController != null &&
                  cameraController.value.isInitialized &&
                  cameraController.value.isRecordingVideo
              ? onStopButtonPressed
              : null,
        ),
        // IconButton(
        //   icon: const Icon(Icons.pause_presentation),
        //   color:
        //       cameraController != null && cameraController.value.isPreviewPaused
        //           ? Colors.red
        //           : Colors.blue,
        //   onPressed:
        //       cameraController == null ? null : onPausePreviewButtonPressed,
        // ),
      ],
    );
  }

  /// Display a row of toggle to select the camera (or a message if no camera is available).
  Widget _cameraTogglesRowWidget() {
    final List<Widget> toggles = <Widget>[];

    void onChanged(CameraDescription? description) {
      if (description == null) {
        return;
      }

      onNewCameraSelected(description);
    }

    if (cameras.isEmpty) {
      SchedulerBinding.instance.addPostFrameCallback((_) async {
        showInSnackBar('No camera found.');
      });
      return const Text('None');
    } else {
      for (final CameraDescription cameraDescription in cameras) {
        toggles.add(
          SizedBox(
            width: 90.0,
            child: RadioListTile<CameraDescription>(
              activeColor: AppColors.main,
              title: Icon(getCameraLensIcon(cameraDescription.lensDirection)),
              groupValue: controller?.description,
              value: cameraDescription,
              onChanged: onChanged,
            ),
          ),
        );
      }
    }

    return Row(children: toggles);
  }

  String timestamp() => DateTime.now().millisecondsSinceEpoch.toString();

  void showInSnackBar(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  void onViewFinderTap(TapDownDetails details, BoxConstraints constraints) {
    if (controller == null) {
      return;
    }

    final CameraController cameraController = controller!;

    final Offset offset = Offset(
      details.localPosition.dx / constraints.maxWidth,
      details.localPosition.dy / constraints.maxHeight,
    );
    cameraController.setExposurePoint(offset);
    cameraController.setFocusPoint(offset);
  }

  Future<void> onNewCameraSelected(CameraDescription cameraDescription) async {
    if (controller != null) {
      setState(() {
        chosenCamera = cameraDescription;
        controller!.setDescription(cameraDescription);
      });
    }
    // } else {
    //   return _initializeCameraController(cameraDescription);
    // }
  }

  Future<void> _initializeCameraController(
      CameraDescription cameraDescription) async {
    final CameraController cameraController = CameraController(
      cameraDescription,
      kIsWeb ? ResolutionPreset.max : ResolutionPreset.medium,
      enableAudio: enableAudio,
      imageFormatGroup: ImageFormatGroup.jpeg,
    );

    controller = cameraController;

    // If the controller is updated then update the UI.
    cameraController.addListener(() {
      if (mounted) {
        setState(() {});
      }
      if (cameraController.value.hasError) {
        showInSnackBar(
            'Camera error ${cameraController.value.errorDescription}');
      }
    });

    try {
      await cameraController.initialize();
      cameraController.setFlashMode(currentFlashMode);
      await Future.wait(<Future<Object?>>[
        // The exposure mode is currently not supported on the web.
        ...!kIsWeb
            ? <Future<Object?>>[
                cameraController.getMinExposureOffset().then(
                    (double value) => _minAvailableExposureOffset = value),
                cameraController
                    .getMaxExposureOffset()
                    .then((double value) => _maxAvailableExposureOffset = value)
              ]
            : <Future<Object?>>[],
        cameraController
            .getMaxZoomLevel()
            .then((double value) => _maxAvailableZoom = value),
        cameraController
            .getMinZoomLevel()
            .then((double value) => _minAvailableZoom = value),
      ]);
    } on CameraException catch (e) {
      switch (e.code) {
        case 'CameraAccessDenied':
          showInSnackBar('Вы запретили доступ к камере');
        case 'CameraAccessDeniedWithoutPrompt':
          // iOS only
          showInSnackBar('Пожалуйста разрешите доступ к камере в настройках');
        case 'CameraAccessRestricted':
          // iOS only
          showInSnackBar('Доступ к камере запрещен');
        case 'AudioAccessDenied':
          showInSnackBar('Вы запретили доступ к микрофону');
        case 'AudioAccessDeniedWithoutPrompt':
          // iOS only
          showInSnackBar(
              'Пожалуйста разрешите доступ к микрофону в настройках');
        case 'AudioAccessRestricted':
          // iOS only
          showInSnackBar('Доступ к микрофону запрещен');
        default:
          _showCameraException(e);
          break;
      }
    }

    if (mounted) {
      setState(() {});
    }
  }

  void onTakePictureButtonPressed() {
    takePicture().then((XFile? file) async {
      if (mounted) {
        setState(() {
          imageFile = file;
          // videoController?.dispose();
          // videoController = null;
        });
        if (file != null) {
          final bytes = await file.readAsBytes();
          captureData =
              PickImageState(bytes, file.name, AttachType.photo, file.path);
          routemaster.history.back();
          routemaster.push(CapturePreviewPage.routeName);
          // showInSnackBar('Picture saved to ${file.path}');
        }
      }
    });
  }

  void onFlashModeButtonPressed() {
    if (_flashModeControlRowAnimationController.value == 1) {
      _flashModeControlRowAnimationController.reverse();
    } else {
      _flashModeControlRowAnimationController.forward();
      _exposureModeControlRowAnimationController.reverse();
      _focusModeControlRowAnimationController.reverse();
    }
  }

  void onExposureModeButtonPressed() {
    if (_exposureModeControlRowAnimationController.value == 1) {
      _exposureModeControlRowAnimationController.reverse();
    } else {
      _exposureModeControlRowAnimationController.forward();
      _flashModeControlRowAnimationController.reverse();
      _focusModeControlRowAnimationController.reverse();
    }
  }

  void onFocusModeButtonPressed() {
    if (_focusModeControlRowAnimationController.value == 1) {
      _focusModeControlRowAnimationController.reverse();
    } else {
      _focusModeControlRowAnimationController.forward();
      _flashModeControlRowAnimationController.reverse();
      _exposureModeControlRowAnimationController.reverse();
    }
  }

  void onAudioModeButtonPressed() {
    enableAudio = !enableAudio;
    if (controller != null) {
      onNewCameraSelected(controller!.description);
    }
  }

  Future<void> onCaptureOrientationLockButtonPressed() async {
    try {
      if (controller != null) {
        final CameraController cameraController = controller!;
        if (cameraController.value.isCaptureOrientationLocked) {
          await cameraController.unlockCaptureOrientation();
          showInSnackBar('Capture orientation unlocked');
        } else {
          await cameraController.lockCaptureOrientation();
          showInSnackBar(
              'Capture orientation locked to ${cameraController.value.lockedCaptureOrientation.toString().split('.').last}');
        }
      }
    } on CameraException catch (e) {
      _showCameraException(e);
    }
  }

  void onSetFlashModeButtonPressed(FlashMode mode) {
    setFlashMode(mode).then((_) {
      if (mounted) {
        setState(() {});
      }
      // showInSnackBar('Flash mode set to ${mode.toString().split('.').last}');
    });
  }

  void onSetExposureModeButtonPressed(ExposureMode mode) {
    setExposureMode(mode).then((_) {
      if (mounted) {
        setState(() {});
      }
      showInSnackBar('Exposure mode set to ${mode.toString().split('.').last}');
    });
  }

  void onSetFocusModeButtonPressed(FocusMode mode) {
    setFocusMode(mode).then((_) {
      if (mounted) {
        setState(() {});
      }
      showInSnackBar('Focus mode set to ${mode.toString().split('.').last}');
    });
  }

  void onVideoRecordButtonPressed() {
    startVideoRecording().then((_) {
      if (mounted) {
        setState(() {});
      }
    });
  }

  void onStopButtonPressed() {
    stopVideoRecording().then((XFile? file) async {
      if (mounted) {
        setState(() {});
      }
      if (file != null) {
        final bytes = await file.readAsBytes();
        final name = file.name.replaceAll('.temp', '.mp4');
        final mp4Path = file.path.replaceAll('.temp', '.mp4');

        final file2 = File(mp4Path);
        await file2.writeAsBytes(bytes);

        captureData = PickImageState(bytes, name, AttachType.video, file2.path);
        print('SAVE VIDEO ${name} ${file2.path}');

        routemaster.history.back();
        routemaster.push(CapturePreviewPage.routeName);

        // showInSnackBar('Video recorded to ${file.path}');
        // videoFile = file;
        // _startVideoPlayer();
      }
    });
  }

  Future<void> onPausePreviewButtonPressed() async {
    final CameraController? cameraController = controller;

    if (cameraController == null || !cameraController.value.isInitialized) {
      showInSnackBar('Error: select a camera first.');
      return;
    }

    if (cameraController.value.isPreviewPaused) {
      await cameraController.resumePreview();
    } else {
      await cameraController.pausePreview();
    }

    if (mounted) {
      setState(() {});
    }
  }

  void onPauseButtonPressed() {
    pauseVideoRecording().then((_) {
      if (mounted) {
        setState(() {});
      }
      showInSnackBar('Съёмка видео на паузе');
    });
  }

  void onResumeButtonPressed() {
    resumeVideoRecording().then((_) {
      if (mounted) {
        setState(() {});
      }
      showInSnackBar('Съёмка видео продолжается');
    });
  }

  Future<void> startVideoRecording() async {
    final CameraController? cameraController = controller;

    if (cameraController == null || !cameraController.value.isInitialized) {
      showInSnackBar('Error: select a camera first.');
      return;
    }

    if (cameraController.value.isRecordingVideo) {
      // A recording is already started, do nothing.
      return;
    }

    try {
      await cameraController.startVideoRecording();
    } on CameraException catch (e) {
      _showCameraException(e);
      return;
    }
  }

  Future<XFile?> stopVideoRecording() async {
    final CameraController? cameraController = controller;

    if (cameraController == null || !cameraController.value.isRecordingVideo) {
      return null;
    }

    try {
      return cameraController.stopVideoRecording();
    } on CameraException catch (e) {
      _showCameraException(e);
      return null;
    }
  }

  Future<void> pauseVideoRecording() async {
    final CameraController? cameraController = controller;

    if (cameraController == null || !cameraController.value.isRecordingVideo) {
      return;
    }

    try {
      await cameraController.pauseVideoRecording();
    } on CameraException catch (e) {
      _showCameraException(e);
      rethrow;
    }
  }

  Future<void> resumeVideoRecording() async {
    final CameraController? cameraController = controller;

    if (cameraController == null || !cameraController.value.isRecordingVideo) {
      return;
    }

    try {
      await cameraController.resumeVideoRecording();
    } on CameraException catch (e) {
      _showCameraException(e);
      rethrow;
    }
  }

  Future<void> setFlashMode(FlashMode mode) async {
    if (controller == null) {
      return;
    }

    try {
      currentFlashMode = mode;
      await controller!.setFlashMode(mode);
    } on CameraException catch (e) {
      _showCameraException(e);
      rethrow;
    }
  }

  Future<void> setExposureMode(ExposureMode mode) async {
    if (controller == null) {
      return;
    }

    try {
      await controller!.setExposureMode(mode);
    } on CameraException catch (e) {
      _showCameraException(e);
      rethrow;
    }
  }

  Future<void> setExposureOffset(double offset) async {
    if (controller == null) {
      return;
    }

    setState(() {
      _currentExposureOffset = offset;
    });
    try {
      offset = await controller!.setExposureOffset(offset);
    } on CameraException catch (e) {
      _showCameraException(e);
      rethrow;
    }
  }

  Future<void> setFocusMode(FocusMode mode) async {
    if (controller == null) {
      return;
    }

    try {
      await controller!.setFocusMode(mode);
    } on CameraException catch (e) {
      _showCameraException(e);
      rethrow;
    }
  }

  // Future<void> _startVideoPlayer() async {
  //   if (videoFile == null) {
  //     return;
  //   }

  //   final VideoPlayerController vController = kIsWeb
  //       ? VideoPlayerController.networkUrl(Uri.parse(videoFile!.path))
  //       : VideoPlayerController.file(File(videoFile!.path));

  //   videoPlayerListener = () {
  //     if (videoController != null) {
  //       // Refreshing the state to update video player with the correct ratio.
  //       if (mounted) {
  //         setState(() {});
  //       }
  //       videoController!.removeListener(videoPlayerListener!);
  //     }
  //   };
  //   vController.addListener(videoPlayerListener!);
  //   await vController.setLooping(true);
  //   await vController.initialize();
  //   await videoController?.dispose();
  //   if (mounted) {
  //     setState(() {
  //       imageFile = null;
  //       videoController = vController;
  //     });
  //   }
  //   await vController.play();
  // }

  Future<XFile?> takePicture() async {
    final CameraController? cameraController = controller;
    if (cameraController == null || !cameraController.value.isInitialized) {
      showInSnackBar('Error: select a camera first.');
      return null;
    }

    if (cameraController.value.isTakingPicture) {
      // A capture is already pending, do nothing.
      return null;
    }

    try {
      final XFile file = await cameraController.takePicture();
      return file;
    } on CameraException catch (e) {
      _showCameraException(e);
      return null;
    }
  }

  void _showCameraException(CameraException e) {
    _logError(e.code, e.description);
    showInSnackBar('Error: ${e.code}\n${e.description}');
  }
}

class CapturePreviewPage extends StatelessWidget {
  const CapturePreviewPage();

  static const String routeName = '/camera-preview';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        automaticallyImplyLeading: false,
        surfaceTintColor: Colors.white,
        titleSpacing: 0,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            CupertinoButton(
              padding: EdgeInsets.zero,
              onPressed: () => routemaster.history.back(),
              child: SvgPicture.asset(
                Svgs.arrow,
                color: AppColors.black,
              ),
            ),
            Text(
              'Предпросмотр',
              style: AppTextStyle.s15w700.copyWith(
                color: AppColors.main,
              ),
            ),
            const SizedBox(width: 44),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.main,
        onPressed: () async {
          final hasAccess = await Gal.hasAccess();
          print('Has access to gallery ${hasAccess}');
          if (hasAccess) {
            switch (captureData!.type) {
              case AttachType.photo:
                Gal.putImage(captureData!.path!);
                break;
              case AttachType.video:
                print('put video ${captureData!.name}');
                Gal.putVideo(captureData!.path!);
                break;
              case AttachType.file:
              case AttachType.voice:
                break;
            }
          }
          routemaster.history.back();
          onGetCaptureData!.call(captureData);
        },
        child: Text(
          'ОК',
          style: AppTextStyle.s14w700.copyWith(color: Colors.white),
        ),
      ),
      body: PreviewBody(),
    );
  }
}

class RecordingTimerText extends StatefulWidget {
  const RecordingTimerText({super.key});

  @override
  State<StatefulWidget> createState() => TimerState();
}

class TimerState extends State<RecordingTimerText> {
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
    return Container(
      // height: 32,
      // width: 48,
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),

      decoration: const BoxDecoration(
          color: Colors.red, borderRadius: BorderRadius.all(Radius.circular(8))
          // shape: BoxShape.circle,
          ),
      child: Center(
        child: Text(
          '$minutesText:$secondsText',
          style: AppTextStyle.s14w700.copyWith(color: Colors.white),
        ),
      ),
    );
  }

  @override
  dispose() {
    _timer?.cancel();
    super.dispose();
  }
}

class PreviewBody extends StatelessWidget {
  const PreviewBody();

  @override
  Widget build(BuildContext context) {
    switch (captureData!.type) {
      case AttachType.photo:
        return Center(
          child: Image.memory(captureData!.data),
        );
      case AttachType.video:
        return VideoPreview(path: captureData!.path!);
      case AttachType.file:
      case AttachType.voice:
        return Center(
          child: Icon(Icons.file_present_sharp),
        );
    }
    // captureData!.type == AttachType.photo
    //       ? Center(
    //           child: Image.memory(captureData!.data),
    //         )
    //       : Center(
    //           child: Icon(Icons.file_present_sharp),
    //         ),
  }
}

// late VideoPlayerController _vController;

class VideoPreview extends StatefulWidget {
  const VideoPreview({required this.path, super.key});

  final String path;

  @override
  State<StatefulWidget> createState() => _VideoState();
}

class _VideoState extends State<VideoPreview> {
  late VideoPlayerController localController;
  late ChewieController chewieController;

  bool isLoading = false;
  bool isInitialized = false;

  @override
  initState() {
    super.initState();
    initializeVideoPlayer();
  }

  @override
  void dispose() {
    localController.dispose();
    chewieController.dispose();
    super.dispose();
  }

  Future<void> initializeVideoPlayer() async {
    // final file = File(cachePathProvider.videoTmp);
    // file.writeAsBytesSync(widget.data);

    try {
      localController = VideoPlayerController.file(File(widget.path));

      await localController.setLooping(true);
      await localController.initialize();

      chewieController = ChewieController(
        videoPlayerController: localController,
        autoPlay: true,
        looping: true,
        showOptions: false,
        allowFullScreen: false,
        allowPlaybackSpeedChanging: false,
        materialProgressColors: ChewieProgressColors(
          playedColor: AppColors.main,
          handleColor: Colors.white,
          backgroundColor: Colors.grey.shade700,
          bufferedColor: Colors.grey,
        ),
      );

      print(
          '\n+\n+\n+\n+========================================\nInit video duration ${localController.value.duration.inSeconds}');

      if (mounted) {
        setState(() {
          isInitialized = true;
        });
      }

      localController.play();
    } on Object catch (e) {
      print('ERROR WHEN INIT VIDEO PLAYER: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Expanded(
          child: Center(
            child: isInitialized
                ? AspectRatio(
                    aspectRatio: localController.value.aspectRatio,
                    child: Chewie(
                      controller: chewieController,
                    ),
                  )
                : CircularProgressIndicator(
                    color: AppColors.main,
                  ),
          ),
        ),
        // isInitialized
        //     ? AspectRatio(
        //         aspectRatio: localController.value.aspectRatio,
        //         child: VideoPlayer(localController),
        //       )
        //     : Center(
        //         child: CircularProgressIndicator(
        //           color: AppColors.main,
        //         ),
        //       ),

        // Center(
        //     child: IconButton(
        //         onPressed: () => initializeVideoPlayer(),
        //         icon: Icon(
        //           Icons.play_circle_fill_outlined,
        //         )),
        //   ),
        // isInitialized
        //     ? Row(
        //         mainAxisAlignment: MainAxisAlignment.spaceAround,
        //         children: [
        //           IconButton(
        //             icon: Icon(
        //               Icons.play_arrow,
        //               color: AppColors.main,
        //             ),
        //             onPressed: () => localController.play(),
        //           ),
        //           //     Flexible(
        //           //   child: StreamBuilder<Duration>(
        //           //     stream:localController.value.
        //           //     builder: (context, snapshot) {
        //           //  return SeekBar(
        //           //     duration: localController.value.duration,
        //           //     position: localController.value.position,
        //           //     bufferedPosition: Duration.zero,
        //           //     onChangeEnd: localController.seekTo,
        //           //   );},),),

        //           IconButton(
        //             icon: Icon(
        //               Icons.pause,
        //               color: AppColors.main,
        //             ),
        //             onPressed: () async {
        //               await localController.pause();
        //             },
        //           ),
        //           //  IconButton(
        //           //   icon: Icon(Icons.seek),
        //           //   onPressed: () => vController.pause(),
        //           // ),
        //         ],
        //       )
        //     : SizedBox(),
      ],
    );
  }
}

List<CameraDescription> cameras = <CameraDescription>[];
