// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:auto_master/app/domain/states/master/master_profile_state.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import 'package:auto_master/app/ui/theme/theme.dart';
import 'package:auto_master/app/ui/widgets/widgets.dart';

import 'edit_more.dart';

class EditTypeCar extends StatefulWidget {
  const EditTypeCar({super.key});

  @override
  State<EditTypeCar> createState() => _EditTypeCarState();
}

class _EditTypeCarState extends State<EditTypeCar> {
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
    context.read<MasterProfileState>().selectCarType(items[newIndex]);
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    final cartType = context.read<MasterProfileState>().selectedCarType;
    if (cartType != null) {
      final index = items.indexOf(cartType);
      currentChek = index;
    }
  }

  @override
  Widget build(BuildContext context) {
    final selectedCar =
        context.select((MasterProfileState vm) => vm.selectedCarType);
    return GestureDetector(
      onTap: () {
        if (isActive) {
          toggle();
        }
      },
      child: Scaffold(
        body: SafeArea(
          child: SizedBox(
            width: double.infinity,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 22),
              child: Column(
                children: [
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: EdgeInsets.only(top: 20.0),
                      child: CustomIconButton(),
                    ),
                  ),
                  SizedBox(height: SizerUtil.height * .08),
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
                            Navigator.pushReplacement(
                              context,
                              CupertinoPageRoute(
                                builder: (_) => ChangeNotifierProvider.value(
                                  value: context.read<MasterProfileState>(),
                                  child: const EditMore(),
                                ),
                              ),
                            );
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
