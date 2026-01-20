import 'package:auto_master/app/ui/theme/app_colors.dart';
import 'package:flutter/material.dart';

class RedTextButton extends StatelessWidget {
  const RedTextButton({required this.text, this.onPressed, super.key});

  final String text;
  final void Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 30,
      child: TextButton(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.main.withOpacity(.34),
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
        ),
        onPressed: onPressed,
        child: Text(
          text,
          style: TextStyle(
            fontSize: 14.0,
            fontWeight: FontWeight.w500,
            color: onPressed != null ? AppColors.main : null,
          ),
        ),
      ),
    );
  }
}
