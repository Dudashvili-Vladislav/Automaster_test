import 'dart:io';

import 'package:app_tracking_transparency/app_tracking_transparency.dart';
import 'package:auto_master/app/app.dart';
import 'package:auto_master/app/domain/states/master/master_orders_state.dart';
import 'package:auto_master/app/domain/states/master/master_profile_state.dart';
import 'package:auto_master/app/ui/routes/routes.dart';
import 'package:auto_master/app/ui/screens/chat/chat_screen.dart';
import 'package:auto_master/app/ui/widgets/widgets.dart';
import 'package:auto_master/main.dart';
import 'package:auto_master/resources/resources.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:routemaster/routemaster.dart';

Future<void> showAppTracking() async {
  if (Platform.isIOS) {
    if (await AppTrackingTransparency.trackingAuthorizationStatus ==
        TrackingStatus.notDetermined) {
      await AppTrackingTransparency.requestTrackingAuthorization();
    }
  }
}

class MasterTabbarScreen extends StatefulWidget {
  const MasterTabbarScreen({Key? key}) : super(key: key);

  @override
  State<MasterTabbarScreen> createState() => _MasterTabbarScreenState();
}

class _MasterTabbarScreenState extends State<MasterTabbarScreen> {
  final tabs = [
    AppRoutes.masterOrders,
    AppRoutes.masterChat,
    AppRoutes.masterProfile,
  ];

  int selectedIndex = 0;

  @override
  void initState() {
    super.initState();

    context.read<MasterOrdersState>().restartTimer();

    notifyService.masterProfileState = context.read<MasterProfileState>();
    context.read<MasterProfileState>().fetchProfile();

    contextToShowDialog = context;

    // if (!notifyService.isSubscribed) {
    //   notifyService.isSubscribed = true;
      notifyService.setOnTapListener(
        onCustomerOrders: () async {
          Fluttertoast.showToast(
            msg:
                'Вы авторизованы как мастер. Пожалуйста, авторизуйтесь как клиент, чтобы увидеть отклики на заказы.',
            toastLength: Toast.LENGTH_LONG,
          );
        },
        onMasterOrders: () async {
          chengeAvtiveIndex(0);
        },
        onMasterProfile: () async {
          chengeAvtiveIndex(2);
        },
      );
    // }
  }

  void chengeAvtiveIndex(int index) {
    if (index == 1) {
      routemaster.push(ChatScreen.routeName);
      // final read = context.read<MasterProfileState>();
      // Navigator.push(
      //   context,
      //   CupertinoPageRoute(
      //     builder: (context) => ChangeNotifierProvider.value(
      //       value: read,
      //       child: ChatScreen(),
      //     ),
      //   ),
      // );
      return;
    }

    HapticFeedback.lightImpact();
    if (index != selectedIndex) {
      routemaster.push(tabs[index]);
    } else {
      setState(() {});
    }
    selectedIndex = index;
  }

  @override
  Widget build(BuildContext context) {
    final pageState = TabPage.of(context);
    selectedIndex = pageState.index;
    final stack = pageState.stacks[selectedIndex];
    return Scaffold(
      body: AnimatedSwitcher(
        duration: kThemeAnimationDuration,
        child: PageStackNavigator(
          key: ValueKey(selectedIndex),
          stack: stack,
        ),
      ),
      bottomNavigationBar: Container(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).padding.bottom,
          top: 20,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              blurRadius: 4,
              color: Colors.black.withOpacity(.25),
            ),
          ],
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        width: double.infinity,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                BottomNavIcon(
                  isActive: selectedIndex == 0,
                  onPressed: () => chengeAvtiveIndex(
                    0,
                  ),
                  text: 'Заказы',
                  icon: Svgs.orders,
                ),
                BottomNavIcon(
                  isActive: selectedIndex == 1,
                  onPressed: () => chengeAvtiveIndex(
                    1,
                  ),
                  text: 'Чаты',
                  icon: Svgs.chat,
                ),
                BottomNavIcon(
                  isActive: selectedIndex == 2,
                  onPressed: () => chengeAvtiveIndex(
                    2,
                  ),
                  text: 'Профиль',
                  icon: Svgs.profile,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
