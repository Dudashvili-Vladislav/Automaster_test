// ignore_for_file: use_build_context_synchronously

import 'package:auto_master/app/constatns.dart';
import 'package:auto_master/app/domain/states/customer/profile_state.dart';
import 'package:auto_master/app/ui/theme/theme.dart';
import 'package:auto_master/app/ui/widgets/dialogs/confirm_delete.dart';
import 'package:auto_master/app/ui/widgets/dialogs/confirm_phone.dart';
import 'package:auto_master/app/ui/widgets/widgets.dart';
import 'package:auto_master/resources/resources.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProfileEditPage extends StatelessWidget {
  const ProfileEditPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final state = context.watch<CustomerProfileState>();
    final read = context.read<CustomerProfileState>();
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        // resizeToAvoidBottomInset: false,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          automaticallyImplyLeading: true,
          leading: const CustomIconButton(),
        ),
        body: SingleChildScrollView(
          child: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(width: 40.0),
                    AvatarPicker(
                      avatarUrl: state.profile?.avatarUrl,
                      onPickImage: (v) => read.onImagePicked(v),
                    ),
                    state.profile?.avatarUrl == null
                        ? const SizedBox(width: 40.0)
                        : CustomIconButton(
                            icon: Svgs.trash,
                            onPressed: () async {
                              final result = await showDeleteConfirm(context);

                              if (result != null) {
                                await read.deleteAvatar();
                              }
                            },
                          )
                  ],
                ),
                const SizedBox(
                  height: 38.0,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 18 + 36),
                  child: Text(
                    'Введите ваше имя',
                    style: AppTextStyle.s14w400.copyWith(
                      color: AppColors.black,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 36.0),
                  child: CustomInput(
                    controller: read.nameController,
                    hasFocus: state.nameHasFocus,
                    node: read.nameNode,
                  ),
                ),
                const SizedBox(height: 32),
                Padding(
                  padding: const EdgeInsets.only(left: 18 + 36),
                  child: Text(
                    'Введите ваш номер телефона',
                    style: AppTextStyle.s14w400.copyWith(
                      color: AppColors.black,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 36.0),
                  child: CustomInput(
                    isPhone: true,
                    controller: read.phoneController,
                    hasFocus: state.phoneHasFocus,
                    node: read.phoneNode,
                    formatters: [phoneFormatterNew],
                    scrollPadding: 200,
                    keyboardType: TextInputType.phone,
                  ),
                ),
                //   ],
                // ),
                // ),
                Align(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 40),
                    child: CustomButton(
                      text: 'Сохранить',
                      width: 213.0,
                      isLoading: state.isLoaing,
                      onPressed: () async {
                        final phone =
                            '+7${read.phoneController.text.trim().replaceAll(' ', '')}';

                        if (phone != state.profile!.phone) {
                          final notExistPhone = await read.checkPhone();

                          if (notExistPhone) {
                            confirmPhoneDialog(
                              context,
                              (v) async {
                                final result = await read.checkCode(v);

                                if (result) {
                                  read.updateProfile();
                                }
                              },
                              phone,
                            );
                          }
                        } else {
                          read.updateProfile();
                        }
                      },
                    ),
                  ),
                ),
                // Spacer(),
                Align(
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 24.0),
                    child: TextButton(
                      style: TextButton.styleFrom(
                        foregroundColor: AppColors.main.withOpacity(.4),
                      ),
                      onPressed: () {
                        confirmDeleteDialog(
                          context,
                          () => read.deleteProfile(),
                        );
                      },
                      child: Text(
                        'Удалить профиль',
                        style: AppTextStyle.s14w400.copyWith(
                          color: AppColors.main,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

Future<dynamic> showDeleteConfirm(BuildContext context) {
  return showDialog(
    context: context,
    builder: (context) => Dialog(
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
                Padding(
                  padding: const EdgeInsets.only(bottom: 25.0),
                  child: Text(
                    'Вы действительно\nхотите удалить фото?',
                    textAlign: TextAlign.center,
                    style: AppTextStyle.s15w700.copyWith(
                      color: AppColors.main,
                    ),
                  ),
                ),
                Image.asset(
                  Images.logo,
                  width: 117.0,
                  height: 102.0,
                ),
                const SizedBox(height: 25.0),
                CustomButton(
                  text: 'Да',
                  onPressed: () => Navigator.pop(context, true),
                ),
                const SizedBox(height: 20.0),
                BorderedButton(
                  onPressed: () => Navigator.pop(context),
                  width: double.infinity,
                  height: 47.0,
                  text: 'Нет',
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
