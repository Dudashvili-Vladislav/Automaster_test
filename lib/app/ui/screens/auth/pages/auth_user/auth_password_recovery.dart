// import 'package:auto_master/app/app.dart';
// import 'package:auto_master/app/domain/states/register_state.dart';
// import 'package:auto_master/app/ui/routes/routes.dart';
// import 'package:auto_master/app/ui/theme/theme.dart';
// import 'package:auto_master/app/ui/widgets/resend_code.dart';
// import 'package:auto_master/app/ui/widgets/widgets.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:sizer/sizer.dart';

// class AuthPasswordRecovery extends StatefulWidget {
//   const AuthPasswordRecovery({super.key});

//   @override
//   State<AuthPasswordRecovery> createState() => _AuthPasswordRecoveryState();
// }

// class _AuthPasswordRecoveryState extends State<AuthPasswordRecovery> {
//   final codeController = TextEditingController();
//   final codeNode = FocusNode();
//   bool hasFocus = false;

//   void changeFocus(bool value) {
//     hasFocus = value;

//     if (mounted) setState(() {});
//   }

//   @override
//   void initState() {
//     super.initState();
//     codeNode.addListener(() => changeFocus(codeNode.hasFocus));
//   }

//   @override
//   void dispose() {
//     codeController.dispose();
//     codeNode.removeListener(() => changeFocus(codeNode.hasFocus));
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: FocusScope.of(context).unfocus,
//       child: Scaffold(
//         resizeToAvoidBottomInset: false,
//         body: SafeArea(
//           child: Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 22),
//             child: SizedBox(
//               width: double.infinity,
//               child: Column(
//                 children: [
//                   SizedBox(height: SizerUtil.height * .11),
//                   Text(
//                     'Восстановление\nпароля',
//                     style: AppTextStyle.s32w600.copyWith(
//                       color: AppColors.main,
//                     ),
//                     textAlign: TextAlign.center,
//                   ),
//                   const SizedBox(height: 30),
//                   Text(
//                     'Введите последние 4 цифры номера, по которому мы сейчас позвоним.',
//                     style: AppTextStyle.s14w400.copyWith(
//                       color: AppColors.black,
//                     ),
//                     textAlign: TextAlign.center,
//                   ),
//                   SizedBox(height: SizerUtil.height * .09),
//                   Expanded(
//                     child: ListView(
//                       children: [
//                         Padding(
//                           padding: const EdgeInsets.only(left: 15.0),
//                           child: Text(
//                             'Введите код',
//                             style: AppTextStyle.s14w400.copyWith(
//                               color:
//                                   hasFocus ? AppColors.main : AppColors.black,
//                             ),
//                           ),
//                         ),
//                         const SizedBox(height: 7),
//                         CustomInput(
//                           node: codeNode,
//                           hasFocus: hasFocus,
//                         ),
//                         const SizedBox(height: 16),
//                         ResendCode(
//                           phone: context.read<RegisterState>().getFullPhone,
//                         ),
//                       ],
//                     ),
//                   ),
//                   CustomButton(
//                     width: 234,
//                     height: 47,
//                     text: 'Далее',
//                     onPressed: () => routemaster.push(AppRoutes.forgotSetPass),
//                   ),
//                   const SizedBox(height: 53),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
