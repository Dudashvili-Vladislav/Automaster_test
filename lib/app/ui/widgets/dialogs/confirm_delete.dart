import 'package:auto_master/app/ui/theme/theme.dart';
import 'package:auto_master/app/ui/widgets/widgets.dart';
import 'package:auto_master/resources/resources.dart';
import 'package:flutter/material.dart';

Future<dynamic> confirmDeleteDialog(
    BuildContext context, VoidCallback onConfirm) {
  return showDialog(
    context: context,
    builder: (chCtx) => Dialog(
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
                  'Вы точно\nхотите удалить профиль',
                  textAlign: TextAlign.center,
                  style: AppTextStyle.s15w700.copyWith(
                    color: AppColors.main,
                  ),
                ),
                const SizedBox(height: 28.0),
                Image.asset(
                  Images.logo,
                  width: 117.0,
                  height: 102.0,
                ),
                const SizedBox(height: 28.0),
                CustomButton(
                  text: 'Продолжить',
                  onPressed: () async {
                    onConfirm.call();
                    Navigator.pop(chCtx);
                  },
                ),
                const SizedBox(height: 20.0),
                CustomButton(
                  text: 'Отменить',
                  onPressed: () async {
                    Navigator.pop(chCtx);
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
    ),
  );
}
