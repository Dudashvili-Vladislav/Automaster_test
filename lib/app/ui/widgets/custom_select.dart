import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:auto_master/app/ui/theme/app_colors.dart';
import 'package:auto_master/app/ui/theme/app_text_style.dart';

class CustomSelect extends StatelessWidget {
  const CustomSelect({
    Key? key,
    this.isActive = false,
    required this.onPressed,
    required this.onTap,
    this.currentCheck,
    required this.values,
    this.title = 'Выберите авто',
  }) : super(key: key);

  final bool isActive;
  final VoidCallback onPressed;
  final ValueChanged onTap;
  final int? currentCheck;
  final List<String> values;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        AnimatedContainer(
          height: isActive ? (values.length * 46) + 46 : 46,
          padding: const EdgeInsets.only(top: 46.0),
          duration: const Duration(milliseconds: 250),
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                blurRadius: 4,
                color: Colors.black.withOpacity(.25),
              ),
            ],
            borderRadius: BorderRadius.circular(23),
            border: Border.all(
              color: isActive ? AppColors.main : Colors.white,
            ),
          ),
          child: ListView.builder(
            physics: const RangeMaintainingScrollPhysics(),
            itemCount: values.length,
            itemBuilder: (context, index) => CustomSelectItem(
              isChecked: index == currentCheck,
              onTap: () {
                onTap(index);
                onPressed();
              },
              text: values[index],
            ),
          ),
        ),
        CupertinoButton(
          padding: EdgeInsets.zero,
          onPressed: onPressed,
          child: Container(
            width: double.infinity,
            height: 46,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(60),
              border: Border.all(
                color: isActive ? AppColors.main : Colors.white,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 22)
                      .copyWith(right: 13),
                  child: Row(
                    children: [
                      Text(
                        currentCheck == null ? title : values[currentCheck!],
                        style: AppTextStyle.s14w400.copyWith(
                          color: AppColors.grey,
                        ),
                      ),
                      const Spacer(),
                      isActive
                          ? const Icon(
                              Icons.keyboard_arrow_down,
                              color: AppColors.main,
                              size: 30,
                            )
                          : const Icon(
                              Icons.keyboard_arrow_up,
                              color: AppColors.grey,
                              size: 30,
                            ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class CustomSelectItem extends StatelessWidget {
  const CustomSelectItem({
    Key? key,
    required this.isChecked,
    required this.onTap,
    required this.text,
  }) : super(key: key);

  final bool isChecked;
  final VoidCallback onTap;
  final String text;

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      padding: const EdgeInsets.symmetric(horizontal: 22).copyWith(right: 15),
      onPressed: onTap,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            text,
            style: AppTextStyle.s14w400.copyWith(
              color: AppColors.grey,
            ),
          ),
          const Spacer(),
          if (isChecked)
            const Icon(
              Icons.check,
              color: AppColors.main,
            ),
        ],
      ),
    );
  }
}
