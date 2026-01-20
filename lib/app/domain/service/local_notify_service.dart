// ignore_for_file: use_build_context_synchronously

import 'dart:convert';

import 'package:auto_master/app/app.dart';
import 'package:auto_master/app/domain/states/customer/orders_state.dart';
import 'package:auto_master/app/ui/screens/order/pages/review_master_page.dart';
import 'package:auto_master/app/ui/screens/order/pages/review_now_master_page.dart';
import 'package:auto_master/main.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalNotifyService {
  final AwesomeNotifications notify = AwesomeNotifications();

  void Function(ReceivedAction)? _onData;

  // THIS LISTENER IS INITIALIZED ONLY FOR CLIENT
  Future<void> init(BuildContext context, CustomerOrdersState value) async {
    // listenRecevedAction(context);
    _onData = (ReceivedAction event) {
      print('LISTEN RECIEVED ACTION');
      print('body: ${event.body} payload: ${event.payload}');
      final data = event.payload;
      if (data == null) return;
      push(context, value, data);
    };

    notify.setListeners(onActionReceivedMethod: onActionReceivedMethod);
  }

  static push(BuildContext context, CustomerOrdersState value, Map data) {
    print('PUSH TO ${ReviewNowMasterPage.routeName}');
    prefs.setString('notif', '');

    reviewMasterUIData = ReviewMasterUIData(
      masterAvatar: data['avatar'] ?? '',
      masterName: data['name'] ?? '',
      address: data['address'] ?? '',
      phone: data['phone'] ?? '',
      orderId: int.parse(data['orderId']!),
      masterId: int.parse(data['masterId']!),
    );
    routemaster.push(ReviewNowMasterPage.routeName);
  }

  Future<void> scheduleNotification(
    String name,
    String avatar,
    String address,
    String phone,
    int orderId,
    int masterId,
    DateTime date,
  ) async {
    final data = {
      'orderId': orderId.toString(),
      'masterId': masterId.toString(),
      "avatar": avatar,
      "name": name,
      "address": address,
      "phone": phone,
    };
    // prefs.setString('notif', jsonEncode(data));

    final res = await notify.createNotification(
      schedule: NotificationCalendar.fromDate(date: date),
      content: NotificationContent(
        id: DateTime.now().second,
        channelKey: 'basic_channel',
        title: 'Оцените работу',
        body: 'Оцените работу мастера ',
        payload: data,
        displayOnBackground: true,
        displayOnForeground: true,
      ),
    );

    print('scheduleNotification $res');
  }

  // void listenRecevedAction() {

  // }
}

Future<void> onActionReceivedMethod(ReceivedAction action) async {
  print('listenRecevedAction ${localNotifyService._onData}');
  localNotifyService._onData?.call(action);
}
