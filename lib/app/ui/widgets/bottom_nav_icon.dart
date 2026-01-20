import 'package:auto_master/app/ui/theme/app_colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../theme/app_text_style.dart';

class BottomNavIcon extends StatelessWidget {
  const BottomNavIcon({
    super.key,
    required this.text,
    required this.icon,
    this.isActive = false,
    required this.onPressed,
  });
  final String text;
  final String icon;
  final bool isActive;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      padding: EdgeInsets.zero,
      onPressed: onPressed,
      child: Column(
        children: [
          SvgPicture.asset(
            icon,
            width: 20,
            height: 20,
            // ignore: deprecated_member_use
            color: isActive ? AppColors.main : AppColors.grey,
          ),
          const SizedBox(height: 6),
          Text(
            text,
            style: AppTextStyle.s12w400.copyWith(
              color: isActive ? AppColors.main : AppColors.grey,
            ),
          ),
        ],
      ),
    );
  }
}
