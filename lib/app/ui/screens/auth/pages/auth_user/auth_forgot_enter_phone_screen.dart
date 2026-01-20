import 'package:auto_master/app/domain/states/login_state.dart';
import 'package:auto_master/app/domain/states/register_state.dart';
import 'package:auto_master/app/domain/states/reset_pass_state.dart';
import 'package:auto_master/app/ui/theme/theme.dart';
import 'package:auto_master/app/ui/widgets/resend_code.dart';
import 'package:auto_master/app/ui/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class AuthForgotEnterPhone extends StatelessWidget {
  const AuthForgotEnterPhone({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<ResetPassState>();
    final read = context.read<ResetPassState>();
    return GestureDetector(
      onTap: FocusScope.of(context).unfocus,
      child: Scaffold(
        // resizeToAvoidBottomInset: false,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 22),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Spacer(flex: 100),
                // const SizedBox(height: 100), // SizerUtil.height * .11),
                Text(
                  'Восстановление\nпароля',
                  style: AppTextStyle.s32w600.copyWith(
                    color: AppColors.main,
                  ),
                  textAlign: TextAlign.center,
                ),
                Spacer(flex: 3),
                Text(
                  'Введите последние 4 цифры номера, по которому мы сейчас позвоним.',
                  style: AppTextStyle.s14w400.copyWith(
                    color: AppColors.black,
                  ),
                  textAlign: TextAlign.center,
                ),
                Spacer(flex: 89),
                // Flexible(
                //   child: ListView(
                //     physics: NeverScrollableScrollPhysics(),
                //     shrinkWrap: true,
                //     children: [
                Padding(
                  padding: const EdgeInsets.only(left: 15.0),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Введите код',
                      style: AppTextStyle.s14w400.copyWith(
                        color: state.codeHasFocus
                            ? AppColors.main
                            : AppColors.black,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 7),
                CustomInput(
                  controller: read.codeController,
                  node: read.codeNode,
                  hasFocus: state.codeHasFocus,
                  keyboardType: TextInputType.number,
                  onChange: (value) => read.setState(),
                ),
                const SizedBox(height: 16),
                ResendCode(
                  phone: context.read<LoginState>().getFullPhone,
                ),
                Spacer(flex: 240),
                Padding(
                  padding: const EdgeInsets.only(bottom: 24, top: 24),
                  child: CustomButton(
                    width: 234,
                    height: 47,
                    text: 'Далее',
                    isLoading: state.isLoading,
                    onPressed: read.codeController.text.trim().isEmpty
                        ? null
                        : () => read.checkCode(),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
