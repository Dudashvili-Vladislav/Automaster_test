import 'package:auto_master/app/domain/states/master/master_profile_state.dart';
import 'package:auto_master/app/ui/theme/theme.dart';
import 'package:auto_master/app/ui/widgets/widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import 'edit_profile.dart';

class EditServiceDescription extends StatefulWidget {
  const EditServiceDescription({super.key});

  @override
  State<EditServiceDescription> createState() => _EditServiceDescriptionState();
}

class _EditServiceDescriptionState extends State<EditServiceDescription> {
  final nameController = TextEditingController();
  final descController = TextEditingController();

  final nameNode = FocusNode();
  final descNode = FocusNode();

  bool nameHasFocus = false;
  bool descHasFocus = false;

  void changeFocus(String type, bool value) {
    if (type == 'name') {
      nameHasFocus = value;
    } else {
      descHasFocus = value;
    }

    if (mounted) setState(() {});
  }

  @override
  void initState() {
    super.initState();
    nameNode.addListener(() => changeFocus('name', nameNode.hasFocus));
    descNode.addListener(() => changeFocus('desc', descNode.hasFocus));
    nameController.text = context.read<MasterProfileState>().serviceName ?? '';
    descController.text = context.read<MasterProfileState>().serviceDesc ?? '';
  }

  @override
  void dispose() {
    nameController.dispose();
    descController.dispose();
    nameNode.removeListener(() => changeFocus('name', nameNode.hasFocus));
    descNode.removeListener(() => changeFocus('desc', descNode.hasFocus));
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<MasterProfileState>();
    final read = context.read<MasterProfileState>();
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;
    return GestureDetector(
      onTap: FocusScope.of(context).unfocus,
      child: Scaffold(
        body: SafeArea(
          child: SizedBox(
            width: double.infinity,
            child: Column(
              children: [
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: EdgeInsets.only(left: 20.0, top: 20.0),
                    child: CustomIconButton(),
                  ),
                ),
                Expanded(
                  child: ListView(
                    physics: const RangeMaintainingScrollPhysics(),
                    padding: const EdgeInsets.all(22).copyWith(top: 0),
                    children: [
                      // SizedBox(height: SizerUtil.height * .07),
                      Center(
                        child: Text(
                          'Подробнее',
                          style: AppTextStyle.s32w600
                              .copyWith(color: AppColors.main),
                        ),
                      ),
                      const SizedBox(height: 36),
                      Center(
                        child: Text(
                          'Описание ваших услуг',
                          style: AppTextStyle.s14w400.copyWith(
                            color: AppColors.black,
                          ),
                        ),
                      ),
                      const SizedBox(height: 58),
                      Column(
                        children: [
                          CustomInput(
                            node: nameNode,
                            hasFocus: nameHasFocus,
                            controller: nameController,
                            hintText: 'Добавьте название',
                            onChange: (v) =>
                                read.setServiceName(v.isEmpty ? null : v),
                          ),
                          const SizedBox(height: 20),
                          Container(
                            margin: EdgeInsets.only(
                                bottom: bottomInset > 10 ? 40 : 0),
                            clipBehavior: Clip.antiAlias,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                  blurRadius: descHasFocus ? 5 : 4,
                                  color: descHasFocus
                                      ? AppColors.main.withOpacity(.5)
                                      : Colors.black.withOpacity(.25),
                                ),
                              ],
                            ),
                            child: TextField(
                              controller: descController,
                              maxLines: 12,
                              clipBehavior: Clip.antiAlias,
                              focusNode: descNode,
                              cursorColor: AppColors.main,
                              onChanged: (v) =>
                                  read.setServiceDesc(v.isEmpty ? null : v),
                              decoration: InputDecoration(
                                hintText: 'Добавьте описание',
                                hintStyle: AppTextStyle.s14w400.copyWith(
                                  color: AppColors.grey,
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                  borderSide: BorderSide.none,
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                  borderSide: const BorderSide(
                                    color: AppColors.main,
                                    width: 2.0,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20.0),
                CustomButton(
                  width: 234,
                  height: 47,
                  text: 'Далее',
                  onPressed:
                      state.serviceName == null || state.serviceDesc == null
                          ? null
                          : () {
                              Navigator.pushReplacement(
                                context,
                                CupertinoPageRoute(
                                  builder: (_) => ChangeNotifierProvider.value(
                                    value: read,
                                    child: const EditProfileEditScreen(),
                                  ),
                                ),
                              );
                            },
                ),
                const SizedBox(height: 33),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
