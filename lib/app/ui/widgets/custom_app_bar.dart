import 'package:flutter/material.dart';

import 'package:auto_master/app/ui/theme/theme.dart';

import 'widgets.dart';

class CustomAppBar extends StatelessWidget {
  const CustomAppBar({
    Key? key,
    this.title = 'Новые заказы',
    this.onBack,
  }) : super(key: key);

  final String title;
  final VoidCallback? onBack;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32.0).copyWith(
        top: 15.0,
        bottom: 20.0,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          CustomIconButton(onPressed: onBack),
          Text(
            title,
            style: AppTextStyle.s15w700.copyWith(
              color: AppColors.main,
            ),
          ),
          const SizedBox(width: 40.0),
        ],
      ),
    );
  }
}
