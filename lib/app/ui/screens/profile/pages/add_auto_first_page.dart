import 'package:auto_master/app/domain/states/customer/add_car_cubit.dart';
import 'package:auto_master/app/ui/screens/profile/pages/add_auto_pattern.dart';
import 'package:auto_master/app/ui/screens/profile/pages/add_auto_second_page.dart';
import 'package:auto_master/app/ui/theme/app_text_style.dart';
import 'package:auto_master/app/ui/widgets/custom_button.dart';
import 'package:auto_master/app/ui/widgets/custom_select.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddAutoFirst extends StatefulWidget {
  const AddAutoFirst({super.key});

  static const russianCar = 'Российский автомобиль';

  @override
  State<AddAutoFirst> createState() => _AddAutoFirstState();
}

class _AddAutoFirstState extends State<AddAutoFirst> {
  bool isActive = false;
  int? currentChek;

  final natiolanties = [
    AddAutoFirst.russianCar,
    'Иностранный автомобиль',
    // 'Все автомобили'
  ];

  void toggle() {
    isActive = !isActive;
    setState(() {});
  }

  void selectCheck(newIndex) {
    currentChek = newIndex;
    BlocProvider.of<AddCarCubit>(context)
        .selectNationality(natiolanties[newIndex]);
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    final selectedItem = BlocProvider.of<AddCarCubit>(context)
        .state
        .selectedCarNationality; //context.read<AddCarState>().selectedCarNationality;
    if (selectedItem != null) {
      currentChek = natiolanties.indexOf(selectedItem);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AddAutoPattern(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text(
            'Какой у вас автомобиль\nроссийский или иностранный?',
            style:
                AppTextStyle.s14w400.copyWith(color: Colors.black, height: 1.7),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 99),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 36),
            child: CustomSelect(
              title: 'Выберете авто',
              values: natiolanties,
              isActive: isActive,
              onPressed: () => toggle(),
              currentCheck: currentChek,
              onTap: (v) => selectCheck(v),
            ),
          ),
          const Spacer(),
          BlocBuilder<AddCarCubit, CarCubitState>(
            builder: (context, state) => CustomButton(
              width: 234,
              height: 47,
              text: 'Далее',
              onPressed: state.selectedCarNationality != null
                  ? () => Navigator.push(
                        context,
                        CupertinoPageRoute(
                          builder: (_) => BlocProvider<AddCarCubit>.value(
                            value: BlocProvider.of<AddCarCubit>(context),
                            child: AddAutoSecondPage(),
                          ),
                        ),
                      )
                  : null,
              isLoading: false,
            ),
          ),
          const SizedBox(height: 27),
        ],
      ),
    );
  }
}
