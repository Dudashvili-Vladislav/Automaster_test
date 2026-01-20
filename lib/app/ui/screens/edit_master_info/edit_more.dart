import 'package:auto_master/app/domain/models/address.dart';
import 'package:auto_master/app/domain/service/master_service.dart';
import 'package:auto_master/app/domain/states/master/master_profile_state.dart';
import 'package:auto_master/app/ui/theme/theme.dart';
import 'package:auto_master/app/ui/widgets/widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:searchfield/searchfield.dart';
import 'package:sizer/sizer.dart';

import 'edit_service_desc.dart';

class EditMore extends StatefulWidget {
  const EditMore({super.key});

  @override
  State<EditMore> createState() => _EditMoreState();
}

class _EditMoreState extends State<EditMore> {
  late TextEditingController experienceController;
  late TextEditingController addressController;

  final experiencNode = FocusNode();
  final addressNode = FocusNode();

  List<Address> _address = [];

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
    final read = context.read<MasterProfileState>();
    final address = read.selectedAddress;

    addressController = TextEditingController(text: address);
    experienceController = TextEditingController(
        text: read.selectedExperience ?? read.profile?.experience ?? '');

    experiencNode
        .addListener(() => changeFocus('experience', experiencNode.hasFocus));
    addressNode.addListener(() => changeFocus('address', addressNode.hasFocus));
    addressController.addListener(() {
      final query = addressController.text.trim();
      if (query.isNotEmpty && query.length >= 3) {
        Future.delayed(
          const Duration(seconds: 1),
          () => onSearch(query),
        );
      }
    });
  }

  @override
  void dispose() {
    addressController.removeListener(() {
      final query = addressController.text.trim();
      if (query.isNotEmpty && query.length >= 3) {
        Future.delayed(
          const Duration(seconds: 1),
          () => onSearch(query),
        );
      }
    });
    experienceController.dispose();
    addressController.dispose();
    experiencNode.removeListener(
        () => changeFocus('experience', experiencNode.hasFocus));
    addressNode
        .removeListener(() => changeFocus('address', addressNode.hasFocus));

    super.dispose();
  }

  void onSearch(String query) async {
    _address.clear();

    final cities = await MasterService.searchAdress(context, query);

    if (cities != null) {
      _address = cities;
    }

    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<MasterProfileState>();
    final read = context.read<MasterProfileState>();
    final isKeyboardOpen = MediaQuery.of(context).viewInsets.bottom > 10;
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
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
                        const Align(
                          alignment: Alignment.centerLeft,
                          child: Padding(
                            padding: EdgeInsets.only(top: 20.0),
                            child: CustomIconButton(),
                          ),
                        ),
                        SizedBox(height: SizerUtil.height * .03),
                        Text(
                          'Подробнее',
                          textAlign: TextAlign.center,
                          style: AppTextStyle.s32w600.copyWith(
                            color: AppColors.main,
                          ),
                        ),
                        const SizedBox(height: 36),
                        Text(
                          'Укажите ваш стаж и место работы',
                          textAlign: TextAlign.center,
                          style: AppTextStyle.s14w400.copyWith(
                            color: AppColors.black,
                          ),
                        ),
                        SizedBox(height: SizerUtil.height * .05),
                        CustomInput(
                          node: experiencNode,
                          hasFocus: experienceHasFocus,
                          controller: experienceController,
                          hintText: 'Укажите ваш стаж',
                          onChange: (v) =>
                              read.setExperience(v.isEmpty ? null : v),
                        ),
                        const SizedBox(height: 25),
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
                            _address.length,
                            (index) => SearchFieldListItem(
                              index.toString(),
                              item: _address[index],
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8.0),
                                child: Text(_address[index].value),
                              ),
                            ),
                          ),
                        ),
                        AnimatedContainer(
                          duration: kThemeAnimationDuration,
                          height: isKeyboardOpen ? 350 : 0,
                        ),
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
                            Navigator.pushReplacement(
                              context,
                              CupertinoPageRoute(
                                builder: (_) => ChangeNotifierProvider.value(
                                  value: read,
                                  child: const EditServiceDescription(),
                                ),
                              ),
                            );
                          },
                  ),
                  const SizedBox(height: 53),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
