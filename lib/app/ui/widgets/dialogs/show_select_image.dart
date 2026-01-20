// ignore_for_file: deprecated_member_use

import 'dart:developer';

import 'package:auto_master/app/ui/theme/theme.dart';
import 'package:auto_master/app/ui/widgets/widgets.dart';
import 'package:auto_master/resources/resources.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';

Future<dynamic> showSelectImage(
  BuildContext context, {
  VoidCallback? onGalleryPress,
  VoidCallback? onCameraPress,
}) {
  return showModalBottomSheet(
    useRootNavigator: true,
    context: context,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(
        top: Radius.circular(25.0),
      ),
    ),
    builder: (context) => SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 30.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const Align(
              alignment: Alignment.topRight,
              child: CustomIconButton(
                icon: Svgs.close,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                CupertinoButton(
                  padding: EdgeInsets.zero,
                  onPressed: () {
                    Navigator.pop(context);
                    onGalleryPress?.call();
                  },
                  child: Column(
                    children: <Widget>[
                      SvgPicture.asset(
                        Svgs.galery,
                        width: 47.0,
                        height: 37.0,
                      ),
                      const SizedBox(height: 12.0),
                      const Text(
                        'Галерея',
                        style: TextStyle(
                          fontSize: 10.0,
                          fontFamily: 'Montserrat',
                          fontWeight: FontWeight.w400,
                          color: AppColors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
                CupertinoButton(
                  padding: EdgeInsets.zero,
                  onPressed: () {
                    Navigator.pop(context);
                    try {
                      onCameraPress?.call();
                    } on Object catch (e) {
                      log(e.toString());
                      Fluttertoast.showToast(msg: e.toString());
                    }
                  },
                  child: Column(
                    children: <Widget>[
                      SvgPicture.asset(
                        Svgs.camera,
                        width: 47.0,
                        height: 37.0,
                        color: AppColors.grey,
                      ),
                      const SizedBox(height: 12.0),
                      const Text(
                        'Камера',
                        style: TextStyle(
                          fontSize: 10.0,
                          fontFamily: 'Montserrat',
                          fontWeight: FontWeight.w400,
                          color: AppColors.grey,
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    ),
  );
}
