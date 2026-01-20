import 'package:auto_master/app/domain/states/master/master_profile_state.dart';
import 'package:auto_master/app/ui/screens/edit_master_info/edit_car_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import 'package:auto_master/app/ui/theme/theme.dart';
import 'package:auto_master/app/ui/widgets/widgets.dart';

import 'edit_type_car.dart';
import 'edit_type_master.dart';

class EditAvtoService extends StatefulWidget {
  const EditAvtoService({
    Key? key,
    required this.items,
    required this.spec,
  }) : super(key: key);

  final List<String> items;
  final String spec;

  @override
  State<EditAvtoService> createState() => _EditAvtoServiceState();
}

class _EditAvtoServiceState extends State<EditAvtoService> {
  List<String> services = [];

  @override
  void initState() {
    services = widget.items;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final selectedSubCategory =
        context.select((MasterProfileState vm) => vm.selectedSubCategory);
    final read = context.read<MasterProfileState>();
    return WillPopScope(
      onWillPop: () async {
        read.selectSubCategory(null);
        return true;
      },
      child: Scaffold(
        body: SizedBox(
          width: double.infinity,
          child: SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: EdgeInsets.only(left: 20.0, top: 20.0),
                    child: CustomIconButton(),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                    top: SizerUtil.height * .04,
                    bottom: SizerUtil.height * .13,
                  ),
                  child: Text(
                    widget.spec,
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
                            if ((read.selectedSpec?.carModelStatus ?? false)) {
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
