import 'dart:developer';

import 'package:auto_master/app/app.dart';
import 'package:auto_master/app/ui/theme/theme.dart';
import 'package:flutter/material.dart';

void showMessage(
  String text, {
  bool isError = true,
  // EdgeInsetsGeometry? margin,
}) {
  log("${isError ? "ERROR" : "INFO"}: $text");

  final snackbar = SnackBar(
    behavior: SnackBarBehavior.floating,
    padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 15),
    margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(6),
    ),
    backgroundColor: isError ? const Color(0xFFEB1C0F) : AppColors.yellow,
    content: Text(
      text,
      style: const TextStyle(
        color: Colors.white,
        fontSize: 15,
        fontWeight: FontWeight.w500,
      ),
    ),
  );

  scaffoldMessengerKey.currentState
    ?..removeCurrentSnackBar()
    ..showSnackBar(snackbar);
}
