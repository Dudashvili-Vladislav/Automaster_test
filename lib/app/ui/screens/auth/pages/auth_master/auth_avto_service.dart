import 'package:auto_master/app/app.dart';
import 'package:auto_master/app/domain/states/register_state.dart';
import 'package:auto_master/app/ui/routes/routes.dart';
import 'package:auto_master/app/ui/screens/auth/pages/auth_master/auth_car_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import 'package:auto_master/app/ui/theme/theme.dart';
import 'package:auto_master/app/ui/widgets/widgets.dart';

import 'auth_type_car.dart';
import 'auth_type_master.dart';

List<String> authAvtoServiceItems = [];
String authAvtoServiceSpec = '';

class AuthAvtoService extends StatefulWidget {
  const AuthAvtoService({
    Key? key,
  }) : super(key: key);

  static const routeName = '/auth_avto_service_subcat_choice';

  @override
  State<AuthAvtoService> createState() => _AuthAvtoServiceState();
}

class _AuthAvtoServiceState extends State<AuthAvtoService> {
  List<String> services = [];

  @override
  void initState() {
    services = authAvtoServiceItems;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final selectedSubCategory =
        context.select((RegisterState vm) => vm.selectedSubCategory);
    final read = context.read<RegisterState>();
    return WillPopScope(
      onWillPop: () async {
        read.selectSubCategory(null);
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          foregroundColor: Colors.black,
        ),
        body: SizedBox(
          width: double.infinity,
          child: SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Padding(
                  padding: EdgeInsets.only(
                    top: SizerUtil.height * .11,
                    bottom: SizerUtil.height * .13,
                  ),
                  child: Text(
                    authAvtoServiceSpec,
                    style: AppTextStyle.s32w600.copyWith(
                      color: AppColors.main,
                    ),
                  ),
                ),
                Expanded(
                  child: ListView.separated(
                    physics: const RangeMaintainingScrollPhysics(),
                    padding: const EdgeInsets.all(22),
                    itemBuilder: (context, index) => MasterTypeButton(
                      text: services[index],
                      onPressed: () => read.selectSubCategory(services[index]),
                      isActive: services[index] == selectedSubCategory,
                    ),
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: 20),
                    itemCount: services.length,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 53.0),
                  child: CustomButton(
                    width: 234,
                    height: 47,
                    text: 'Далее',
                    onPressed: selectedSubCategory == null
                        ? null
                        : () {
                            routemaster
                                .push(AppRoutes.registerMasterSelectCars);
                            // if ((read.selectedSpec?.carModelStatus ?? false)) {
                            //   Navigator.push(
                            //     context,
                            //     CupertinoPageRoute(
                            //       builder: (context) =>
                            //           ChangeNotifierProvider.value(
                            //         value: read,
                            //         child: const AuthCarModel(),
                            //       ),
                            //     ),
                            //   );
                            // } else {
                            //   Navigator.push(
                            //     context,
                            //     CupertinoPageRoute(
                            //       builder: (context) =>
                            //           ChangeNotifierProvider.value(
                            //         value: read,
                            //         child: const AuthTypeCar(),
                            //       ),
                            //     ),
                            //   );
                            // }
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
