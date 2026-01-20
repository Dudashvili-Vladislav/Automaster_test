import 'package:auto_master/app/app.dart';
import 'package:auto_master/app/domain/states/register_state.dart';
import 'package:auto_master/app/ui/routes/routes.dart';
import 'package:auto_master/app/ui/screens/tabbar/master_tabbar_screen.dart';
import 'package:auto_master/app/ui/theme/theme.dart';
import 'package:auto_master/app/ui/widgets/widgets.dart';

import 'package:auto_master/resources/resources.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class AuthTypeChooseSceen extends StatelessWidget {
  const AuthTypeChooseSceen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<RegisterState>();
    final read = context.read<RegisterState>();
    showAppTracking();
    return Scaffold(
      body: SafeArea(
        child: state.isRegisterLoading
            ? const Loading()
            : SizedBox(
                width: double.infinity,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 34),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(height: SizerUtil.height * .11),
                      Text(
                        'Кто вы?',
                        style: AppTextStyle.s32w600.copyWith(
                          color: AppColors.main,
                        ),
                      ),
                      const Spacer(flex: 2),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          CupertinoButton(
                            padding: EdgeInsets.zero,
                            onPressed: read.registerClient,
                            child: Container(
                              decoration: BoxDecoration(
                                color: AppColors.main,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              width: 140,
                              height: 140,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SvgPicture.asset(
                                    Svgs.person,
                                    width: 60,
                                    height: 60,
                                  ),
                                  const SizedBox(height: 16),
                                  Text(
                                    'Я клиент',
                                    style: AppTextStyle.s14w600.copyWith(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                          CupertinoButton(
                            padding: EdgeInsets.zero,
                            onPressed: () {
                              routemaster.push(AppRoutes.registerMasterSetSpec);
                              // Navigator.push(
                              //   context,
                              //   MaterialPageRoute(
                              //     builder: (context) =>
                              //         ChangeNotifierProvider.value(
                              //       value: read,
                              //       child: const AuthTypeMaster(),
                              //     ),
                              //   ),
                              // );
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: AppColors.main,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              width: 140,
                              height: 140,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SvgPicture.asset(
                                    Svgs.master,
                                    width: 60,
                                    height: 60,
                                  ),
                                  const SizedBox(height: 16),
                                  Text(
                                    'Я мастер',
                                    style: AppTextStyle.s14w600.copyWith(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      const Spacer(flex: 5),
                      // CustomButton(
                      //   width: 234,
                      //   height: 47,
                      //   text: 'Далее',
                      //   onPressed: () {},
                      // ),
                      // const SizedBox(height: 53),
                    ],
                  ),
                ),
              ),
      ),
    );
  }
}
