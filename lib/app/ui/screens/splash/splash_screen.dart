import 'package:auto_master/app/app.dart';
import 'package:auto_master/app/ui/routes/routes.dart';

import 'package:auto_master/app/ui/theme/theme.dart';
import 'package:auto_master/app/ui/widgets/privacy_policy.dart';
import 'package:auto_master/app/ui/widgets/widgets.dart';
import 'package:auto_master/resources/resources.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({
    super.key,
  });

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    Future.microtask(() async {
      await precacheImage(const AssetImage(Images.car), context);
      isLoading = false;
      if (mounted) setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    // final isBig = SizerUtil.height > 848;
    return Scaffold(
      body: isLoading
          ? null
          : SafeArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Flexible(
                    child: Image.asset(
                      Images.car,
                      // width: double.infinity,
                      // filterQuality: FilterQuality.high,
                      // height: SizerUtil.height * .6, // : SizerUtil.height * .65,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 35),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Авто\nМастер',
                          style: AppTextStyle.s35w700.copyWith(
                            color: AppColors.main,
                            fontSize: 33.0,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'С нашим приложением, уход за\nвашим авто будет проще!',
                          style: AppTextStyle.s15w400.copyWith(
                            color: AppColors.black,
                            fontSize: 13.0,
                          ),
                        ),
                        SizedBox(height: 8),
                        // const Spacer(),
                        CustomButton(
                          text: 'Поехали!',
                          onPressed: () => routemaster.replace(AppRoutes.auth),
                        ),
                        SizedBox(height: 8),
                        // SizedBox(height: isBig ? 42 : 22.0),
                        PrivacyPolicy(),
                        SizedBox(height: 22),
                      ],
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
