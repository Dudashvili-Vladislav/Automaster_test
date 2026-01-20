import 'package:auto_master/app/app.dart';
import 'package:auto_master/app/domain/states/register_state.dart';
import 'package:auto_master/app/ui/routes/routes.dart';
import 'package:auto_master/app/ui/theme/theme.dart';
import 'package:auto_master/app/ui/widgets/widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import 'auth_profile_edit.dart';

class AuthServiceDescription extends StatefulWidget {
  const AuthServiceDescription({super.key});

  @override
  State<AuthServiceDescription> createState() => _AuthServiceDescriptionState();
}

class _AuthServiceDescriptionState extends State<AuthServiceDescription> {
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
    final state = context.watch<RegisterState>();
    final read = context.read<RegisterState>();
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;
    return GestureDetector(
      onTap: FocusScope.of(context).unfocus,
      child: Scaffold(
        appBar: AppBar(
          surfaceTintColor: Colors.white,
          backgroundColor: Colors.white,
          elevation: 0,
          foregroundColor: Colors.black,
        ),
        body: SafeArea(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 16),
            // width: double.infinity,
            child: Column(
              children: [
                // Expanded(
                //   child: ListView(
                //     physics: const RangeMaintainingScrollPhysics(),
                //     padding: const EdgeInsets.all(22).copyWith(top: 0),
                //     children: [
                // SizedBox(height: SizerUtil.height * .11),
                Center(
                  child: Text(
                    'Подробнее',
                    style: AppTextStyle.s32w600.copyWith(color: AppColors.main),
                  ),
                ),
                const SizedBox(height: 8),
                Center(
                  child: Text(
                    'Описание ваших услуг',
                    style: AppTextStyle.s14w400.copyWith(
                      color: AppColors.black,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                // Column(
                //   children: [
                CustomInput(
                  node: nameNode,
                  hasFocus: nameHasFocus,
                  hintText: 'Добавьте название',
                  onChange: (v) => read.setServiceName(v.isEmpty ? null : v),
                ),
                const SizedBox(height: 16),
                Container(
                  // margin:
                  height: 80,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  //     EdgeInsets.only(bottom: bottomInset > 10 ? 40 : 0),
                  clipBehavior: Clip.antiAlias,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border:
                        descHasFocus ? Border.all(color: AppColors.main) : null,
                    boxShadow: [
                      BoxShadow(
                        blurRadius: descHasFocus ? 5 : 4,
                        color: descHasFocus
                            ? AppColors.main.withOpacity(.5)
                            : Colors.black.withOpacity(.25),
                      ),
                    ],
                  ),
                  child: SingleChildScrollView(
                    child: TextField(
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
                        border: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        errorBorder: InputBorder.none,
                        disabledBorder: InputBorder.none,
                        // enabledBorder: OutlineInputBorder(
                        //   borderRadius: BorderRadius.circular(20),
                        //   borderSide: BorderSide.none,
                        // ),
                        // focusedBorder: OutlineInputBorder(
                        //   borderRadius: BorderRadius.circular(20),
                        //   borderSide: const BorderSide(
                        //     color: AppColors.main,
                        //     width: 2.0,
                        //   ),
                        // ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 16),
                //   ],
                // ),
                Spacer(),
                // const SizedBox(height: 20.0),
                CustomButton(
                  width: 234,
                  height: 47,
                  text: 'Далее',
                  onPressed: state.serviceName == null ||
                          state.serviceDesc == null
                      ? null
                      : () {
                          routemaster.push(AppRoutes.registerMasterSetAvatar);
                          // Navigator.push(
                          //   context,
                          //   CupertinoPageRoute(
                          //     builder: (_) => ChangeNotifierProvider.value(
                          //       value: read,
                          //       child: const AuthProfileEditScreen(),
                          //     ),
                          //   ),
                          // );
                        },
                ),
                const SizedBox(height: 32),
              ],
            ),
          ),

          // const SizedBox(height: 33),
          // ],
          // ),
          // ),
        ),
      ),
    );
  }
}
