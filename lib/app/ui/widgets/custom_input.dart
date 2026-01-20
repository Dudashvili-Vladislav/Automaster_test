// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:auto_master/app/ui/theme/app_colors.dart';
import 'package:auto_master/app/ui/theme/app_text_style.dart';

class CustomInput extends StatelessWidget {
  const CustomInput({
    Key? key,
    this.color = Colors.white,
    this.hintText = '',
    this.node,
    this.onTap,
    this.hasFocus = false,
    this.isPass = false,
    this.onlyRead = false,
    this.isPhone = false,
    this.scrollPadding,
    this.keyboardType,
    this.controller,
    this.onChange,
    this.formatters,
  }) : super(key: key);
  final Color color;

  final String? hintText;
  final FocusNode? node;
  final VoidCallback? onTap;
  final bool hasFocus;
  final bool isPass;
  final bool onlyRead;
  final bool isPhone;
  final double? scrollPadding;
  final TextInputType? keyboardType;
  final TextEditingController? controller;
  final ValueChanged<String>? onChange;
  final List<TextInputFormatter>? formatters;

  static final borderStyle = OutlineInputBorder(
    borderRadius: BorderRadius.circular(60),
    borderSide: BorderSide.none,
  );

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 46,
      child: Container(
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(60),
          boxShadow: [
            BoxShadow(
              blurRadius: hasFocus ? 5 : 4,
              color: hasFocus
                  ? AppColors.main.withOpacity(.5)
                  : Colors.black.withOpacity(.25),
            ),
          ],
        ),
        child: Stack(
          children: [
            TextFormField(
              maxLines: 1,
              readOnly: onlyRead,
              controller: controller,
              onTap: onTap,
              focusNode: node,
              onChanged: onChange,
              inputFormatters: formatters,
              keyboardType: keyboardType,
              // clipBehavior: Clip.antiAlias,
              cursorColor: AppColors.main,
              scrollPadding: EdgeInsets.only(bottom: scrollPadding ?? 20),
              obscureText: isPass,
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 22.0,
                  // vertical: 16.0,
                ).copyWith(left: isPhone ? 40 : 22),
                // isDense: true,
                filled: true,
                fillColor: Colors.white,
                hintText: hintText,
                hintStyle: AppTextStyle.s14w400.copyWith(
                  color: AppColors.grey,
                ),
                prefixStyle: AppTextStyle.s15w400,
                enabledBorder: borderStyle,
                focusedBorder: borderStyle.copyWith(
                  borderSide: const BorderSide(
                    width: 2,
                    color: AppColors.main,
                  ),
                ),
                errorBorder: borderStyle,
                disabledBorder: borderStyle,
              ),
            ),
            if (isPhone)
              const Positioned(
                top: 13.5,
                left: 22.0,
                child: Text(
                  '+7',
                  style: AppTextStyle.s15w400,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
