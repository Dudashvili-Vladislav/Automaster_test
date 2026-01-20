import 'dart:convert';
import 'dart:developer';

import 'package:auto_master/app/app.dart';
import 'package:auto_master/app/domain/service/local_notify_service.dart';
import 'package:auto_master/app/domain/states/customer/orders_state.dart';
import 'package:auto_master/app/ui/routes/routes.dart';
import 'package:auto_master/app/ui/widgets/widgets.dart';
import 'package:auto_master/main.dart';
import 'package:auto_master/resources/resources.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:routemaster/routemaster.dart';

class TabbarScreen extends StatefulWidget {
  const TabbarScreen({Key? key}) : super(key: key);

  @override
  State<TabbarScreen> createState() => _TabbarScreenState();
}

class _TabbarScreenState extends State<TabbarScreen> {
  final tabs = [
    AppRoutes.home,
    AppRoutes.clientOrders,
    AppRoutes.clientProfile,
  ];

  int selectedIndex = 0;

  @override
  void initState() {
    print('TabbarScreen');
    super.initState();
    Future.microtask(
      () async => await localNotifyService.init(
        context,
        context.read<CustomerOrdersState>(),
      ),
    );
    notifyService.masterProfileState = null;
    context.read<CustomerOrdersState>().restartTimer();

    contextToShowDialog = context;

    // if (!notifyService.isSubscribed) {
    //   notifyService.isSubscribed = true;
    notifyService.setOnTapListener(
      onCustomerOrders: () async {
        chengeAvtiveIndex(1);
      },
      onMasterOrders: () async {
        Fluttertoast.showToast(
          msg:
              'Вы авторизованы как клиент. Пожалуйста, авторизуйтесь как мастер, чтобы увидеть отклики на заказы.',
          toastLength: Toast.LENGTH_LONG,
        );
      },
      onMasterProfile: () async {
        Fluttertoast.showToast(
          msg:
              'Вы авторизованы как клиент. Пожалуйста, авторизуйтесь как мастер, чтобы перейти к профилю мастера.',
          toastLength: Toast.LENGTH_LONG,
        );
      },
    );
    // }
  }

  void chengeAvtiveIndex(int index) {
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
    final stack = pageState.stacks[selectedIndex];
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final str = (prefs.getString('notif')) ?? '';
      // Fluttertoast.showToast(msg: str);
      if (str.isNotEmpty) {
        try {
          final value = context.read<CustomerOrdersState>();
          LocalNotifyService.push(context, value, jsonDecode(str));
        } on Object catch (e) {
          // Fluttertoast.showToast(msg: e.toString());
          print(e);
          log(e.toString());
        }
      }
    });
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
                  text: 'Главная',
                  icon: Svgs.home,
                ),
                BottomNavIcon(
                  isActive: selectedIndex == 1,
                  onPressed: () => chengeAvtiveIndex(
                    1,
                  ),
                  text: 'Заказы',
                  icon: Svgs.orders,
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
