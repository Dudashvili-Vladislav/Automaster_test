import 'package:another_xlider/another_xlider.dart';
import 'package:another_xlider/enums/tooltip_direction_enum.dart';
import 'package:another_xlider/models/handler.dart';
import 'package:another_xlider/models/hatch_mark.dart';
import 'package:another_xlider/models/hatch_mark_label.dart';
import 'package:another_xlider/models/tooltip/tooltip.dart';
import 'package:another_xlider/models/tooltip/tooltip_position_offset.dart';
import 'package:another_xlider/models/trackbar.dart';
import 'package:auto_master/app/ui/screens/home/pages/location_disabled_dialog.dart';
import 'package:auto_master/app/ui/screens/home/pages/location_warning_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import 'package:auto_master/app/domain/states/customer/home_state.dart';
import 'package:auto_master/app/ui/theme/app_colors.dart';
import 'package:auto_master/app/ui/theme/app_text_style.dart';
import 'package:auto_master/app/ui/widgets/widgets.dart';

class SelectDistancePage extends StatefulWidget {
  const SelectDistancePage({super.key});

  @override
  State<SelectDistancePage> createState() => _SelectDistancePageState();
}

class _SelectDistancePageState extends State<SelectDistancePage> {
  int? distanceIndex = 0;
  int distanceKm = 0;

  selectDistance(int? newIndex, {int? km}) {
    distanceIndex = newIndex;

    distanceKm = newIndex == null ? km! : kmList[newIndex];

    setState(() {});
  }

  final kmList = [10, 25, 50, 100, 200];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const CustomAppBar(
              title: 'Создание заявки',
            ),
            const SizedBox(height: 58),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 28.0),
              child: Column(
                children: [
                  Text(
                    'Выберете удобное расстояния\nдля поиска специалиста',
                    style: AppTextStyle.s14w400.copyWith(
                      color: AppColors.black,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: SizerUtil.height * .12),
                  CustomSlider(
                    distanceKm: distanceKm,
                    onDrag: (p0, p1, p2) {
                      final v = (p1 as double).toInt();
                      final index = kmList.indexOf(v);
                      if (index != -1) {
                        selectDistance(index);
                      } else {
                        selectDistance(null, km: v);
                      }
                    },
                  ),
                  const SizedBox(height: 42),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: List.generate(
                      kmList.length,
                      (index) => DistanceConteiner(
                        text: '${kmList[index]} км',
                        onPressed: () {
                          selectDistance(index);
                        },
                        isActive: index == distanceIndex,
                      ),
                    ),
                  )
                ],
              ),
            ),
            const Spacer(),
            CustomButton(
              width: 234,
              height: 47,
              text: 'Отправить заявку',
              isLoading: context.watch<HomeState>().isCreateLoading,
              onPressed: distanceKm == 0
                  ? null
                  : () async {
                      // print('===========================================');
                      // print(await Geolocator.isLocationServiceEnabled());
                      if (!await Permission.location.isGranted) {
                        showDialog(
                          context: context,
                          builder: (context) => LocationWarningDialog(),
                        );
                        return;
                      }
                      // print(await Geolocator.isLocationServiceEnabled());
                      // if (!await Geolocator.isLocationServiceEnabled())
                      //   print('Geo is disabled');
                      //   showDialog(
                      //     context: context,
                      //     builder: (context) => LocationDisabledDialog(),
                      //   );
                      //   return;
                      // }
                      // print('Create');
                      context.read<HomeState>().setRadius(distanceKm);
                      context.read<HomeState>().createOrder();
                    },
            ),
            const SizedBox(height: 27),
          ],
        ),
      ),
    );
  }
}

class DistanceConteiner extends StatelessWidget {
  const DistanceConteiner({
    super.key,
    required this.text,
    this.isActive = false,
    required this.onPressed,
  });
  final String text;
  final bool isActive;
  final VoidCallback onPressed;
  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      padding: EdgeInsets.zero,
      onPressed: isActive ? null : onPressed,
      child: Container(
        width: 55,
        height: 27,
        decoration: BoxDecoration(
          color: isActive ? AppColors.main : Colors.white,
          border: Border.all(
            color: AppColors.main,
            width: 2,
          ),
          borderRadius: BorderRadius.circular(60),
        ),
        child: Center(
          child: Text(
            text,
            style: AppTextStyle.s12w600.copyWith(
              color: isActive ? Colors.white : AppColors.main,
            ),
          ),
        ),
      ),
    );
  }
}

class CustomSlider extends StatefulWidget {
  const CustomSlider({
    Key? key,
    required this.distanceKm,
    this.onDrag,
  }) : super(key: key);

  final int distanceKm;
  final Function(int, dynamic, dynamic)? onDrag;

  @override
  State<CustomSlider> createState() => _CustomSliderState();
}

class _CustomSliderState extends State<CustomSlider> {
  @override
  void didUpdateWidget(covariant CustomSlider oldWidget) {
    index = widget.distanceKm.toDouble();
    if (mounted) setState(() {});
    super.didUpdateWidget(oldWidget);
  }

  // final values = [
  //   FlutterSliderFixedValue(value: 10, percent: 10),
  //   FlutterSliderFixedValue(value: 25, percent: 30),
  //   FlutterSliderFixedValue(value: 50, percent: 50),
  //   FlutterSliderFixedValue(value: 100, percent: 70),
  //   FlutterSliderFixedValue(value: 200, percent: 100)
  // ];

  double index = 0;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 52,
      child: FlutterSlider(
        handlerHeight: 10,
        values: [index],
        maximumDistance: 200,
        touchSize: 30,
        jump: false,
        // fixedValues: values,
        selectByTap: true,
        max: 200,
        min: 0,
        onDragCompleted: widget.onDrag,
        tooltip: FlutterSliderTooltip(
          disabled: false,
          alwaysShowTooltip: true,
          direction: FlutterSliderTooltipDirection.top,
          positionOffset: FlutterSliderTooltipPositionOffset(top: -16),
          custom: (value) => Text(
            value < 5 || value > 195 ? ' ' : '${value.toInt()}км',
            style: AppTextStyle.s16w700.copyWith(
              color: AppColors.main,
            ),
          ),
        ),
        hatchMark: FlutterSliderHatchMark(
          labelsDistanceFromTrackBar: -60,
          labels: [
            FlutterSliderHatchMarkLabel(
              percent: 0,
              label: Text(
                '0км',
                style: AppTextStyle.s12w400.copyWith(
                  color: AppColors.grey,
                ),
              ),
            ),
            FlutterSliderHatchMarkLabel(
              percent: 100,
              label: Text(
                '200км',
                style: AppTextStyle.s12w400.copyWith(
                  color: AppColors.grey,
                ),
              ),
            ),
          ],
        ),
        handler: FlutterSliderHandler(
          decoration: const BoxDecoration(shape: BoxShape.circle),
          child: Container(
            width: 12,
            height: 12,
            decoration: const BoxDecoration(
              color: AppColors.main,
              shape: BoxShape.circle,
            ),
          ),
        ),
        trackBar: FlutterSliderTrackBar(
          centralWidget: Row(
            children: [
              Container(
                width: 12,
                height: 12,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.main,
                ),
              ),
            ],
          ),
          activeTrackBarHeight: 4,
          inactiveTrackBarHeight: 4,
          activeTrackBar: const BoxDecoration(
            color: AppColors.main,
          ),
          inactiveTrackBar: const BoxDecoration(
            color: Color(0xFFB6B6B6),
          ),
        ),
      ),
    );
  }
}
