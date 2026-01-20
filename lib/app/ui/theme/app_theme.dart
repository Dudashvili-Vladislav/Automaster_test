import 'package:flutter/material.dart';

abstract class AppTheme {
  static final shadowBlur4 = BoxShadow(
    blurRadius: 4.0,
    color: Colors.black.withOpacity(.25),
  );

  static final appTheme = ThemeData(
    fontFamily: 'Barlow',
    scaffoldBackgroundColor: Colors.white,
    dialogTheme: const DialogThemeData(
      surfaceTintColor: Colors.white,
      backgroundColor: Colors.white,
    ),
  );
}
