import 'package:auto_master/app/ui/screens/edit_master_info/edit_car_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import 'package:auto_master/app/domain/states/master/master_profile_state.dart';
import 'package:auto_master/app/ui/screens/edit_master_info/edit_avto_service.dart';
import 'package:auto_master/app/ui/screens/edit_master_info/edit_type_car.dart';
import 'package:auto_master/app/ui/theme/theme.dart';
import 'package:auto_master/app/ui/widgets/widgets.dart';

class EditTypeMaster extends StatefulWidget {
  const EditTypeMaster({
    Key? key,
    this.backExist = true,
  }) : super(key: key);

  final bool backExist;

  @override
  State<EditTypeMaster> createState() => _EditTypeMasterState();
}

class _EditTypeMasterState extends State<EditTypeMaster> {
  @override
  void initState() {
    super.initState();
    Future.microtask(context.read<MasterProfileState>().getSpecs);
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<MasterProfileState>();
    final read = context.read<MasterProfileState>();
    final specs = state.specs;

    return Scaffold(
      body: SafeArea(
        child: SizedBox(
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              if (widget.backExist)
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: EdgeInsets.only(left: 20.0, top: 20.0),
                    child: CustomIconButton(),
                  ),
                ),
              SizedBox(
                height: SizerUtil.height * (widget.backExist ? .03 : .06),
              ),
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
                          horizontal: 22.0,
                          vertical: 22.0,
                        ),
                        itemBuilder: (context, index) => MasterTypeButton(
                          text: specs[index].nameOfCategory,
                          onPressed: () => read.selectSpec(specs[index]),
                          isActive: specs[index].nameOfCategory ==
                              state.selectedSpec?.nameOfCategory,
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
                            Navigator.pushReplacement(
                              context,
                              CupertinoPageRoute(
                                builder: (context) =>
                                    ChangeNotifierProvider.value(
                                  value: read,
                                  child: EditAvtoService(
                                    items:
                                        state.selectedSpec!.listOfSubCategory!,
                                    spec: state.selectedSpec!.nameOfCategory,
                                  ),
                                ),
                              ),
                            );
                          } else {
                            final categories =
                                state.selectedSpec?.listOfSubCategory;
                            read.selectSubCategory(
                              categories != null && categories.isNotEmpty
                                  ? categories.first
                                  : '',
                            );
                            if ((state.selectedSpec?.carModelStatus ?? false)) {
                              Navigator.pushReplacement(
                                context,
                                CupertinoPageRoute(
                                  builder: (context) =>
                                      ChangeNotifierProvider.value(
                                    value: read,
                                    child: const EditCarModel(),
                                  ),
                                ),
                              );
                            } else {
                              Navigator.pushReplacement(
                                context,
                                CupertinoPageRoute(
                                  builder: (context) =>
                                      ChangeNotifierProvider.value(
                                    value: read,
                                    child: const EditTypeCar(),
                                  ),
                                ),
                              );
                            }
                          }
                          // final isProfile = routemaster
                          //         .currentConfiguration?.path
                          //         .split('/')[1] ==
                          //     'profile';
                          // final route = isProfile
                          //     ? AppRoutes.masterEditAutoService
                          //     : AppRoutes.registerMasterSetAutoService;

                          // routemaster.push(route);
                        },
                ),
              ),
            ],
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
