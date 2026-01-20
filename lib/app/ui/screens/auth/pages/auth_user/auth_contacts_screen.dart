import 'package:auto_master/app/data/error_handler.dart';
import 'package:auto_master/app/domain/states/support_data_cubit.dart';
import 'package:auto_master/app/ui/theme/app_colors.dart';
import 'package:flutter/material.dart';

import 'package:auto_master/app/constatns.dart';
import 'package:auto_master/app/domain/models/support_entity.dart';
import 'package:auto_master/app/domain/service/auth_service.dart';
import 'package:auto_master/app/ui/theme/app_text_style.dart';
import 'package:auto_master/app/ui/utils/show_message.dart';
import 'package:auto_master/app/ui/widgets/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher_string.dart';

class AuthContactsScreen extends StatefulWidget {
  const AuthContactsScreen({
    Key? key,
    this.isAuth = true,
  }) : super(key: key);
  final bool isAuth;

  static const authParam = 'isAuth';
  static const routeNameShort = '/auth-contacts';
  static const routeNameFull = '$routeNameShort/:$authParam';

  @override
  State<AuthContactsScreen> createState() => _AuthContactsScreenState();
}

class _AuthContactsScreenState extends State<AuthContactsScreen> {
  bool isLoading = false;
  SupportEntity? data;

  Future<void> fetchSupportData() async {
    isLoading = true;
    setState(() {});

    data = await AuthService.getSupportData(context);

    if (data == null) {
      if (!mounted) return;
      Navigator.pop(context);
      showMessage('Ошибка попробуйте поэже');
    }

    isLoading = false;
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    Future.microtask(fetchSupportData);
  }

  Future<bool> _onWillPop() async {
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading
          ? const Loading()
          : SafeArea(
              child: SizedBox(
                width: double.infinity,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CustomAppBar(
                        title:
                            widget.isAuth ? 'Наши контакты' : 'Горячая линия'),
                    const SizedBox(height: 22),
                    Text(
                      'На данной странице\nвы можете связаться с нами\nпо телефону',
                      style: AppTextStyle.s14w400.copyWith(color: Colors.black),
                      textAlign: TextAlign.center,
                    ),
                    const Spacer(),
                    // CustomButton(
                    //   hasIcon: true,
                    //   width: 227,
                    //   height: 47,
                    //   text: 'Написать нам',
                    //   onPressed: () {
                    //     try {
                    //       launchUrlString(data!.whatsApp);
                    //     } catch (e) {
                    //       debugPrint('$e');
                    //     }
                    //   },
                    // ),
                    // const SizedBox(height: 40),
                    BlocBuilder<SupportDataCubit, SupportData>(
                      builder: (context, state) => CustomButton(
                        width: 227,
                        height: 47,
                        text: 'Позвонить нам',
                        onPressed: state.phone.isEmpty
                            ? null
                            : () {
                                try {
                                  launchTel(state.clearPhone);
                                } catch (e) {
                                  debugPrint('$e');
                                }
                              },
                      ),
                    ),
                    const Spacer(flex: 2),
                  ],
                ),
              ),
            ),
    );
  }
}
