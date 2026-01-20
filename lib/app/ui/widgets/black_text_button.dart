import 'package:auto_master/app/ui/theme/app_text_style.dart';
import 'package:flutter/material.dart';

class BlackTextButton extends StatelessWidget {
  final String text;
  final void Function()? onPressed;

  const BlackTextButton({
    required this.onPressed,
    required this.text,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 35,
      child: TextButton(
        style: TextButton.styleFrom(
          foregroundColor: Colors.black.withOpacity(0.4),
        ),
        onPressed: onPressed,
        child: Text(
          text,
          style: AppTextStyle.s12w400.copyWith(color: Colors.black),
        ),
      ),
    );
  }
}
