// ignore_for_file: deprecated_member_use

import 'dart:io';

import 'package:auto_master/app/app.dart';
import 'package:auto_master/app/constatns.dart';
import 'package:auto_master/app/data/api_client.dart';
import 'package:auto_master/app/domain/models/master.dart';
import 'package:auto_master/app/domain/states/master/master_profile_state.dart';
import 'package:auto_master/app/domain/states/register_state.dart';
import 'package:auto_master/app/ui/screens/auth/pages/auth_user/auth_contacts_screen.dart';
import 'package:auto_master/app/ui/screens/edit_master_info/edit_type_master.dart';
import 'package:auto_master/app/ui/screens/profile_master/edit_master_profile.dart';
import 'package:auto_master/app/ui/theme/theme.dart';
import 'package:auto_master/app/ui/widgets/black_text_button.dart';
import 'package:auto_master/app/ui/widgets/privacy_policy.dart';
import 'package:auto_master/app/ui/widgets/widgets.dart';
import 'package:auto_master/resources/resources.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

class ProfileMasterScreen extends StatelessWidget {
  const ProfileMasterScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final state = context.watch<MasterProfileState>();
    // final read = context.read<MasterProfileState>();
    final profile = state.profile;
    final rating = double.tryParse(profile?.rating ?? '0') ?? 0;
    print(rating);

    return Scaffold(
      body: SafeArea(
        child: ListView(
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
                        onPickImage: (v) async {
                          await state.updateImage(image: v);
                          await state.fetchProfile();
                        },
                        avatarUrl: state.profile?.avatarUrl,
                      ),
                      Positioned(
                        right: -20,
                        child: CustomIconButton(
                          size: const Size(50, 50),
                          onPressed: () {
                            // final read = context.read<MasterProfileState>();
                            // read.
                            state.phoneController.text =
                                state.profile!.phone.replaceAll('+7', '');
                            // state.onChangePage(0);
                            state.onImagePicked(null);

                            routemaster.push(EditMasterProfilePage.routeName);
                            // Navigator.push(
                            //   context,
                            //   MaterialPageRoute(
                            //     builder: (_) => ChangeNotifierProvider.value(
                            //       value: state,
                            //       child: const EditMasterProfilePage(),
                            //     ),
                            //   ),
                            // );
                          },
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
              profile?.phone == null
                  ? ''
                  : phoneFormatter.maskText(profile!.phone),
              textAlign: TextAlign.center,
              style: AppTextStyle.s15w400.copyWith(
                color: AppColors.grey,
              ),
            ),
            const SizedBox(height: 25.0),
            Center(
              child: RatingBar.builder(
                glow: false,
                allowHalfRating: true,
                unratedColor: const Color(0xFFFFA200),
                itemPadding: const EdgeInsets.symmetric(horizontal: 5.0),
                itemSize: 25.0,
                itemBuilder: (context, index) {
                  return SvgPicture.asset(
                    rating.toInt() > index
                        ? Svgs.activeStar
                        : (index + 1 - rating).toString()[0] == '0'
                            ? Svgs.halfStar
                            : Svgs.star,
                    color: const Color(0xFFFFA200),
                  );
                },
                onRatingUpdate: (_) {},
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
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 15.0),
              child: Center(
                child: CustomButton(
                  onPressed: () => state.changeRole(),
                  width: 213.0,
                  height: 47.0,
                  text: 'Профиль заказчика',
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
              padding: const EdgeInsets.symmetric(horizontal: 30.0).copyWith(
                top: 30.0,
                bottom: 15.0,
              ),
              child: Text(
                'Место работы',
                style: AppTextStyle.s12w700.copyWith(
                  color: Colors.black,
                ),
              ),
            ),
            profile != null &&
                    profile.stoName.isEmpty &&
                    profile.workAddress.isEmpty &&
                    profile.workDescription.isEmpty
                ? Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 50.0,
                      vertical: 30.0,
                    ),
                    child: CustomButton(
                      text: 'Добавить место работы',
                      onPressed: () =>
                          Navigator.of(context, rootNavigator: true).push(
                        MaterialPageRoute(
                          builder: (_) => ChangeNotifierProvider.value(
                            value: context.read<MasterProfileState>(),
                            child: const EditTypeMaster(),
                          ),
                        ),
                      ),
                    ),
                  )
                : MasterWorkInfoCard(profile: profile),
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
    );
  }
}

class MasterWorkInfoCard extends StatelessWidget {
  const MasterWorkInfoCard({
    super.key,
    required this.profile,
  });

  final MasterEntity? profile;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(
        top: 27.0,
        left: 20.0,
        right: 6.0,
        bottom: 10.0,
      ),
      // height: 265.0,
      margin: const EdgeInsets.symmetric(horizontal: 24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.0),
        boxShadow: [AppTheme.shadowBlur4],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Flexible(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      profile?.stoName ?? '',
                      style: AppTextStyle.s16w600.copyWith(
                        color: AppColors.main,
                      ),
                    ),
                    const SizedBox(height: 23.0),
                    Text(
                      'Адрес',
                      style: AppTextStyle.s16w600.copyWith(
                        color: AppColors.grey,
                      ),
                    ),
                    const SizedBox(height: 7.0),
                    Flexible(
                      child: Text(
                        (profile?.workAddress ?? ''),
                        style: AppTextStyle.s12w400.copyWith(
                          color: Colors.black,
                        ),
                        // maxLines: 1,
                        // overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                width: 66.0,
                height: 66.0,
                // margin: EdgeInsets.only(right: 12),
                clipBehavior: Clip.hardEdge,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                ),
                child: profile?.avatarUrl != null
                    ? CachedNetworkImage(
                        imageUrl:
                            '${ApiClient.baseImageUrl}${profile!.avatarUrl!}',
                        fit: BoxFit.cover,
                        width: 200,
                        height: 200,
                      )
                    : SvgPicture.asset(
                        Svgs.profile,
                        width: 135.0,
                        height: 135.0,
                        color: AppColors.greyLight,
                      ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(
              top: 15.0,
              bottom: 7.0,
            ),
            child: Text(
              'Описание',
              style: AppTextStyle.s16w600.copyWith(
                color: AppColors.grey,
              ),
            ),
          ),
          SizedBox(
            height: 90,
            child: SingleChildScrollView(
              child: Text(
                (profile?.workDescription ?? ''),
                style: AppTextStyle.s12w400.copyWith(
                  color: Colors.black,
                ),
              ),
            ),
          ),
        ],
      ),

      // Expanded(
      //   child: Column(
      //     crossAxisAlignment: CrossAxisAlignment.end,
      //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
      //     children: [
      //       Container(
      //         width: 66.0,
      //         height: 66.0,
      //         clipBehavior: Clip.hardEdge,
      //         decoration: const BoxDecoration(
      //           shape: BoxShape.circle,
      //         ),
      //         child: profile?.avatarUrl != null
      //             ? CachedNetworkImage(
      //                 imageUrl:
      //                     '${ApiClient.baseImageUrl}${profile!.avatarUrl!}',
      //                 fit: BoxFit.cover,
      //                 width: 200,
      //                 height: 200,
      //               )
      //             : SvgPicture.asset(
      //                 Svgs.profile,
      //                 width: 135.0,
      //                 height: 135.0,
      //                 color: AppColors.greyLight,
      //               ),
      // ),
      // CustomButton(
      //   padding: const EdgeInsets.symmetric(horizontal: 4.5),
      //   width: double.infinity,
      //   height: 36.0,
      //   text: 'Редактировать',
      //   textStyle: AppTextStyle.s12w600.copyWith(
      //     color: Colors.white,
      //   ),
      //   onPressed: () =>
      //       Navigator.of(context, rootNavigator: true).push(
      //     MaterialPageRoute(
      //       builder: (_) => ChangeNotifierProvider.value(
      //         value: context.read<MasterProfileState>(),
      //         child: const EditTypeMaster(),
      //       ),
      //     ),
      //   ),
      // ),
      // ],
      // ),
      // ),
      // ],
      // ),
    );
  }
}
