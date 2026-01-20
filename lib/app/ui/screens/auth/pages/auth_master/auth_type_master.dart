import 'package:auto_master/app/app.dart';
import 'package:auto_master/app/domain/states/register_state.dart';
import 'package:auto_master/app/ui/routes/routes.dart';
import 'package:auto_master/app/ui/screens/auth/pages/auth_master/auth_car_model.dart';
import 'package:auto_master/app/ui/screens/screens.dart';
import 'package:auto_master/app/ui/theme/theme.dart';
import 'package:auto_master/app/ui/widgets/widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class AuthTypeMaster extends StatefulWidget {
  const AuthTypeMaster({super.key});

  @override
  State<AuthTypeMaster> createState() => _AuthTypeMasterState();
}

class _AuthTypeMasterState extends State<AuthTypeMaster> {
  @override
  void initState() {
    super.initState();
    Future.microtask(context.read<RegisterState>().getSpecs);
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<RegisterState>();
    final read = context.read<RegisterState>();
    final specs = state.specs;
    return WillPopScope(
      onWillPop: () async {
        read.selectSpec(null);
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          foregroundColor: Colors.black,
        ),
        body: SafeArea(
          child: SizedBox(
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: SizerUtil.height * .05),
                Text(
                  'Ваша\nСпециализация',
                  style: AppTextStyle.s32w600.copyWith(
                    color: AppColors.main,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: SizerUtil.height * .03),
                Expanded(
                  child: state.isLoading
                      ? const Loading()
                      : ListView.separated(
                          itemCount: specs.length,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 22.0, vertical: 22.0),
                          itemBuilder: (context, index) => MasterTypeButton(
                            text: specs[index].nameOfCategory,
                            onPressed: () => read.selectSpec(specs[index]),
                            isActive: specs[index] == state.selectedSpec,
                          ),
                          separatorBuilder: (BuildContext context, int index) =>
                              const SizedBox(height: 20),
                        ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    bottom: 53.0,
                    top: 20.0,
                  ),
                  child: CustomButton(
                    width: 234,
                    height: 47,
                    text: 'Далее',
                    onPressed: state.selectedSpec == null
                        ? null
                        : () {
                            if (state.selectedSpec!.listOfSubCategory!.length >
                                1) {
                              authAvtoServiceItems =
                                  state.selectedSpec!.listOfSubCategory!;
                              authAvtoServiceSpec =
                                  state.selectedSpec!.nameOfCategory;

                              routemaster.push(AuthAvtoService.routeName);
                              // Navigator.push(
                              //   context,
                              //   MaterialPageRoute(
                              //     builder: (context) =>
                              //         ChangeNotifierProvider.value(
                              //       value: read,
                              //       child: AuthAvtoService(
                              //         items: state
                              //             .selectedSpec!.listOfSubCategory!,
                              //         spec: state.selectedSpec!.nameOfCategory,
                              //       ),
                              //     ),
                              //   ),
                              // );
                            } else {
                              final categories =
                                  state.selectedSpec?.listOfSubCategory;
                              read.selectSubCategory(
                                categories != null && categories.isNotEmpty
                                    ? categories.first
                                    : '',
                              );

                              routemaster
                                  .push(AppRoutes.registerMasterSelectCars);

                              //   if ((state.selectedSpec?.carModelStatus ??
                              //       false)) {
                              //     Navigator.push(
                              //       context,
                              //       CupertinoPageRoute(
                              //         builder: (context) =>
                              //             ChangeNotifierProvider.value(
                              //           value: read,
                              //           child: const AuthCarModel(),
                              //         ),
                              //       ),
                              //     );
                              //   } else {
                              //     Navigator.push(
                              //       context,
                              //       CupertinoPageRoute(
                              //         builder: (context) =>
                              //             ChangeNotifierProvider.value(
                              //           value: read,
                              //           child: const AuthTypeCar(),
                              //         ),
                              //       ),
                              //     );
                              //   }
                              // }
                              // final isProfile = routemaster
                              //         .currentConfiguration?.path
                              //         .split('/')[1] ==
                              //     'profile';
                              // final route = isProfile
                              //     ? AppRoutes.masterEditAutoService
                              //     : AppRoutes.registerMasterSetAutoService;

                              // routemaster.push(route);
                              // },
                            }
                          },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class MasterTypeButton extends StatelessWidget {
  const MasterTypeButton({
    super.key,
    required this.text,
    this.isActive = false,
    required this.onPressed,
  });
  final VoidCallback onPressed;
  final String text;
  final bool isActive;

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      padding: EdgeInsets.zero,
      onPressed: isActive ? null : onPressed,
      child: Container(
        clipBehavior: Clip.antiAlias,
        width: double.infinity,
        height: 67,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(60),
          color: isActive ? AppColors.main : Colors.white,
          boxShadow: [
            BoxShadow(
              blurRadius: isActive ? 4 : 10,
              color: isActive ? AppColors.main : Colors.black.withOpacity(.4),
            ),
          ],
        ),
        child: Center(
          child: Text(
            text,
            style: AppTextStyle.s20w700
                .copyWith(color: isActive ? Colors.white : AppColors.black),
          ),
        ),
      ),
    );
  }
}
