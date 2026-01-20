// ignore_for_file: deprecated_member_use

import 'dart:io';
import 'dart:typed_data';

import 'package:auto_master/app/data/api_client.dart';
import 'package:auto_master/app/ui/utils/pick_image.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';

import 'package:auto_master/app/ui/theme/app_colors.dart';
import 'package:auto_master/app/ui/widgets/dialogs/show_select_image.dart';
import 'package:auto_master/resources/resources.dart';

class AvatarPicker extends StatefulWidget {
  const AvatarPicker({
    Key? key,
    this.onPickImage,
    this.avatarUrl,
    this.imageData,
    // this.useNavigator = false,
  }) : super(key: key);

  final ValueChanged<PickImageState>? onPickImage;
  final String? avatarUrl;
  final Uint8List? imageData;
  // final bool useNavigator;

  @override
  State<AvatarPicker> createState() => _AvatarPickerState();
}

class _AvatarPickerState extends State<AvatarPicker> {
  final picker = ImagePicker();
  Uint8List? _pickedImage;

  void pickImage(BuildContext context, {bool isCamera = true}) async {
    // final PickImageState? image;
    PickImageState? pickImageState;
    try {
      if (isCamera) {
        print('BEFORE PICK IMAGE CAMERA');
        pickImageCamera(
          context,
          onGetCaptureDataTmp: (pickImageState) {
            if (pickImageState != null) {
              _pickedImage = pickImageState.data;
              widget.onPickImage?.call(pickImageState);
              // setState(() {});
            }
          },
          // useNavigator: widget.useNavigator,
        );
        print('AFTER PICK IMAGE CAMERA');
        // image = pickImageState?.data;
      } else {
        pickImageState = await pickImageGallery();
        if (pickImageState != null) {
          _pickedImage = pickImageState.data;
          widget.onPickImage?.call(pickImageState);
          setState(() {});
        }
        // image = await (await pickImageGallery())
      }
    } catch (e) {
      debugPrint('$e');
    }
  }

  @override
  Widget build(BuildContext context) {
    print('BUILD AVATAR PICKER ${_pickedImage?.length}');
    return CupertinoButton(
      onPressed: () => showSelectImage(
        context,
        onCameraPress: () {
          pickImage(context);
        },
        onGalleryPress: () {
          pickImage(context, isCamera: false);
        },
      ),
      padding: EdgeInsets.zero,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(100),
        child: SizedBox(
          width: 200,
          height: 200,
          child: Stack(
            children: [
              Positioned.fill(
                child: widget.imageData != null
                    ? Image.memory(
                        widget.imageData!,
                        fit: BoxFit.cover,
                        width: 200,
                        height: 200,
                      )
                    : _pickedImage == null
                        ? widget.avatarUrl != null
                            ? CachedNetworkImage(
                                imageUrl:
                                    '${ApiClient.baseImageUrl}${widget.avatarUrl!}',
                                fit: BoxFit.cover,
                                width: 200,
                                height: 200,
                              )
                            : SvgPicture.asset(
                                Svgs.profile,
                                fit: BoxFit.cover,
                                color: AppColors.greyLight,
                                width: 200,
                                height: 200,
                              )
                        : Image.memory(
                            _pickedImage!,
                            fit: BoxFit.cover,
                            width: 200,
                            height: 200,
                          ),
              ),
              Positioned.fill(
                child: ColoredBox(
                  color: Colors.black.withOpacity(.30),
                ),
              ),
              Center(
                child: SvgPicture.asset(
                  Svgs.camera,
                  width: 85,
                  height: 56,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
