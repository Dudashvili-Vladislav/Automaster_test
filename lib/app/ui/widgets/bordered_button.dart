import 'package:flutter/material.dart';

import 'package:auto_master/app/ui/screens/auth/pages/auth_user/auth_contacts_screen.dart';
import 'package:auto_master/app/ui/theme/theme.dart';

class BorderedButton extends StatelessWidget {
  const BorderedButton({
    Key? key,
    this.text = 'Наши контакты',
    this.width = 234.0,
    this.height,
    this.onPressed,
  }) : super(key: key);

  final String text;
  final double width;
  final double? height;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: OutlinedButton(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.main.withOpacity(.3),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(60),
          ),
          side: const BorderSide(color: AppColors.main),
        ),
        onPressed: onPressed ??
            () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const AuthContactsScreen(),
                ),
              );
            },
        child: Center(
          child: Text(
            text,
            style: AppTextStyle.s18w700.copyWith(
              color: AppColors.main,
            ),
          ),
        ),
      ),
    );
  }
}
