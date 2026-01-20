// ignore_for_file: use_build_context_synchronously

import 'package:auto_master/app/domain/states/customer/add_car_cubit.dart';
import 'package:auto_master/app/domain/states/customer/profile_state.dart';
import 'package:auto_master/app/ui/screens/profile/pages/add_auto_first_page.dart';
import 'package:auto_master/app/ui/screens/profile/pages/add_avto_page.dart';
import 'package:auto_master/app/ui/theme/theme.dart';
import 'package:auto_master/app/ui/widgets/widgets.dart';
import 'package:auto_master/resources/resources.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

Future<dynamic> addAutoDialog(BuildContext context) {
  return showDialog(
    context: context,
    builder: (chCtx) => Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 36.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(40.0),
      ),
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 23.0,
              vertical: 40.0,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(
                  'Добавьте автомобиль',
                  style: AppTextStyle.s15w700.copyWith(
                    color: AppColors.main,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 28.0),
                  child: Text(
                    'К сожалению вы не добавили\nавтомобиль, чтобы выбрать\nуслугу, просим вас добавить авто',
                    textAlign: TextAlign.center,
                    style: AppTextStyle.s14w400.copyWith(
                      color: Colors.black,
                    ),
                  ),
                ),
                const SizedBox(height: 10.0),
                Image.asset(
                  Images.logo,
                  width: 117.0,
                  height: 102.0,
                ),
                const SizedBox(height: 24.0),
                CustomButton(
                  text: 'Добавить авто',
                  onPressed: () async {
                    Navigator.pop(chCtx);
                    await Navigator.push(
                      context,
                      CupertinoPageRoute(
                        builder: (context) => BlocProvider<AddCarCubit>(
                          create: (context) => AddCarCubit(null, context),
                          child: const AddAutoFirst(),
                        ),
                      ),
                    );

                    await context.read<CustomerProfileState>().fetchCars();
                  },
                ),
              ],
            ),
          ),
          const Positioned(
            right: 10,
            top: 10,
            child: CustomIconButton(
              icon: Svgs.close,
            ),
          ),
        ],
      ),
    ),
  );
}
