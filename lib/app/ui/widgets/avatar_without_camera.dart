import 'dart:typed_data';

import 'package:auto_master/app/data/api_client.dart';
import 'package:auto_master/app/ui/utils/pick_image.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';

import 'package:auto_master/app/ui/theme/theme.dart';
import 'package:auto_master/resources/resources.dart';

import 'dialogs/dialogs.dart';

class AvatarWithoutCamera extends StatefulWidget {
  const AvatarWithoutCamera({
    Key? key,
    this.onPickImage,
    this.avatarUrl,
  }) : super(key: key);

  final ValueChanged<PickImageState>? onPickImage;
  final String? avatarUrl;

  @override
  State<AvatarWithoutCamera> createState() => _AvatarWithoutCameraState();
}

class _AvatarWithoutCameraState extends State<AvatarWithoutCamera> {
  final picker = ImagePicker();
  // XFile? _pickedImage;

  void pickImage(BuildContext context, {bool isCamera = true}) async {
    // final PickImageState? image;
    PickImageState? pickImageState;
    try {
      if (isCamera) {
        pickImageCamera(context, onGetCaptureDataTmp: (pickImageState) {
          if (pickImageState != null) {
            widget.onPickImage?.call(pickImageState);
            setState(() {});
          }
        });
        // image = pickImageState?.data;
      } else {
        pickImageState = await pickImageGallery();
        if (pickImageState != null) {
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
    return CupertinoButton(
      onPressed: () {
        showSelectImage(
          context,
          onCameraPress: () {
            pickImage(context);
          },
          onGalleryPress: () {
            pickImage(context, isCamera: false);
          },
        );
      },
      child: Center(
        child: Container(
            width: 135.0,
            height: 135.0,
            clipBehavior: Clip.hardEdge,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
            ),
            child:
                // child: _pickedImage?.path == null
                widget.avatarUrl != null
                    ? CachedNetworkImage(
                        imageUrl:
                            '${ApiClient.baseImageUrl}${widget.avatarUrl!}',
                        fit: BoxFit.cover,
                        width: 200,
                        height: 200,
                      )
                    : SvgPicture.asset(
                        Svgs.profile,
                        width: 135.0,
                        height: 135.0,
                        color: AppColors.greyLight,
                      )
            // : Image.file(
            //     File(_pickedImage!.path),
            //     fit: BoxFit.cover,
            //     width: 135,
            //     height: 135,
            //   ),
            ),
      ),
    );
  }
}
