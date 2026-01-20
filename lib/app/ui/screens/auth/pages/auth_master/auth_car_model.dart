import 'package:auto_master/app/domain/models/car_brand.dart';
import 'package:auto_master/app/domain/service/car_service.dart';
import 'package:auto_master/app/domain/states/register_state.dart';
import 'package:auto_master/app/ui/screens/auth/pages/auth_master/auth_type_car.dart';
import 'package:auto_master/app/ui/theme/theme.dart';
import 'package:auto_master/app/ui/widgets/widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:searchfield/searchfield.dart';
import 'package:sizer/sizer.dart';

class AuthCarModel extends StatefulWidget {
  const AuthCarModel({Key? key}) : super(key: key);

  @override
  State<AuthCarModel> createState() => _AuthCarModelState();
}

class _AuthCarModelState extends State<AuthCarModel> {
  final brandController = TextEditingController();
  final brandNode = FocusNode();
  List<CarBrand> _brands = [];
  bool isActiveDown = false;

  void toggleDown() {
    FocusScope.of(context).unfocus();
    isActiveDown = !isActiveDown;
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    brandController.addListener(() async {
      final query = brandController.text.trim();
      if (query.isNotEmpty && brandNode.hasFocus) {
        await Future.delayed(
          const Duration(seconds: 1),
          () => searchCarBrand(context, query),
        );
      }
    });
  }

  Future<void> searchCarBrand(BuildContext context, String query) async {
    _brands = await CarService.findCarBrand(context, query) ?? [];

    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<RegisterState>();
    final read = context.read<RegisterState>();

    final allMarksSelected = state.allMarksSelected;
    final selectedCarBrands = state.selectedCarBrands;
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: SafeArea(
          child: Column(
            children: <Widget>[
              Expanded(
                child: ListView(
                  keyboardDismissBehavior:
                      ScrollViewKeyboardDismissBehavior.onDrag,
                  padding: const EdgeInsets.symmetric(horizontal: 20.0)
                      .copyWith(bottom: 30.0),
                  children: [
                    SizedBox(height: SizerUtil.height * .03),
                    Text(
                      'Укажите\nс какими марками\nработаете',
                      style: AppTextStyle.s32w600.copyWith(
                        color: AppColors.main,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: SizerUtil.height * .05),
                    SizedBox(
                      height: 30.0,
                      child: CupertinoButton(
                        onPressed: read.toggleAllMarks,
                        padding: EdgeInsets.zero,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                              'Все марки автомобилей',
                              style: AppTextStyle.s16w600.copyWith(
                                fontWeight: FontWeight.w500,
                                color: AppColors.black,
                              ),
                            ),
                            Icon(
                              allMarksSelected
                                  ? Icons.check_box
                                  : Icons.check_box_outline_blank,
                              color: allMarksSelected
                                  ? AppColors.main
                                  : AppColors.black,
                            ),
                          ],
                        ),
                      ),
                    ),
                    if (!allMarksSelected) const SizedBox(height: 30.0),
                    if (!allMarksSelected)
                      SearchInput(
                        controller: brandController,
                        node: brandNode,
                        onTap: (i) {
                          read.selectBrand((i.item as CarBrand).name);
                          brandController.text = (i.item as CarBrand).name[0];
                        },
                        suggestions: List.generate(
                          _brands.length,
                          (index) => SearchFieldListItem(
                            index.toString(),
                            item: _brands[index],
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(_brands[index].name),
                                  if (selectedCarBrands
                                      .contains(_brands[index].name))
                                    const Icon(
                                      Icons.check,
                                      color: AppColors.main,
                                    ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    if (!allMarksSelected)
                      AnimatedContainer(
                        height: brandNode.hasFocus ? 300 : 0,
                        duration: kThemeAnimationDuration,
                      ),
                    if (!allMarksSelected)
                      const Padding(
                        padding: EdgeInsets.only(
                          top: 150.0,
                          bottom: 40.0,
                        ),
                        child: Text(
                          'Вы выбрали:',
                          textAlign: TextAlign.center,
                          style: AppTextStyle.s14w400,
                        ),
                      ),
                    if (selectedCarBrands.isNotEmpty && !allMarksSelected)
                      ...List.generate(
                        selectedCarBrands.length,
                        (index) => Container(
                          height: 46.0,
                          margin: const EdgeInsets.only(bottom: 20.0),
                          padding: const EdgeInsets.symmetric(horizontal: 22.0),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            boxShadow: [
                              AppTheme.shadowBlur4,
                            ],
                            borderRadius: BorderRadius.circular(60.0),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text(
                                selectedCarBrands[index],
                                style: AppTextStyle.s14w400,
                              ),
                              SizedBox(
                                width: 20.0,
                                height: 46.0,
                                child: CupertinoButton(
                                  padding: EdgeInsets.zero,
                                  child: const Icon(
                                    Icons.close,
                                    color: AppColors.main,
                                  ),
                                  onPressed: () => read.deleteBrand(
                                    selectedCarBrands[index],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              CustomButton(
                  width: 234,
                  height: 47,
                  text: 'Далее',
                  onPressed: !allMarksSelected && selectedCarBrands.isEmpty
                      ? null
                      : () {
                          Navigator.push(
                            context,
                            CupertinoPageRoute(
                              builder: (context) =>
                                  ChangeNotifierProvider.value(
                                value: read,
                                child: const AuthTypeCar(),
                              ),
                            ),
                          );
                        }),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}
