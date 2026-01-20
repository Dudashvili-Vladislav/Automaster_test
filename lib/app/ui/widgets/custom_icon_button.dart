// ignore_for_file: deprecated_member_use

import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:auto_master/resources/resources.dart';

class CustomIconButton extends StatelessWidget {
  const CustomIconButton({
    Key? key,
    this.icon = Svgs.arrow,
    this.size = const Size(40.0, 40),
    this.iconColor,
    this.onPressed,
  }) : super(key: key);

  final String icon;
  final Size size;
  final Color? iconColor;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size.width,
      height: size.height,
      child: CupertinoButton(
        padding: EdgeInsets.zero,
        onPressed: onPressed ?? () => Navigator.pop(context),
        child: SvgPicture.asset(
          icon,
          color: iconColor,
          fit: BoxFit.scaleDown,
        ),
      ),
    );
  }
}
