import 'package:auto_master/app/domain/states/login_state.dart';
import 'package:auto_master/app/ui/screens/tabbar/master_tabbar_screen.dart';
import 'package:auto_master/app/ui/theme/theme.dart';
import 'package:auto_master/app/ui/widgets/widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class AuthLoginScreen extends StatefulWidget {
  const AuthLoginScreen({super.key});

  @override
  _AuthLoginScreenState createState() => _AuthLoginScreenState();
}

class _AuthLoginScreenState extends State<AuthLoginScreen> {
  @override
  void initState() {
    super.initState();
    // Вызываем sendCode() при инициализации экрана
    Future.microtask(() {
      final read = context.read<LoginState>();
      read.sendCode();
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<LoginState>();
    final read = context.read<LoginState>();
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 22),
            child: Column(
              children: [
                SizedBox(height: SizerUtil.height * .11),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CustomIconButton(),
                    Text(
                      'Вход',
                      style: AppTextStyle.s32w600.copyWith(
                        color: AppColors.main,
                      ),
                    ),
                    const SizedBox(
                      width: 40,
                      height: 40,
                    ),
                  ],
                ),
                const Spacer(flex: 3),
                Text(
                  'Введите последние 4 цифры номера, по которому мы сейчас позвоним.',
                  textAlign: TextAlign.center,
                  style: AppTextStyle.s14w400.copyWith(
                    color: AppColors.black,
                  ),
                ),
                const SizedBox(height: 8),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 15.0),
                      child: Text(
                        'Введите код',
                        style: AppTextStyle.s14w400.copyWith(
                          color: state.codeHasFocus
                              ? AppColors.main
                              : AppColors.black,
                        ),
                      ),
                    ),
                    const SizedBox(height: 7),
                    CustomInput(
                      controller: read.codeController,
                      node: read.codeNode,
                      hasFocus: state.codeHasFocus,
                      keyboardType: TextInputType.number,
                      onChange: (v) => read.validateCode(),
                    ),
                  ],
                ),
                const SizedBox(height: 15),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    CupertinoButton(
                      padding: EdgeInsets.zero,
                      onPressed: () {
                        // Логика повторной отправки кода
                        read.resendCode();
                      },
                      child: Text(
                        'Отправить код повторно',
                        style: AppTextStyle.s14w400
                            .copyWith(color: AppColors.main),
                      ),
                    ),
                  ],
                ),
                const Spacer(flex: 3),
                CustomButton(
                  width: 234,
                  height: 47,
                  text: 'Далее',
                  isLoading: state.isLoading,
                  onPressed:
                  state.isCodeValid ? () => read.apiLogin() : null,
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
