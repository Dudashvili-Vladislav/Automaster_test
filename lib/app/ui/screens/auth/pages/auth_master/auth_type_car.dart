// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:auto_master/app/app.dart';
import 'package:auto_master/app/domain/states/register_state.dart';
import 'package:auto_master/app/ui/routes/routes.dart';
import 'package:auto_master/app/ui/screens/screens.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import 'package:auto_master/app/ui/theme/theme.dart';
import 'package:auto_master/app/ui/widgets/widgets.dart';

class AuthTypeCar extends StatefulWidget {
  const AuthTypeCar({super.key});

  @override
  State<AuthTypeCar> createState() => _AuthTypeCarState();
}

class _AuthTypeCarState extends State<AuthTypeCar> {
  bool isActive = false;
  int? currentChek;
  final items = const [
    'Российский автомобиль',
    'Иностранный автомобиль',
    'Все автомобили',
  ];

  void toggle() {
    isActive = !isActive;
    setState(() {});
  }

  void selectCheck(newIndex) {
    currentChek = newIndex;
    context.read<RegisterState>().selectCarType(items[newIndex]);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final selectedCar =
        context.select((RegisterState vm) => vm.selectedCarType);
    return GestureDetector(
      onTap: () {
        if (isActive) {
          toggle();
        }
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          foregroundColor: Colors.black,
        ),
        body: SafeArea(
          child: SizedBox(
            width: double.infinity,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 22),
              child: Column(
                children: [
                  SizedBox(height: SizerUtil.height * .1),
                  Text(
                    'Какие машины?',
                    style: AppTextStyle.s32w600.copyWith(color: AppColors.main),
                  ),
                  const SizedBox(height: 36),
                  Text(
                    'Укажите с какими машинами\nвы работаете',
                    style:
                        AppTextStyle.s14w400.copyWith(color: AppColors.black),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 76.0),
                  CustomSelect(
                    values: items,
                    isActive: isActive,
                    onPressed: () => toggle(),
                    currentCheck: currentChek,
                    onTap: (v) => selectCheck(v),
                  ),
                  const Spacer(flex: 3),
                  CustomButton(
                    width: 234,
                    height: 47,
                    text: 'Далее',
                    onPressed: selectedCar == null
                        ? null
                        : () {
                            routemaster.push(AppRoutes.registerMasterSetAbout);
                            // Navigator.push(
                            //   context,
                            //   CupertinoPageRoute(
                            //     builder: (_) => ChangeNotifierProvider.value(
                            //       value: context.read<RegisterState>(),
                            //       child: const AuthMore(),
                            //     ),
                            //   ),
                            // );
                          },
                  ),
                  const SizedBox(height: 53),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
