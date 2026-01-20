import 'package:auto_master/app/constatns.dart';
import 'package:auto_master/app/domain/states/login_state.dart';
import 'package:flutter/material.dart';

import 'package:auto_master/app/ui/theme/app_colors.dart';
import 'package:auto_master/app/ui/theme/app_text_style.dart';
import 'package:auto_master/app/ui/widgets/widgets.dart';
import 'package:provider/provider.dart';

class LoginInputs extends StatelessWidget {
  const LoginInputs({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final state = context.watch<LoginState>();
    final read = context.read<LoginState>();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 15.0),
              child: Text(
                'Введите ваш номер телефона',
                style: AppTextStyle.s14w400.copyWith(
                  color: state.phoneHasFocus ? AppColors.main : AppColors.black,
                ),
              ),
            ),
            const SizedBox(height: 7),
            CustomInput(
              isPhone: true,
              controller: read.phoneController,
              node: state.phoneNode,
              formatters: [phoneFormatterNew],
              hasFocus: state.phoneHasFocus,
              keyboardType: TextInputType.phone,
            ),
            // const SizedBox(height: 36),
            // Padding(
            //   padding: const EdgeInsets.only(left: 15.0),
            //   child: Text(
            //     'Введите пароль',
            //     style: AppTextStyle.s14w400.copyWith(
            //       color: state.passHasFocus ? AppColors.main : AppColors.black,
            //     ),
            //   ),
            // ),
            // const SizedBox(height: 7),
            // CustomInput(
            //   controller: read.passController,
            //   isPass: true,
            //   node: state.passNode,
            //   hasFocus: state.passHasFocus,
            //   keyboardType: TextInputType.text,
            // ),
          ],
        ),
      ],
    );
  }
}
