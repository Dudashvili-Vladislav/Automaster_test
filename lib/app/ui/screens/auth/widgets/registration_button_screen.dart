import 'package:auto_master/app/constatns.dart';
import 'package:auto_master/app/domain/states/register_state.dart';
import 'package:flutter/material.dart';

import 'package:auto_master/app/ui/theme/app_colors.dart';
import 'package:auto_master/app/ui/theme/app_text_style.dart';
import 'package:auto_master/app/ui/widgets/widgets.dart';
import 'package:provider/provider.dart';

class RegistrationButtonScreen extends StatelessWidget {
  const RegistrationButtonScreen({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final state = context.watch<RegisterState>();
    final read = context.read<RegisterState>();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 15.0),
          child: Text(
            'Введите ваше имя',
            style: AppTextStyle.s14w400.copyWith(
              color: state.nameHasFocus ? AppColors.main : AppColors.black,
            ),
          ),
        ),
        const SizedBox(height: 7),
        CustomInput(
          onChange: (v) => read.validateNameAndPhone(),
          controller: read.nameController,
          node: read.nameNode,
          scrollPadding: 150,
          hasFocus: state.nameHasFocus,
        ),
        const SizedBox(height: 36),
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
          onChange: (v) => read.validateNameAndPhone(),
          controller: read.phoneController,
          node: read.phoneNode,
          hasFocus: state.phoneHasFocus,
          formatters: [phoneFormatterNew],
          scrollPadding: 100,
          keyboardType: TextInputType.phone,
        ),
      ],
    );
  }
}
