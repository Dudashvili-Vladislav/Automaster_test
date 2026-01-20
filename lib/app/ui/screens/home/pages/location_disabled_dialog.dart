import 'package:auto_master/app/ui/theme/app_colors.dart';
import 'package:auto_master/app/ui/theme/app_text_style.dart';
import 'package:auto_master/app/ui/widgets/custom_button.dart';
import 'package:auto_master/app/ui/widgets/custom_icon_button.dart';
import 'package:auto_master/resources/resources.dart';
import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:permission_handler/permission_handler.dart';

class LocationDisabledDialog extends StatelessWidget {
  const LocationDisabledDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      surfaceTintColor: Colors.white,
      insetPadding: const EdgeInsets.symmetric(horizontal: 36.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(40.0),
      ),
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 23.0,
              vertical: 40.0,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(
                  'У вас отключена\nгеолокация!',
                  textAlign: TextAlign.center,
                  style: AppTextStyle.s15w700.copyWith(
                    color: AppColors.main,
                  ),
                ),
                const SizedBox(height: 10.0),
                Text(
                  'Пожалуйста, включите геолокацию для доступа к точному местоположению.',
                  textAlign: TextAlign.center,
                  style: AppTextStyle.s14w400.copyWith(
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 28.0),
                Image.asset(
                  Images.logo,
                  width: 117.0,
                  height: 102.0,
                ),
                const SizedBox(height: 30.0),
                CustomButton(
                  text: 'Продолжить',
                  onPressed: () async {
                    final gotEnabled = await Location.instance.requestService();
                    if (gotEnabled) {
                      Navigator.pop(context);
                    }
                    // Navigator.pop(context);
                    // Location;
                    // if (await Permission.location.isGranted) {
                    //   Navigator.pop(context);
                    // } else {
                    //   await openAppSettings();
                    // }
                  },
                ),
              ],
            ),
          ),
          const Positioned(
            right: 10,
            top: 10,
            child: CustomIconButton(
              icon: Svgs.close,
            ),
          ),
        ],
      ),
    );
  }
}
