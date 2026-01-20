import 'package:auto_master/app/domain/states/register_state.dart';
import 'package:auto_master/app/ui/theme/theme.dart';
import 'package:auto_master/app/ui/widgets/resend_code.dart';
import 'package:auto_master/app/ui/widgets/widgets.dart';
import 'package:auto_master/resources/resources.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

Future<dynamic> confirmPhoneDialog(
    BuildContext context, ValueChanged<String> onConfirm, final String phone) {
  final controller = TextEditingController();
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
                  'Вы меняете\nосновной номер',
                  textAlign: TextAlign.center,
                  style: AppTextStyle.s15w700.copyWith(
                    color: AppColors.main,
                  ),
                ),
                const SizedBox(height: 10.0),
                Text(
                  'Введите посление 4 цифры телефона, с которого мы сейчас позвоним, чтобы подтвердить новый номер',
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
                const SizedBox(height: 28.0),
                CustomInput(
                  controller: controller,
                  hintText: 'Введите код',
                ),
                const SizedBox(height: 16),
                ResendCode(phone: phone),
                const SizedBox(height: 16),
                CustomButton(
                  text: 'Продолжить',
                  onPressed: () async {
                    onConfirm.call(controller.text);
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
