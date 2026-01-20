import 'package:auto_master/app/app.dart';
import 'package:auto_master/app/domain/service/local_notify_service.dart';
import 'package:auto_master/app/domain/states/chat/chat_bloc.dart';
import 'package:auto_master/app/ui/theme/app_colors.dart';
import 'package:auto_master/app/ui/widgets/camera_page.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io' show Platform;

import 'app/domain/service/notify_service.dart';

final notifyService = OneSignalService();
final localNotifyService = LocalNotifyService();

late final SharedPreferences prefs;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (!kIsWeb && (Platform.isAndroid || Platform.isIOS)) {
    cameras = await availableCameras();
  } else {
    cameras = <CameraDescription>[];
  }
  prefs = await SharedPreferences.getInstance();
  await Hive.initFlutter();
  await Hive.openBox('settings');
  await notifyService.init();
  cachePathProvider.init();
  initializeDateFormatting('ru_RU');

  await localNotifyService.notify.initialize(
    // set the icon to null if you want to use the default app icon
    'resource://drawable/ic_launcher',
    [
      NotificationChannel(
        channelGroupKey: 'basic_channel_group',
        channelKey: 'basic_channel',
        channelName: 'Basic notifications',
        channelDescription: 'Notification channel for basic tests',
        defaultColor: AppColors.main,
        ledColor: Colors.white,
      )
    ],
    // Channel groups are only visual and are not required
    channelGroups: [
      NotificationChannelGroup(
        channelGroupName: 'Basic group',
        channelGroupKey: 'basic_channel_group',
      )
    ],
    debug: kDebugMode,
  );

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarBrightness: Brightness.light,
    statusBarIconBrightness: Brightness.dark,
    statusBarColor: Colors.transparent,
  ));
  runApp(const App());
}
