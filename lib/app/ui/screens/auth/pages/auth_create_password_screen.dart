import 'package:auto_master/app/app.dart';
import 'package:auto_master/app/ui/routes/routes.dart';
import 'package:auto_master/app/ui/theme/theme.dart';
import 'package:auto_master/app/ui/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class AuthCreatePasswordScreen extends StatefulWidget {
  const AuthCreatePasswordScreen({super.key});

  @override
  State<AuthCreatePasswordScreen> createState() =>
      _AuthCreatePasswordScreenState();
}

class _AuthCreatePasswordScreenState extends State<AuthCreatePasswordScreen> {
  final passController = TextEditingController();
  final passConfirmController = TextEditingController();

  final passNode = FocusNode();
  final passConfirmNode = FocusNode();

  bool passHasFocus = false;
  bool passConfirmHasFocus = false;

  void changeFocus(String type, bool value) {
    if (type == 'pass') {
      passHasFocus = value;
    } else {
      passConfirmHasFocus = value;
    }

    if (mounted) setState(() {});
  }

  @override
  void initState() {
    super.initState();
    passNode.addListener(() => changeFocus('pass', passNode.hasFocus));
    passConfirmNode.addListener(
        () => changeFocus('passConfirm', passConfirmNode.hasFocus));
  }

  @override
  void dispose() {
    passController.dispose();
    passConfirmController.dispose();
    passNode.removeListener(() => changeFocus('pass', passNode.hasFocus));
    passConfirmNode.removeListener(
        () => changeFocus('passConfirm', passConfirmNode.hasFocus));
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bottomSize = MediaQuery.of(context).viewInsets.bottom;

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: ListView(
                  physics: const RangeMaintainingScrollPhysics(),
                  padding: const EdgeInsets.symmetric(horizontal: 22),
                  children: [
                    SizedBox(height: SizerUtil.height * .11),
                    SizedBox(
                      width: double.infinity,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            'Придумайте\nпароль',
                            textAlign: TextAlign.center,
                            style: AppTextStyle.s32w600.copyWith(
                              color: AppColors.main,
                            ),
                          ),
                          const SizedBox(height: 30),
                          const Text(
                            'Пароль долен содержать не менее\n8 символов. Можно использовать\nлатинский буквы, цифры и символы',
                            style: AppTextStyle.s14w400,
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: SizerUtil.height * .08),
                    Padding(
                      padding: const EdgeInsets.only(left: 15.0),
                      child: Text(
                        'Введите пароль',
                        style: AppTextStyle.s14w400.copyWith(
                          color:
                              passHasFocus ? AppColors.main : AppColors.black,
                        ),
                      ),
                    ),
                    const SizedBox(height: 7),
                    CustomInput(
                      node: passNode,
                      hasFocus: passHasFocus,
                    ),
                    const SizedBox(height: 36),
                    Padding(
                      padding: const EdgeInsets.only(left: 15.0),
                      child: Text(
                        'Введите пароль повторно',
                        style: AppTextStyle.s14w400.copyWith(
                          color: passConfirmHasFocus
                              ? AppColors.main
                              : AppColors.black,
                        ),
                      ),
                    ),
                    const SizedBox(height: 7),
                    CustomInput(
                      scrollPadding: 260,
                      node: passConfirmNode,
                      hasFocus: passConfirmHasFocus,
                    ),
                    AnimatedContainer(
                      duration: kThemeAnimationDuration,
                      height: bottomSize > 10 ? 300 : 0,
                    ),
                  ],
                ),
              ),
              Center(
                child: CustomButton(
                  width: 234,
                  height: 47,
                  text: 'Далее',
                  onPressed: () {
                    context.read<AppState>().onChangeRoute(loggedInClientMap);
                  },
                ),
              ),
              const SizedBox(height: 53),
            ],
          ),
        ),
      ),
    );
  }
}
