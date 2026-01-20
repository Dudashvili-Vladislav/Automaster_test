import 'package:auto_master/app/app.dart';
import 'package:auto_master/app/ui/theme/app_colors.dart';
import 'package:auto_master/app/ui/theme/app_text_style.dart';
import 'package:auto_master/resources/resources.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ChatAppbar extends StatelessWidget {
  const ChatAppbar({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: kToolbarHeight,
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            CupertinoButton(
              padding: EdgeInsets.zero,
              onPressed: () => routemaster.history.back(),
              child: SvgPicture.asset(
                Svgs.arrow,
                color: AppColors.black,
              ),
            ),
            Text(
              'Общий чат',
              style: AppTextStyle.s15w700.copyWith(
                color: AppColors.main,
              ),
            ),
            const SizedBox(width: 44),
          ],
        ),
      ),
    );
  }
}
