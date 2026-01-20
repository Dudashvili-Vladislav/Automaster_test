import 'package:auto_master/app/domain/states/register_state.dart';
import 'package:auto_master/app/ui/theme/theme.dart';
import 'package:auto_master/app/ui/widgets/resend_code.dart';
import 'package:auto_master/app/ui/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'dart:math';



String generateRandomPassword({int length = 8}) {
  const String chars =
      'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789-+_!@#\$%^&*.,?';
  final rand = Random();
  return List.generate(length, (index) => chars[rand.nextInt(chars.length)]).join();
}


class AuthCodeVerifyScreen extends StatefulWidget {
  const AuthCodeVerifyScreen({super.key});

  @override
  State<AuthCodeVerifyScreen> createState() => _AuthCodeVerifyScreenState();
}

class _AuthCodeVerifyScreenState extends State<AuthCodeVerifyScreen> {
  final codeController = TextEditingController();
  final codeNode = FocusNode();
  bool hasFocus = false;
  bool hasValid = false;

  void changeFocus(bool value) {
    hasFocus = value;
    if (mounted) setState(() {});
  }

  void validateCode() {
    final code = codeController.text.trim();
    hasValid = code.length == 4;
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    codeNode.addListener(() => changeFocus(codeNode.hasFocus));
  }

  @override
  void dispose() {
    codeController.dispose();
    codeNode.removeListener(() => changeFocus(codeNode.hasFocus));
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final regState = context.read<RegisterState>();

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        body: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: ListView(
                  physics: const RangeMaintainingScrollPhysics(),
                  padding: const EdgeInsets.symmetric(horizontal: 22),
                  children: [
                    SizedBox(height: SizerUtil.height * .02),
                    Text(
                      'Подтверждение',
                      textAlign: TextAlign.center,
                      style: AppTextStyle.s36w600.copyWith(
                        color: AppColors.main,
                      ),
                    ),
                    SizedBox(height: SizerUtil.height * .03),
                    Text(
                      'Введите последние 4 цифры номера, по которому мы сейчас позвоним.',
                      textAlign: TextAlign.center,
                      style: AppTextStyle.s14w400.copyWith(
                        color: AppColors.black,
                      ),
                    ),
                    const SizedBox(height: 8),
                    ResendCode(
                      phone: regState.getFullPhone,
                    ),
                    const SizedBox(height: 8),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(
                            left: 15.0,
                            bottom: 7.0,
                          ),
                          child: Text(
                            'Введите код',
                            style: AppTextStyle.s14w400.copyWith(
                              color: hasFocus ? AppColors.main : AppColors.black,
                            ),
                          ),
                        ),
                        CustomInput(
                          controller: codeController,
                          hasFocus: hasFocus,
                          node: codeNode,
                          scrollPadding: 200,
                          keyboardType: TextInputType.number,
                          onChange: (v) => validateCode(),
                        ),
                        const SizedBox(height: 16.0),
                        Center(
                          child: CustomButton(
                            text: 'Далее',
                            isLoading: context
                                .watch<RegisterState>()
                                .isCheckCodeLoading,
                            onPressed: !hasValid
                                ? null
                                : () {
                              final randomPassword = generateRandomPassword(); // Генерация пароля
                              context.read<RegisterState>().checkCode(
                                codeController.text.trim(),
                                randomPassword, // Отправка сгенерированного пароля
                              );
                              // routemaster.push(AppRoutes.registerChoose);
                            },
                            height: 47,
                            width: 235,
                          ),
                        ),
                        const SizedBox(height: 32),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
