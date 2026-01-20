import 'dart:developer';

import 'package:auto_master/app/app.dart';
import 'package:auto_master/app/domain/states/master/master_profile_state.dart';
import 'package:auto_master/app/ui/routes/routes.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

class OneSignalService {
  static OneSignal? _instance;

  bool isSubscribed = false;

  OneSignalService() {
    getInstance();
  }

  MasterProfileState? masterProfileState;

  Future<void> init() async {
    _instance!.setLogLevel(OSLogLevel.verbose, OSLogLevel.none);

    // OneSignal.shared
    //     .setNotificationOpenedHandler((OSNotificationOpenedResult result) {
    //   log('NOTIFICATION OPENED HANDLER CALLED WITH: ${result}');
    //   log("Opened notification: \n${result.notification.jsonRepresentation().replaceAll("\\n", "\n")}");
    // });

    // OneSignal.shared.setNotificationWillShowInForegroundHandler(
    //     (OSNotificationReceivedEvent event) {
    //   print('FOREGROUND HANDLER CALLED WITH: ${event}');

    //   /// Display Notification, send null to not display
    //   event.complete(null);

    //   print(
    //       "Notification received in foreground notification: \n${event.notification.jsonRepresentation().replaceAll("\\n", "\n")}");
    // });

    OneSignal.shared
        .setInAppMessageClickedHandler((OSInAppMessageAction action) {
      print(
          "In App Message Clicked: \n${action.jsonRepresentation().replaceAll("\\n", "\n")}");
    });

    OneSignal.shared
        .setSubscriptionObserver((OSSubscriptionStateChanges changes) {
      print("SUBSCRIPTION STATE CHANGED: ${changes.jsonRepresentation()}");
    });

    OneSignal.shared.setPermissionObserver((OSPermissionStateChanges changes) {
      print("PERMISSION STATE CHANGED: ${changes.jsonRepresentation()}");
    });

    OneSignal.shared.disablePush(false);

    // OneSignal.shared.setEmailSubscriptionObserver(
    //     (OSEmailSubscriptionStateChanges changes) {
    //   print("EMAIL SUBSCRIPTION STATE CHANGED ${changes.jsonRepresentation()}");
    // });

    // OneSignal.shared
    //     .setSMSSubscriptionObserver((OSSMSSubscriptionStateChanges changes) {
    //   print("SMS SUBSCRIPTION STATE CHANGED ${changes.jsonRepresentation()}");
    // });

    // OneSignal.shared.setOnWillDisplayInAppMessageHandler((message) {
    //   print("ON WILL DISPLAY IN APP MESSAGE ${message.messageId}");
    // });

    // OneSignal.shared.setOnDidDisplayInAppMessageHandler((message) {
    //   print("ON DID DISPLAY IN APP MESSAGE ${message.messageId}");
    // });

    // OneSignal.shared.setOnWillDismissInAppMessageHandler((message) {
    //   print("ON WILL DISMISS IN APP MESSAGE ${message.messageId}");
    // });

    // OneSignal.shared.setOnDidDismissInAppMessageHandler((message) {
    //   print("ON DID DISMISS IN APP MESSAGE ${message.messageId}");
    // });

    _instance!.setAppId("785654f9-dd66-41b2-887a-1b46ae8cdb5b");

    _instance!.promptUserForPushNotificationPermission().then((accepted) {
      log("Accepted permission: $accepted");
    });

    // Handle notifications received in foreground
    _instance!.setNotificationWillShowInForegroundHandler(
        (OSNotificationReceivedEvent event) {
      // _openRelatedPage(event.notification.additionalData);
      print('Notification ${event.notification.additionalData}');
      print(
          "Notification received in foreground notification: \n${event.notification.jsonRepresentation().replaceAll("\\n", "\n")}");
      event.complete(event.notification);

      masterProfileState?.fetchProfile();
    });

    // Handle notifications when opened

    // Future.microtask(() async {
    //   await saveToken(context);
    // });
  }

  void setOnTapListener({
    required final Future<void> Function() onCustomerOrders,
    required final Future<void> Function() onMasterOrders,
    required final Future<void> Function() onMasterProfile,
  }) {
    _instance!
        .setNotificationOpenedHandler((OSNotificationOpenedResult result) {
      // Navigate to the desired page when a notification is opened
      log('on notification click');
      log(result.notification.title.toString());
      log(result.notification.body.toString());
      log(result.notification.additionalData.toString());
      // log(result.notification.jsonRepresentation().toString());

      log('type_push: ' + result.notification.additionalData!['type_push']);

      switch (result.notification.additionalData!['type_push']) {
        case 'master_orders':
          // routemaster.push(AppRoutes.masterOrders);
          onMasterOrders();
          break;
        case 'master_profile':
          onMasterProfile();
          // routemaster.push(AppRoutes.masterProfile);
          break;
        case 'customer_orders':
          onCustomerOrders();
          // routemaster.push(AppRoutes.clientOrders);
          break;
      }
      //  Fluttertoast.showToast(
      //     msg:
      //         'Вы авторизованы как клиент. Пожалуйста, авторизуйтесь как мастер, чтобы увидеть отклики на заказы.',
      //     toastLength: Toast.LENGTH_LONG,
      //   );
    });
  }

  OneSignal? getInstance() {
    _instance ??= OneSignal.shared;
    return _instance;
  }

  Future<String?> getUserTokenId() async {
    final deviceState = await _instance!.getDeviceState();
    if (deviceState != null || deviceState?.userId != null) {
      String? tokenId = deviceState?.userId;
      log("------------------------TOKEN ID: $tokenId");

      return tokenId;
    }
    return null;
  }

  // Future<void> setNotification(int orderId) async {
  //   final data = {
  //     "include_player_ids": ["02b0f2e6-bcaa-4c81-a1ca-31ee80a28ec0"],
  //     "app_id": "785654f9-dd66-41b2-887a-1b46ae8cdb5b",
  //     "headings": {"en": "title\nsasasa", "ru": "титле"},
  //     "contents": {"en": "title", "ru": "Отправляю из постман"},
  //     "data": {
  //       "type": "rating_reminder",
  //       "orderId": orderId,
  //     }
  //   };

  //   try {
  //     await Dio().post(
  //       'https://onesignal.com/api/v1/notifications',
  //       data: data,
  //       options: Options(
  //         headers: {
  //           "Authorization":
  //               'Bearer NGJkMzg0NjQtOTJiOS00Yjg3LWFhZjctOGNkODE2NThhMmE0'
  //         },
  //       ),
  //     );
  //   } catch (e) {
  //     debugPrint('$e');
  //   }
  // }
}
