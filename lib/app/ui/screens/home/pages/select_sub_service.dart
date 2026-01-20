import 'package:auto_master/app/app.dart';
import 'package:auto_master/app/domain/states/customer/home_state.dart';
import 'package:auto_master/app/ui/routes/routes.dart';
import 'package:auto_master/app/ui/screens/auth/pages/pages.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import 'package:auto_master/app/ui/theme/theme.dart';
import 'package:auto_master/app/ui/widgets/widgets.dart';

class SelectSubService extends StatefulWidget {
  const SelectSubService({
    Key? key,
  }) : super(key: key);

  @override
  State<SelectSubService> createState() => _SelectSubServiceState();
}

class _SelectSubServiceState extends State<SelectSubService> {
  List<String> services = [];

  @override
  void initState() {
    super.initState();
    services = context.read<HomeState>().selectedSpec?.listOfSubCategory ?? [];
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<HomeState>();
    final read = context.read<HomeState>();
    return Scaffold(
      body: SizedBox(
        width: double.infinity,
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.only(left: 29, top: 30),
                  child: CustomIconButton(onPressed: () {
                    Navigator.pop(context);
                  }),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                  top: SizerUtil.height * .05,
                  bottom: SizerUtil.height * .13,
                ),
                child: Text(
                  state.selectedSpec?.nameOfCategory ?? '',
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
                    onPressed: () => read.selectSubCetegory(services[index]),
                    isActive: services[index] == state.selectedSubCategory,
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
                  onPressed: state.selectedSubCategory == null ||
                          (state.selectedSubCategory?.trim().isEmpty ?? false)
                      ? null
                      : () {
                          routemaster.replace(AppRoutes.selectAuto);
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
