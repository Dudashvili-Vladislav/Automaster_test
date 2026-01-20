import 'package:auto_master/app/domain/states/reset_pass_state.dart';

import 'package:auto_master/app/ui/theme/app_colors.dart';
import 'package:auto_master/app/ui/theme/app_text_style.dart';
import 'package:auto_master/app/ui/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class AuthNewPasswordScreen extends StatelessWidget {
  const AuthNewPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<ResetPassState>();
    final read = context.read<ResetPassState>();
    final isKeyboardOpen = MediaQuery.of(context).viewInsets.bottom > 10;

    return GestureDetector(
      onTap: FocusScope.of(context).unfocus,
      child: Scaffold(
        body: SafeArea(
          child: SizedBox(
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.symmetric(horizontal: 22.0),
                    children: [
                      SizedBox(height: SizerUtil.height * .04),
                      Text(
                        'Придумайте\nновый пароль',
                        style: AppTextStyle.s32w600.copyWith(
                          color: AppColors.main,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 30),
                      Text(
                        'Пароль долен содержать не менее\n8 символов. Можно использовать\nлатинский буквы, цифры и символы',
                        style: AppTextStyle.s14w400.copyWith(
                          color: AppColors.black,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: SizerUtil.height * .07),
                      Padding(
                        padding: const EdgeInsets.only(left: 15.0),
                        child: Text(
                          'Введите новый пароль',
                          style: AppTextStyle.s14w400.copyWith(
                            color: state.passHasFocus
                                ? AppColors.main
                                : AppColors.black,
                          ),
                        ),
                      ),
                      const SizedBox(height: 7),
                      CustomInput(
                        controller: state.passController,
                        node: read.passNode,
                        hasFocus: state.passHasFocus,
                        scrollPadding: 200,
                        onChange: (v) => read.validatePass(),
                      ),
                      const SizedBox(height: 36),
                      Padding(
                        padding: const EdgeInsets.only(left: 15.0),
                        child: Text(
                          'Введите новый пароль повторно',
                          style: AppTextStyle.s14w400.copyWith(
                            color: state.passConfirmHasFocus
                                ? AppColors.main
                                : AppColors.black,
                          ),
                        ),
                      ),
                      const SizedBox(height: 7),
                      CustomInput(
                        controller: read.passConfirmController,
                        node: read.passConfirmNode,
                        hasFocus: state.passConfirmHasFocus,
                        scrollPadding: 200,
                        onChange: (v) => read.validatePass(),
                      ),
                      AnimatedContainer(
                        duration: kThemeAnimationDuration,
                        height: isKeyboardOpen ? 100 : 0,
                      )
                    ],
                  ),
                ),
                CustomButton(
                  width: 234,
                  height: 47,
                  text: 'Далее',
                  isLoading: state.isLoading,
                  onPressed: state.hasValid ? read.apiResetPass : null,
                ),
                const SizedBox(height: 53),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
