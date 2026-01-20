import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:auto_master/app/ui/theme/theme.dart';
import 'package:auto_master/resources/resources.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({
    Key? key,
    this.hasIcon = false,
    this.isLoading = false,
    required this.text,
    this.textStyle,
    this.image = Images.whatsapp,
    this.height = 55,
    this.color = AppColors.main,
    this.width = double.infinity,
    this.padding,
    required this.onPressed,
  }) : super(key: key);
  final bool hasIcon;
  final bool isLoading;
  final String text;
  final TextStyle? textStyle;
  final String image;
  final double height;
  final Color color;
  final double width;
  final EdgeInsets? padding;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: CupertinoButton(
        padding: padding ?? EdgeInsets.zero,
        color: color,
        borderRadius: BorderRadius.circular(50),
        onPressed: isLoading ? null : onPressed,
        child: isLoading
            ? const Center(
                child: SizedBox(
                  width: 20.0,
                  height: 20.0,
                  child: CircularProgressIndicator(
                    strokeWidth: 3,
                    valueColor: AlwaysStoppedAnimation(AppColors.main),
                  ),
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (hasIcon == true)
                    Row(
                      children: [
                        Image.asset(
                          Images.whatsapp,
                          width: 26,
                          height: 26,
                        ),
                        const SizedBox(width: 5),
                      ],
                    ),
                  Text(
                    text,
                    style: textStyle ??
                        AppTextStyle.s18w700.copyWith(
                          color: Colors.white,
                        ),
                  ),
                ],
              ),
      ),
    );
  }
}
