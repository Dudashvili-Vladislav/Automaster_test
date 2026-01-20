import 'dart:developer';

import 'package:auto_master/app/domain/states/chat/chat_bloc.dart';
import 'package:auto_master/app/domain/states/customer/orders_state.dart';
import 'package:auto_master/app/domain/states/login_state.dart';
import 'package:auto_master/app/domain/states/master/master_orders_state.dart';
import 'package:auto_master/app/domain/states/master/master_profile_state.dart';
import 'package:auto_master/app/domain/states/register_state.dart';
import 'package:auto_master/app/domain/states/support_data_cubit.dart';
import 'package:auto_master/app/ui/routes/routes.dart';
import 'package:auto_master/app/ui/theme/theme.dart';
import 'package:auto_master/app/ui/widgets/my_behavior.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:routemaster/routemaster.dart';
import 'package:sizer/sizer.dart';

final routemaster = RoutemasterDelegate(
  routesBuilder: (context) {
    final appState = context.watch<AppState>();
    return appState.currentRoute;
  },
);

BuildContext? contextToShowDialog;

class AppState extends ChangeNotifier {
  RouteMap _currentRoute = loggedOutMap;

  RouteMap get currentRoute => _currentRoute;

  AppState() {
    checkToken();
  }

  void checkToken() {
    final box = Hive.box('settings');
    final token = box.get('token', defaultValue: null);
    final isClient = box.get('isClient', defaultValue: false);

    if (token == null) return;
    log(token);
    onChangeRoute(isClient ? loggedInClientMap : loggedInMasterMap);
  }

  void onChangeRoute(RouteMap route) {
    _currentRoute = route;

    notifyListeners();
  }

  void onLogOut() async {
    await Hive.box('settings').delete('token');

    onChangeRoute(loggedOutMap);
  }
}

final scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<ChatBloc>(create: (context) => ChatBloc()),
        BlocProvider<SupportDataCubit>(
          create: (context) => SupportDataCubit()..init(),
          lazy: false,
        ),
      ],
      child: Builder(
        builder: (context) {
          return ChangeNotifierProvider(
            create: (context) => AppState(),
            child: Builder(
              builder: (context) => MultiProvider(
                providers: [
                  ChangeNotifierProvider(
                    create: (context) => MasterProfileState(
                      context,
                      chatBloc: BlocProvider.of<ChatBloc>(context),
                    ),
                    // lazy: false,
                  ),
                  ChangeNotifierProvider(
                    lazy: false,
                    create: (context) => LoginState(context),
                  ),
                  ChangeNotifierProvider(
                    lazy: false,
                    create: (context) => RegisterState(context),
                  ),
                  ChangeNotifierProvider(
                    lazy: false,
                    create: (context) => MasterOrdersState(context),
                  ),
                  ChangeNotifierProvider(
                    create: (context) => CustomerOrdersState(context),
                  ),
                ],
                child: Sizer(
                  builder: (context, orientation, deviceType) =>
                      MaterialApp.router(
                    localizationsDelegates: const [
                      GlobalMaterialLocalizations.delegate,
                      GlobalWidgetsLocalizations.delegate,
                      GlobalCupertinoLocalizations.delegate,
                      DefaultMaterialLocalizations.delegate,
                      DefaultCupertinoLocalizations.delegate,
                    ],
                    supportedLocales: const [
                      Locale('ru'),
                    ],
                    theme: AppTheme.appTheme,
                    routerDelegate: routemaster,
                    routeInformationParser: const RoutemasterParser(),
                    debugShowCheckedModeBanner: false,
                    scaffoldMessengerKey: scaffoldMessengerKey,
                    builder: (context, child) {
                      // https://stackoverflow.com/a/58132007/15776812
                      return AnnotatedRegion<SystemUiOverlayStyle>(
                        // Use [SystemUiOverlayStyle.light] for white status bar
                        // or [SystemUiOverlayStyle.dark] for black status bar
                        // https://stackoverflow.com/a/58132007/1321917
                        value: SystemUiOverlayStyle.dark,
                        child: ScrollConfiguration(
                          behavior: MyBehavior(),
                          child: MediaQuery(
                            data: MediaQuery.of(context)
                                .copyWith(textScaleFactor: 1.0),
                            child: child!,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
