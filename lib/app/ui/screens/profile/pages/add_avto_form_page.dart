// ignore_for_file: public_member_api_docs, sort_constructors_first
// ignore_for_file: use_build_context_synchronously

import 'package:auto_master/app/domain/states/customer/add_car_cubit.dart';
import 'package:auto_master/app/ui/screens/order/widgets/widgets.dart';
import 'package:auto_master/app/ui/screens/profile/pages/add_auto_first_page.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:auto_master/app/domain/models/customer_car.dart';
import 'package:auto_master/app/domain/states/customer/profile_state.dart';
import 'package:auto_master/app/ui/theme/app_colors.dart';
import 'package:auto_master/app/ui/theme/app_text_style.dart';
import 'package:auto_master/app/ui/widgets/widgets.dart';
import 'package:auto_master/resources/resources.dart';

class AddAvtoFormPage extends StatelessWidget {
  const AddAvtoFormPage({
    Key? key,
    required this.carModel,
    required this.image,
  }) : super(key: key);

  final CustomerCarEntity carModel;
  final String image;

  @override
  Widget build(BuildContext context) {
    final isLoading =
        context.select((CustomerProfileState s) => s.deleteCarLoading);
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32.0).copyWith(
                top: 30.0,
                bottom: 20.0,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  const CustomIconButton(),
                  Text(
                    carModel.model,
                    style: AppTextStyle.s15w700.copyWith(
                      color: AppColors.main,
                    ),
                  ),
                  isLoading
                      ? SizedBox(
                          width: 40.0,
                          height: 40.0,
                          child: Center(
                            child: SizedBox(
                              width: 15.0,
                              height: 15.0,
                              child: CircularProgressIndicator(
                                strokeWidth: 4.0,
                                valueColor:
                                    AlwaysStoppedAnimation(AppColors.red),
                              ),
                            ),
                          ),
                        )
                      : CustomIconButton(
                          icon: Svgs.delete,
                          onPressed: () async {
                            final res = await universalDialog(
                              outerContext: context,
                              title: 'Удалить машину',
                              confirmText: 'Удалить',
                              content:
                                  'Вы действительно хотите удалить машину?',
                              cancelText: 'Отмена',
                            );
                            print(
                                'CLOSED DELETE CAR DIALOG $res ${carModel.brand} ${carModel.model}');
                            if (res != null && res) {
                              await context
                                  .read<CustomerProfileState>()
                                  .deleteCar(carModel.id);
                              Navigator.pop(context);
                            }
                          },
                        ),
                ],
              ),
            ),
            Expanded(
              child: ListView(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 36)
                        .copyWith(bottom: 15),
                    child: CachedNetworkImage(
                      imageUrl: image,
                      width: double.infinity,
                      height: 143,
                      errorWidget: (context, url, error) =>
                          const SizedBox(height: 142.0),
                      placeholder: (context, url) =>
                          const SizedBox(height: 142.0),
                      fit: BoxFit.contain,
                    ),
                  ),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 36, vertical: 22)
                            .copyWith(bottom: 5),
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(40),
                        topRight: Radius.circular(40),
                      ),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          blurRadius: 4,
                          color: Colors.black.withOpacity(.25),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        Column(
                          children: [
                            CarItemInfoCard(
                              item: carModel.brand,
                              title: 'Марка',
                            ),
                            CarItemInfoCard(
                              item: carModel.model,
                              title: 'Модель',
                            ),
                            CarItemInfoCard(
                              item: carModel.bodyType ?? '',
                              title: 'Кузов',
                            ),
                            CarItemInfoCard(
                              item: carModel.engineType,
                              title: 'Тип двигателя',
                            ),
                            CarItemInfoCard(
                              item: carModel.enginePower,
                              title: 'Мощность ДВС',
                            ),
                            CarItemInfoCard(
                              item: carModel.carNumber,
                              title: 'Гос. номер',
                            ),
                            if (carModel.vinNumber.isNotEmpty)
                              CarItemInfoCard(
                                item: carModel.vinNumber,
                                title: 'VIN номер',
                              ),
                            CarItemInfoCard(
                              item: carModel.typeOfDrive,
                              title: 'Привод',
                            ),
                          ],
                        ),
                        const SizedBox(height: 15),
                        CustomButton(
                          width: 234,
                          height: 47,
                          text: 'Редактировать',
                          onPressed: () => Navigator.push(
                            context,
                            CupertinoPageRoute(
                              builder: (context) => BlocProvider<AddCarCubit>(
                                create: (context) =>
                                    AddCarCubit(carModel, context),
                                child: const AddAutoFirst(),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 30),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CarItemInfoCard extends StatelessWidget {
  const CarItemInfoCard({
    Key? key,
    required this.item,
    this.title,
  }) : super(key: key);

  final String item;
  final String? title;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (title != null)
          Padding(
            padding: const EdgeInsets.only(
              bottom: 10.0,
              left: 20,
            ),
            child: Text(
              title!,
              style: AppTextStyle.s14w400,
            ),
          ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 16),
          // height: 48,
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(60),
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                blurRadius: 4,
                color: Colors.black.withOpacity(.25),
              ),
            ],
          ),
          child: Text(
            item,
            style: AppTextStyle.s14w400.copyWith(color: Colors.black),
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}
