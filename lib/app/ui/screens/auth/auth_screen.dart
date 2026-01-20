// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:app_tracking_transparency/app_tracking_transparency.dart';
import 'package:auto_master/app/domain/states/login_state.dart';
import 'package:auto_master/app/domain/states/register_state.dart';

import 'package:auto_master/app/ui/screens/auth/pages/auth_user/auth_contacts_screen.dart';
import 'package:auto_master/app/ui/screens/auth/pages/auth_user/auth_login_screen.dart';
import 'package:auto_master/app/ui/screens/auth/widgets/widgets.dart';
import 'package:auto_master/app/ui/theme/app_colors.dart';
import 'package:auto_master/app/ui/theme/app_text_style.dart';
import 'package:auto_master/app/ui/widgets/widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  bool isLoginActive = false;

  void isChange() {
    isLoginActive = !isLoginActive;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<RegisterState>();
    // final isKeyboardOpen = MediaQuery.of(context).viewInsets.bottom > 10;
    return GestureDetector(
      onTap: FocusScope.of(context).unfocus,
      child: Scaffold(
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Spacer(),
              RichText(
                text: TextSpan(
                  text: 'Авто ',
                  style: AppTextStyle.s36w600.copyWith(
                    color: AppColors.main,
                  ),
                  children: [
                    TextSpan(
                      text: 'Мастер',
                      style: AppTextStyle.s36w600.copyWith(
                        color: AppColors.black,
                      ),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: CupertinoButton(
                        padding: EdgeInsets.zero,
                        onPressed: isLoginActive ? isChange : null,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'РЕГИСТРАЦИЯ',
                              style: AppTextStyle.s12w600.copyWith(
                                color: isLoginActive
                                    ? AppColors.black
                                    : AppColors.main,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 8.0),
                            Divider(
                              color: isLoginActive
                                  ? AppColors.black
                                  : AppColors.main,
                              thickness: 3.0,
                              height: 3,
                            ),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      child: CupertinoButton(
                        padding: EdgeInsets.zero,
                        onPressed: isLoginActive ? null : isChange,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'ВХОД',
                              style: AppTextStyle.s12w600.copyWith(
                                color: isLoginActive
                                    ? AppColors.main
                                    : AppColors.black,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 8.0),
                            Divider(
                              color: isLoginActive
                                  ? AppColors.main
                                  : AppColors.black,
                              thickness: 3.0,
                              height: 3,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              Container(
                height: 186,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                // color: Colors.green,
                child: Center(
                  child: isLoginActive
                      ? const LoginInputs()
                      : const RegistrationButtonScreen(),
                ),
              ),
              const Spacer(),
              SizedBox(
                height: 110,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (isLoginActive)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: BorderedButton(
                          height: 47.0,
                          onPressed: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const AuthContactsScreen(),
                            ),
                          ),
                        ),
                      ),
                    CustomButton(
                      width: 234,
                      height: 47,
                      text: 'Далее',
                      isLoading: isLoginActive
                          ? context.watch<LoginState>().isLoading
                          : state.isPhoneCheckLoading,
                      onPressed:
                      (!isLoginActive && !state.nameAndPhoneValidated)
                          ? null
                          : () async {
                        if (isLoginActive) {
                          final read = context.read<LoginState>();
                          final result = await read.checkPhone();

                          if (result) {
                            Navigator.push(
                              context,
                              CupertinoPageRoute(
                                builder: (context) =>
                                    ChangeNotifierProvider.value(
                                      value: read,
                                      child: const AuthLoginScreen(),
                                    ),
                              ),
                            );
                          }
                        } else {
                          context.read<RegisterState>().checkPhone();
                        }
                      },
                      // ),
                    ),
                  ],
                ),
              ),

              const Spacer(),

              // Expanded(
              //   child: ListView(
              //     padding: const EdgeInsets.symmetric(horizontal: 32.0),
              //     children: [
              //       // SizedBox(height: SizerUtil.height * .07),
              //       Center(
              //         child:
              // RichText(
              //           text: TextSpan(
              //             text: 'Авто ',
              //             style: AppTextStyle.s36w600.copyWith(
              //               color: AppColors.main,
              //             ),
              //             children: [
              //               TextSpan(
              //                 text: 'Мастер',
              //                 style: AppTextStyle.s36w600.copyWith(
              //                   color: AppColors.black,
              //                 ),
              //               ),
              //             ],
              //           ),
              //         ),
              //       ),
              //       SizedBox(height: SizerUtil.height * .085),
              //       Row(
              //         children: [
              //           Expanded(
              //             child:
              // CupertinoButton(
              //               padding: EdgeInsets.zero,
              //               onPressed: isLoginActive ? isChange : null,
              //               child: Column(
              //                 children: [
              //                   Text(
              //                     'РЕГИСТРАЦИЯ',
              //                     style: AppTextStyle.s12w600.copyWith(
              //                       color: isLoginActive
              //                           ? AppColors.black
              //                           : AppColors.main,
              //                     ),
              //                     textAlign: TextAlign.center,
              //                   ),
              //                   const SizedBox(height: 8.0),
              //                   Divider(
              //                     color: isLoginActive
              //                         ? AppColors.black
              //                         : AppColors.main,
              //                     thickness: 3.0,
              //                     height: 3,
              //                   ),
              //                 ],
              //               ),
              //             ),
              //           ),
              //           Expanded(
              //             child:
              // CupertinoButton(
              //               padding: EdgeInsets.zero,
              //               onPressed: isLoginActive ? null : isChange,
              //               child: Column(
              //                 children: [
              //                   Text(
              //                     'ВХОД',
              //                     style: AppTextStyle.s12w600.copyWith(
              //                       color: isLoginActive
              //                           ? AppColors.main
              //                           : AppColors.black,
              //                     ),
              //                     textAlign: TextAlign.center,
              //                   ),
              //                   const SizedBox(height: 8.0),
              //                   Divider(
              //                     color: isLoginActive
              //                         ? AppColors.main
              //                         : AppColors.black,
              //                     thickness: 3.0,
              //                     height: 3,
              //                   ),
              //                 ],
              //               ),
              //             ),
              //           ),
              //         ],
              //       ),
              //       SizedBox(height: SizerUtil.height * .07),
              //       isLoginActive
              //           ? const LoginInputs()
              //           : const RegistrationButtonScreen(),
              //       AnimatedContainer(
              //         duration: kThemeAnimationDuration,
              //         height: isKeyboardOpen ? 100 : 0,
              //       )
              //     ],
              //   ),
              // ),
              // Center(
              //   child: Column(
              //     children: [
              //       if (isLoginActive) const SizedBox(height: 10),
              //       if (isLoginActive)
              //         BorderedButton(
              //           height: 47.0,
              //           onPressed: () => Navigator.push(
              //             context,
              //             MaterialPageRoute(
              //               builder: (context) => const AuthContactsScreen(),
              //             ),
              //           ),
              //         ),
              //       AnimatedPadding(
              //         duration: kThemeAnimationDuration,
              //         padding: EdgeInsets.only(
              //           bottom: isKeyboardOpen ? 363.0 : 53.0,
              //           top: 20.0,
              //         ),
              //         child: CustomButton(
              //           width: 234,
              //           height: 47,
              //           text: 'Далее',
              //           isLoading: isLoginActive
              //               ? context.watch<LoginState>().isLoading
              //               : state.isPhoneCheckLoading,
              //           onPressed: (!isLoginActive &&
              //                   !state.nameAndPhoneValidated)
              //               ? null
              //               : () async {
              //                   if (isLoginActive) {
              //                     final read = context.read<LoginState>();
              //                     final result = await read.checkPhone();

              //                     if (result) {
              //                       Navigator.push(
              //                         context,
              //                         CupertinoPageRoute(
              //                           builder: (context) =>
              //                               ChangeNotifierProvider.value(
              //                             value: read,
              //                             child: const AuthLoginScreen(),
              //                           ),
              //                         ),
              //                       );
              //                     }
              //                   } else {
              //                     context.read<RegisterState>().checkPhone();
              //                   }
              //                 },
              //         ),
              //       ),
              //     ],
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
