import 'package:auto_master/app/domain/states/register_state.dart';
import 'package:auto_master/app/ui/screens/tabbar/master_tabbar_screen.dart';
import 'package:auto_master/app/ui/theme/theme.dart';
import 'package:auto_master/app/ui/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AuthProfileEditScreen extends StatelessWidget {
  const AuthProfileEditScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<RegisterState>();
    final read = context.read<RegisterState>();
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        // appBar: AppBar(
        //   backgroundColor: Colors.white,
        //   elevation: 0,
        //   foregroundColor: Colors.black,
        // ),
        body: SafeArea(
          child: SizedBox(
            width: double.infinity,
            child: Column(
              children: [
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
                  onPickImage: (v) => read.setImage(v),
                  imageData: state.chosenImage?.data,
                  // useNavigator: false,
                ),
                const Spacer(flex: 2),
                CustomButton(
                  width: 234,
                  height: 47,
                  text: 'Завершить',
                  isLoading: state.isLoading,
                  onPressed: read.registerMaster,
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
