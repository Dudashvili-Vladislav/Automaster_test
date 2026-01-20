import 'package:auto_master/app/app.dart';
import 'package:auto_master/app/ui/routes/routes.dart';
import 'package:auto_master/app/ui/theme/theme.dart';
import 'package:auto_master/app/ui/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AuthForgotSuccessScreen extends StatelessWidget {
  final bool isCustomer;
  const AuthForgotSuccessScreen({
    super.key,
    required this.isCustomer,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SizedBox(
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Spacer(),
              Text(
                'Вы успешно\nсменили пароль',
                style: AppTextStyle.s32w600.copyWith(
                  color: AppColors.main,
                ),
                textAlign: TextAlign.center,
              ),
              const Spacer(),
              CustomButton(
                width: 234,
                height: 47,
                text: 'Далее',
                onPressed: () => context.read<AppState>().onChangeRoute(
                    isCustomer ? loggedInClientMap : loggedInMasterMap),
              ),
              const SizedBox(height: 53),
            ],
          ),
        ),
      ),
    );
  }
}
