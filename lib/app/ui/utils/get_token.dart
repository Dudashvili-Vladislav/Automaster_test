// ignore_for_file: use_build_context_synchronously

import 'package:auto_master/app/app.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';

Future<String?> getToken(BuildContext? context) async {
  final token = await Hive.box('settings').get('token', defaultValue: null);
  if (token == null || token == '') {
    if (context != null) context.read<AppState>().onLogOut();
    return null;
  }
  return token;
}
