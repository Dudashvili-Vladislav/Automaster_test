// ignore_for_file: use_build_context_synchronously

import 'package:auto_master/app/data/api_client.dart';
import 'package:auto_master/app/data/error_handler.dart';
import 'package:auto_master/app/domain/models/customer_car.dart';
import 'package:auto_master/app/domain/states/customer/add_car_cubit.dart';
import 'package:auto_master/app/domain/states/customer/home_state.dart';
import 'package:auto_master/app/domain/states/customer/profile_state.dart';
import 'package:auto_master/app/domain/states/support_data_cubit.dart';
import 'package:auto_master/app/ui/screens/auth/pages/auth_user/auth_contacts_screen.dart';
import 'package:auto_master/app/ui/screens/home/pages/select_sub_service.dart';
import 'package:auto_master/app/ui/screens/profile/pages/add_auto_first_page.dart';
import 'package:auto_master/app/ui/screens/profile/pages/add_avto_page.dart';
import 'package:auto_master/app/ui/widgets/dialogs/dialogs.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:auto_master/app/app.dart';
import 'package:auto_master/app/ui/routes/routes.dart';
import 'package:auto_master/app/ui/theme/theme.dart';
import 'package:auto_master/app/ui/widgets/widgets.dart';
import 'package:auto_master/resources/resources.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:url_launcher/url_launcher_string.dart';

import 'pages/accessories_page.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    final state = context.watch<HomeState>();
    final profileState = context.watch<CustomerProfileState>();

    final profile = profileState.profile;
    final firstCar = profileState.selectedCar;

    return SafeArea(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 35),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    'Здравствуйте, ${profile == null ? '...' : '${profile.name}!'}',
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyle.s15w700.copyWith(
                      color: AppColors.black,
                    ),
                  ),
                ),
                Image.asset(
                  Images.logo,
                  width: 65,
                  height: 57,
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Expanded(
            child: state.isLoading
                ? const Loading()
                : RefreshIndicator(
                    onRefresh: () async {
                      await context.read<CustomerProfileState>().fetchCars();
                      await context.read<CustomerProfileState>().fetchProfile();
                      await context.read<HomeState>().fetchSpecs();
                    },
                    color: AppColors.main,
                    child: ListView(
                      padding: EdgeInsets.zero,
                      children: [
                        Column(
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 35),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  CustomElevationButton(
                                    onPressed: () async {
                                      await Navigator.push(
                                        context,
                                        CupertinoPageRoute(
                                          builder: (context) =>
                                              BlocProvider<AddCarCubit>(
                                            create: (context) =>
                                                AddCarCubit(null, context),
                                            child: const AddAutoFirst(),
                                          ),
                                        ),
                                      );

                                      await context
                                          .read<CustomerProfileState>()
                                          .fetchCars();
                                    },
                                  ),
                                  CupertinoButton(
                                    padding: EdgeInsets.zero,
                                    onPressed: () async {
                                      await routemaster
                                          .push(AppRoutes.allAuto)
                                          .result;
                                    },
                                    child: Text(
                                      'Посмотреть все',
                                      style: AppTextStyle.s12w400.copyWith(
                                        color: AppColors.main,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 14),
                            firstCar == null
                                ? const SizedBox(
                                    height: 200.0,
                                    child: Center(
                                      child: Text(
                                        'Вы не добавили авто',
                                        style: AppTextStyle.s14w700,
                                      ),
                                    ),
                                  )
                                : SizedBox(
                                    height: 265.0,
                                    child: ListView.builder(
                                      scrollDirection: Axis.horizontal,
                                      itemCount: profileState.cars.length,
                                      itemBuilder: (context, index) {
                                        final car = profileState.cars[index];
                                        return Container(
                                          width: SizerUtil.width - 70,
                                          margin: const EdgeInsets.symmetric(
                                            horizontal: 35.0,
                                            vertical: 10.0,
                                          ).copyWith(
                                              right: index ==
                                                      profileState.cars.length -
                                                          1
                                                  ? 35
                                                  : 20.0,
                                              left: index == 0 ? 35 : 0),
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 26,
                                            vertical: 16,
                                          ),
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(20),
                                            color: Colors.white,
                                            boxShadow: [
                                              BoxShadow(
                                                blurRadius: 4,
                                                color: Colors.black
                                                    .withOpacity(.25),
                                              ),
                                            ],
                                          ),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                'Ваше авто',
                                                style: AppTextStyle.s12w400
                                                    .copyWith(
                                                  color: AppColors.grey,
                                                ),
                                              ),
                                              const SizedBox(height: 8),
                                              Align(
                                                alignment: Alignment.center,
                                                child: CachedNetworkImage(
                                                  imageUrl:
                                                      '${ApiClient.baseImageUrl}${car.icon}',
                                                  height: 149.0,
                                                  fit: BoxFit.contain,
                                                  errorWidget:
                                                      (context, url, error) =>
                                                          const SizedBox(
                                                              height: 120.0),
                                                  placeholder: (context, url) =>
                                                      const SizedBox(
                                                          height: 120.0),
                                                  // width: double.infinity,
                                                ),
                                              ),
                                              const SizedBox(height: 8),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  SizedBox(
                                                    width: 160,
                                                    child: Text(
                                                      '${car.model}', // ${car.brand}
                                                      style: AppTextStyle
                                                          .s20w600
                                                          .copyWith(
                                                        color: AppColors.main,
                                                      ),
                                                      softWrap: false,
                                                      overflow:
                                                          TextOverflow.fade,
                                                    ),
                                                  ),
                                                  CarNumberCard(firstCar: car),
                                                ],
                                              ),
                                            ],
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                            const SizedBox(height: 10),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 35),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Наши услуги',
                                    style: AppTextStyle.s12w700.copyWith(
                                      color: AppColors.black,
                                    ),
                                  ),
                                  CupertinoButton(
                                    padding: EdgeInsets.zero,
                                    onPressed: () =>
                                        routemaster.push(AppRoutes.allServices),
                                    child: Text(
                                      'Посмотреть все',
                                      style: AppTextStyle.s12w400.copyWith(
                                        color: AppColors.main,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 15),
                            SizedBox(
                              height: 110,
                              child: ListView.separated(
                                // clipBehavior: Clip.hardEdge,
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 35),
                                scrollDirection: Axis.horizontal,
                                itemCount: state.specs.length + 2,
                                separatorBuilder: (context, index) =>
                                    const SizedBox(width: 24),
                                itemBuilder: (context, index) {
                                  if (state.specs.isEmpty) {
                                    return const SizedBox();
                                  }
                                  if (index == state.specs.length) {
                                    return ServicesCard(
                                      text: 'Горячая\nлиния',
                                      image: Images.redPhone,
                                      isAsset: true,
                                      onPressed: () {
                                        final read = context.read<HomeState>();
                                        read.selectSubCetegory('');
                                        routemaster.push(
                                            '${AuthContactsScreen.routeNameShort}/false');
                                        // Navigator.of(context,
                                        //         rootNavigator: true)
                                        //     .push(
                                        //   CupertinoPageRoute(
                                        //     builder: (context) =>
                                        //         const AuthContactsScreen(
                                        //             isAuth: false),
                                        //   ),
                                        // );
                                      },
                                    );
                                  }
                                  if (index == state.specs.length + 1) {
                                    return ServicesCard(
                                      text: 'Продажа Авто Б/У',
                                      image: Images.accessories,
                                      isAsset: true,
                                      onPressed: () {
                                        final read = context.read<HomeState>();
                                        read.selectSubCetegory('');
                                        routemaster
                                            .push(AccessoriesPage.routeName);
                                      },
                                    );
                                  }
                                  return ServicesCard(
                                    onPressed: () {
                                      state.selectSubCetegory('');
                                      if (firstCar == null) {
                                        addAutoDialog(context);
                                      } else {
                                        context
                                            .read<HomeState>()
                                            .selectSpec(state.specs[index]);
                                        if (state.specs[index]
                                                    .listOfSubCategory !=
                                                null &&
                                            state
                                                .specs[index]
                                                .listOfSubCategory!
                                                .isNotEmpty) {
                                          routemaster.push(
                                              AppRoutes.selectSubcategory);
                                          // Navigator.push(
                                          //   context,
                                          //   CupertinoPageRoute(
                                          //     builder: (context) =>
                                          //         const SelectSubService(),
                                          //   ),
                                          // );
                                        } else {
                                          routemaster
                                              .push(AppRoutes.selectAuto);
                                        }
                                      }
                                    },
                                    text: state.specs[index].nameOfCategory,
                                    image: state.specs[index].iconName,
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 25),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 35),
                          child: CustomButton(
                            width: 319,
                            height: 54,
                            text: 'Создать заявку',
                            onPressed: () async {
                              // showShizoBlockDialog(contextToShowDialog);
                              if (firstCar == null) {
                                addAutoDialog(context);
                              } else {
                                routemaster.push(AppRoutes.selectCategory);
                              }
                            },
                          ),
                        )
                      ],
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}

class CarNumberCard extends StatelessWidget {
  const CarNumberCard({
    super.key,
    required this.firstCar,
  });

  final CustomerCarEntity firstCar;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 23,
      width: 100,
      decoration: BoxDecoration(
        border: Border.all(
          width: 2,
          color: AppColors.black,
        ),
        borderRadius: BorderRadius.circular(5),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(width: 6),
          Text(
            firstCar.carNumber.substring(0, 8),
            style: AppTextStyle.s14w600.copyWith(
              color: AppColors.black,
            ),
          ),
          const Expanded(child: SizedBox()),
          Container(
            height: 23,
            width: 1,
            color: AppColors.black,
          ),
          const Expanded(child: SizedBox()),
          SizedBox(
            width: 29,
            height: 23,
            child: Stack(
              children: [
                Positioned(
                  top: -2,
                  right: 4,
                  child: Text(
                    firstCar.carNumber.substring(
                      8,
                      firstCar.carNumber.length,
                    ),
                    style: AppTextStyle.s14w600.copyWith(
                      color: AppColors.black,
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    margin: const EdgeInsets.only(
                      bottom: 1,
                    ),
                    width: 21,
                    height: 7,
                    child: Image.asset(
                      'assets/images/rus.png',
                      width: 21,
                      height: 7,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
