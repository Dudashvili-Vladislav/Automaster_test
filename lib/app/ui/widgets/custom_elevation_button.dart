import 'package:auto_master/app/ui/theme/theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomElevationButton extends StatelessWidget {
  const CustomElevationButton({
    Key? key,
    this.width = 126,
    this.height = 29,
    this.title = 'Новое авто',
    this.onPressed,
  }) : super(key: key);

  final double width;
  final double height;
  final String title;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      padding: EdgeInsets.zero,
      onPressed: onPressed,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(60),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(.25),
              blurRadius: 4,
            ),
          ],
        ),
        child: Center(
          child: Text(
            title,
            style: AppTextStyle.s12w400.copyWith(
              color: AppColors.black,
            ),
          ),
        ),
      ),
    );
  }
}
