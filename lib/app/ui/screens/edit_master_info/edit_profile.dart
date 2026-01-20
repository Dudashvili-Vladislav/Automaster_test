import 'package:auto_master/app/domain/states/master/master_profile_state.dart';

import 'package:auto_master/app/ui/theme/theme.dart';
import 'package:auto_master/app/ui/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EditProfileEditScreen extends StatelessWidget {
  const EditProfileEditScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<MasterProfileState>();
    final read = context.read<MasterProfileState>();
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        body: SafeArea(
          child: SizedBox(
            width: double.infinity,
            child: Column(
              children: [
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: EdgeInsets.only(left: 20.0, top: 20.0),
                    child: CustomIconButton(),
                  ),
                ),
                const Spacer(),
                Text(
                  'Аватар',
                  style: AppTextStyle.s32w600.copyWith(
                    color: AppColors.main,
                  ),
                ),
                const SizedBox(height: 36),
                Text(
                  'Добавьте аватар, вашего \nрабочего места',
                  style: AppTextStyle.s14w400.copyWith(color: AppColors.black),
                  textAlign: TextAlign.center,
                ),
                const Spacer(),
                AvatarPicker(
                  avatarUrl: state.profile?.avatarUrl,
                  onPickImage: read.onSelectImagePicked,
                ),
                const Spacer(flex: 3),
                CustomButton(
                  width: 234,
                  height: 47,
                  text: 'Изменить',
                  isLoading: state.isLoading,
                  onPressed: () =>
                      read.updateProfile(context, image: state.selectedImage),
                ),
                const SizedBox(height: 53),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
