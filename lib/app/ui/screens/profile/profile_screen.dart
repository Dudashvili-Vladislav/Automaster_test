// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:auto_master/app/constatns.dart';
import 'package:auto_master/app/data/api_client.dart';
import 'package:auto_master/app/domain/models/body_type.dart';
import 'package:auto_master/app/domain/service/customer_service.dart';
import 'package:auto_master/app/domain/states/customer/add_car_cubit.dart';
import 'package:auto_master/app/domain/states/customer/profile_state.dart';
import 'package:auto_master/app/domain/states/register_state.dart';
import 'package:auto_master/app/ui/screens/auth/pages/auth_user/auth_contacts_screen.dart';
import 'package:auto_master/app/ui/screens/home/pages/all_avto_page.dart';
import 'package:auto_master/app/ui/screens/profile/pages/add_auto_first_page.dart';
import 'package:auto_master/app/ui/widgets/black_text_button.dart';
import 'package:auto_master/app/ui/widgets/privacy_policy.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:auto_master/app/app.dart';
import 'package:auto_master/app/ui/routes/routes.dart';
import 'package:auto_master/app/ui/theme/theme.dart';
import 'package:auto_master/app/ui/widgets/widgets.dart';
import 'package:auto_master/resources/resources.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  List<BodyTypes> bodyTypes = [];

  Future<void> getBodyList(BuildContext context) async {
    var result = await CustomerService.getBodyList(context);

    if (result != null) {
      setState(() {
        bodyTypes = result;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    Future.microtask(() => getBodyList(context));
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<CustomerProfileState>();
    final read = context.read<CustomerProfileState>();
    final profile = state.profile;
    return Scaffold(
      body: state.isLoaing
          ? const Loading()
          : SafeArea(
              child: RefreshIndicator(
                onRefresh: () => read.fetchProfile(),
                color: AppColors.main,
                child: ListView(
                  physics: const RangeMaintainingScrollPhysics(),
                  padding: const EdgeInsets.symmetric(vertical: 26.0),
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: 161.0,
                          height: 135.0,
                          child: Stack(
                            clipBehavior: Clip.none,
                            children: [
                              AvatarWithoutCamera(
                                avatarUrl: profile?.avatarUrl,
                                onPickImage: (v) {
                                  read.onImagePicked(v);
                                  read.updateProfile();
                                },
                              ),
                              Positioned(
                                right: -20,
                                child: CustomIconButton(
                                  size: const Size(50, 50),
                                  onPressed: () => routemaster
                                      .push(AppRoutes.clientEditProfile),
                                  icon: Svgs.edit,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10.0),
                    Text(
                      profile?.name ?? '',
                      textAlign: TextAlign.center,
                      style: AppTextStyle.s15w700.copyWith(
                        color: AppColors.main,
                      ),
                    ),
                    const SizedBox(height: 15.0),
                    Text(
                      profile == null
                          ? ''
                          : phoneFormatter.maskText(profile.phone),
                      textAlign: TextAlign.center,
                      style: AppTextStyle.s15w400.copyWith(
                        color: AppColors.grey,
                      ),
                    ),
                    const SizedBox(height: 25.0),
                    Center(
                      child: BorderedButton(
                        onPressed: () => Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) =>
                                const AuthContactsScreen(isAuth: false),
                          ),
                        ),
                        width: 213.0,
                        height: 47.0,
                        text: 'Горячая линия',
                      ),
                    ),
                    const SizedBox(height: 15.0),
                    Center(
                      child: CustomButton(
                        onPressed: () async {
                          await Navigator.push(
                            context,
                            CupertinoPageRoute(
                              builder: (context) => BlocProvider<AddCarCubit>(
                                create: (context) => AddCarCubit(null, context),
                                child: const AddAutoFirst(),
                              ),
                            ),
                          );
                          await context
                              .read<CustomerProfileState>()
                              .fetchCars();
                        },
                        width: 213.0,
                        height: 47.0,
                        text: 'Добавить авто',
                      ),
                    ),
                    if (profile?.masterStatus == 'master')
                      Padding(
                        padding: const EdgeInsets.only(top: 15.0),
                        child: Center(
                          child: CustomButton(
                            onPressed: () => read.changeRole(),
                            width: 213.0,
                            height: 47.0,
                            text: 'Профиль мастера',
                          ),
                        ),
                      ),
                    // Padding(
                    //   padding: const EdgeInsets.only(top: 15.0),
                    //   child: Center(
                    //     child: CustomButton(
                    //       onPressed: () async {
                    //         confirmDeleteDialog(
                    //           context,
                    //           () => read.deleteProfile(),
                    //         );
                    //       },
                    //       width: 213.0,
                    //       height: 47.0,
                    //       text: 'Удалить профиль',
                    //     ),
                    //   ),
                    // ),
                    Padding(
                      padding:
                          const EdgeInsets.symmetric(horizontal: 35.0).copyWith(
                        top: 30.0,
                        bottom: 15.0,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            'Ваши авто',
                            style: AppTextStyle.s12w700.copyWith(
                              color: Colors.black,
                            ),
                          ),
                          SizedBox(
                            height: 20,
                            child: CupertinoButton(
                              onPressed: () => Navigator.push(
                                context,
                                CupertinoPageRoute(
                                  builder: (context) => const AllAutoPage(
                                    isChoose: false,
                                  ),
                                ),
                              ),
                              padding: EdgeInsets.zero,
                              child: Text(
                                'Посмотреть все',
                                style: AppTextStyle.s12w400.copyWith(
                                  color: AppColors.main,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 264.0,
                      child: state.cars.isEmpty
                          ? const Center(
                              child: Text(
                                'Вы не добавили авто',
                                style: AppTextStyle.s14w700,
                              ),
                            )
                          : ListView.separated(
                              itemCount: state.cars.length,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 35.0,
                                vertical: 10.0,
                              ),
                              scrollDirection: Axis.horizontal,
                              separatorBuilder: (context, index) =>
                                  const SizedBox(width: 10.0),
                              itemBuilder: (context, index) =>
                                  AutoCard.fromModel(
                                state.cars[index],
                                '${ApiClient.baseImageUrl}${state.cars[index].icon}',
                              ),
                            ),
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(
                        vertical: 16,
                        horizontal: 24,
                      ),
                      child: PrivacyPolicy(),
                    ),
                    // if (Platform.isIOS)
                    //   Padding(
                    //     padding: const EdgeInsets.symmetric(
                    //       vertical: 16,
                    //       horizontal: 24,
                    //     ),
                    //     child: BlackTextButton(
                    //       text: 'Восстановить покупки',
                    //       onPressed: () {},
                    //     ),
                    //   ),
                    Padding(
                      padding: const EdgeInsets.only(top: 4, bottom: 20.0),
                      child: SizedBox(
                        width: 150.0,
                        child: CupertinoButton(
                          padding: EdgeInsets.zero,
                          onPressed: () {
                            context.read<AppState>().onLogOut();
                            context.read<RegisterState>().clear();
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              const Icon(
                                Icons.exit_to_app,
                                color: AppColors.main,
                              ),
                              const SizedBox(width: 5.0),
                              Text(
                                'Выйти',
                                style: AppTextStyle.s15w400
                                    .copyWith(color: AppColors.main),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
