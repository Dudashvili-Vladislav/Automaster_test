import 'package:auto_master/app/app.dart';
import 'package:auto_master/app/domain/models/address.dart';
import 'package:auto_master/app/domain/states/register_state.dart';
import 'package:auto_master/app/ui/routes/routes.dart';
import 'package:auto_master/app/ui/theme/theme.dart';
import 'package:auto_master/app/ui/widgets/widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:searchfield/searchfield.dart';
import 'package:sizer/sizer.dart';

import 'auth_service_description.dart';

class AuthMore extends StatefulWidget {
  const AuthMore({super.key});

  @override
  State<AuthMore> createState() => _AuthMoreState();
}

class _AuthMoreState extends State<AuthMore> {
  final experienceController = TextEditingController();
  final addressController = TextEditingController();

  final experiencNode = FocusNode();
  final addressNode = FocusNode();

  bool experienceHasFocus = false;
  bool addressHasFocus = false;

  void changeFocus(String type, bool value) {
    if (type == 'experience') {
      experienceHasFocus = value;
    } else {
      addressHasFocus = value;
    }

    if (mounted) setState(() {});
  }

  @override
  void initState() {
    super.initState();
    experiencNode
        .addListener(() => changeFocus('experience', experiencNode.hasFocus));
    addressNode.addListener(() => changeFocus('address', addressNode.hasFocus));
    addressController.addListener(() {
      final query = addressController.text.trim();
      if (query.isNotEmpty && query.length >= 3) {
        Future.delayed(
          const Duration(seconds: 1),
          () => context.read<RegisterState>().onSearch(query),
        );
      }
    });
  }

  @override
  void dispose() {
    experienceController.dispose();
    addressController.dispose();
    experiencNode.removeListener(
        () => changeFocus('experience', experiencNode.hasFocus));
    addressNode
        .removeListener(() => changeFocus('address', addressNode.hasFocus));
    addressController.removeListener(() {
      final query = addressController.text.trim();
      if (query.isNotEmpty && query.length >= 3) {
        Future.delayed(
          const Duration(seconds: 1),
          () => context.read<RegisterState>().onSearch(query),
        );
      }
    });
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<RegisterState>();
    final read = context.read<RegisterState>();
    final addressList = state.address;
    final isKeyboardOpen = MediaQuery.of(context).viewInsets.bottom > 10;
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          foregroundColor: Colors.black,
        ),
        resizeToAvoidBottomInset: true,
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 22),
          child: SafeArea(
            child: SizedBox(
              width: double.infinity,
              child: Column(
                children: [
                  Expanded(
                    child: ListView(
                      children: <Widget>[
                        // SizedBox(height: SizerUtil.height * .03),
                        Text(
                          'Подробнее',
                          textAlign: TextAlign.center,
                          style: AppTextStyle.s32w600.copyWith(
                            color: AppColors.main,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Укажите ваш стаж и место работы',
                          textAlign: TextAlign.center,
                          style: AppTextStyle.s14w400.copyWith(
                            color: AppColors.black,
                          ),
                        ),
                        const SizedBox(height: 16),
                        // SizedBox(height: SizerUtil.height * .05),
                        CustomInput(
                          node: experiencNode,
                          hasFocus: experienceHasFocus,
                          hintText: 'Укажите ваш стаж',
                          onChange: (v) =>
                              read.setExperience(v.isEmpty ? null : v),
                        ),
                        const SizedBox(height: 16),
                        SearchInput(
                          node: addressNode,
                          controller: addressController,
                          hint: 'Укажите адрес вашей работы',
                          onTap: (i) {
                            read.setAddress((i.item as Address).value);
                            addressController.text = (i.item as Address).value;

                            FocusScope.of(context).unfocus();
                          },
                          suggestions: List.generate(
                            addressList.length,
                            (index) => SearchFieldListItem(
                              index.toString(),
                              item: addressList[index],
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8.0),
                                child: Text(addressList[index].value),
                              ),
                            ),
                          ),
                        ),
                        AnimatedContainer(
                          duration: kThemeAnimationDuration,
                          height: isKeyboardOpen ? 350 : 0,
                        ),
                        // CustomInput(
                        //   node: addressNode,
                        //   hasFocus: addressHasFocus,
                        //   hintText: 'Укажите адрес вашей работы',
                        //   onChange: (v) =>
                        //       read.setAddress(v.isEmpty ? null : v),
                        // ),
                      ],
                    ),
                  ),
                  CustomButton(
                    width: 234,
                    height: 47,
                    text: 'Далее',
                    onPressed: state.selectedExperience == null ||
                            state.selectedAddress == null
                        ? null
                        : () {
                            routemaster
                                .push(AppRoutes.registerMasterSetAboutServices);
                            // Navigator.push(
                            //   context,
                            //   CupertinoPageRoute(
                            //     builder: (_) => ChangeNotifierProvider.value(
                            //       value: read,
                            //       child: const AuthServiceDescription(),
                            //     ),
                            //   ),
                            // );
                          },
                  ),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
