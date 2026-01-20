// ignore_for_file: use_build_context_synchronously

import 'dart:developer';

import 'package:auto_master/app/app.dart';
import 'package:auto_master/app/domain/states/register_state.dart';
import 'package:auto_master/app/domain/states/support_data_cubit.dart';

import 'package:auto_master/app/ui/routes/routes.dart';
import 'package:auto_master/app/ui/theme/app_colors.dart';
import 'package:auto_master/app/ui/theme/app_text_style.dart';
import 'package:auto_master/app/ui/utils/get_token.dart';
import 'package:auto_master/app/ui/utils/show_message.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';

import 'app_interceptor.dart';

class DioErrorHandler extends InterceptorsWrapper {
  final BuildContext context;
  final Dio dio;
  DioErrorHandler(
    this.context,
    this.dio,
  );

  @override
  Future<void> onError(DioError err, ErrorInterceptorHandler handler) async {
    // Refresh token if expired
    // if (err.response?.statusCode == 401) {
    //   // Re-request

    //   if (context.mounted &&
    //       context.read<AppState>().currentRoute != loggedOutMap &&
    //       err.requestOptions.path.startsWith('/mobil/')) {
    //     context.read<AppState>().onChangeRoute(loggedOutMap);
    //     return super.onError(err, handler);
    //   }
    // }
    if (err.response?.statusCode == 403) {
      final isGetCustomerModel =
          err.requestOptions.path.contains('get_customer_model');
      final isGetMasterInfo =
          err.requestOptions.path.contains('get_master_info');

      if (isGetCustomerModel || isGetMasterInfo) {
        showShizoBlockDialog(contextToShowDialog);
      }
      // context.read<AppState>().onLogOut();
    }

    if (err.response?.statusCode == 422) {
      showMessage(err.response?.data['error'] ??
          err.response?.data.toString() ??
          err.error + '${err.requestOptions.uri}');
      return super.onError(err, handler);
    }

    if (err is NotFoundException && (context.mounted)) {
      // context.read<AppState>().onLogout();
      return super.onError(err, handler);
    }

    if (err.response?.statusCode == 500) {
      final isGetCustomerModel =
          err.requestOptions.path.contains('get_customer_model');
      final isGetMasterInfo =
          err.requestOptions.path.contains('get_master_info');

      if (isGetCustomerModel || isGetMasterInfo) {
        context.read<AppState>().onLogOut();
        showMessage('Пользователь был удалён');
      }
    }

    if (err.response?.statusCode == 502) {
      showMessage('Сервер недоступен');
    }

    // Handle other Dio errors
    if (err.requestOptions.path != '/check_phone') {
      if (err.message.contains('SocketException: Failed host lookup')) {
        // print();
        // print('YES');
        showMessage('Отсутствует подключение к сети');
      } else {
        if (err.response?.data is String) {
          // showMessage(err.response?.data);
        }
        if (err.response?.data is Map<String, dynamic>) {
          // showMessage(err.response?.data?.toString() ?? '');
          // print(err.response?.data.keys);
          // final t = err.response?.data as Map<String, dynamic>;
          // final hasError = t.containsKey('error');
          // if (hasError) {
          //   final error = t['error'];
          //   print('error');
          //   print(error);
          // }
        }
      }
    }

    // Continue to propagate the error
    return super.onError(err, handler);
  }
}

bool isOpened = false;
showShizoBlockDialog(BuildContext? context) async {
  print('lol $isOpened');
  if (context == null) {
    return;
  }

  if (isOpened) {
    return;
  }

  isOpened = true;

  // Navigator.of(context).
  // showBottomSheet(
  //     context: context,
  //     builder: (context) {
  //       return Container(
  //         height: 100,
  //         width: 100,
  //         color: Colors.red,
  //       );
  //     });
  final token = await getToken(context);
  final res = await showDialog(
    barrierDismissible: false,
    useRootNavigator: true,
    context: context!,
    builder: (context) => AlertDialog(
      surfaceTintColor: Colors.white,
      // insetPadding: const EdgeInsets.symmetric(horizontal: 36.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(40.0),
      ),
      content: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 16.0,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(
                  'Ваш аккаунт заблокирован',
                  style: AppTextStyle.s15w700.copyWith(
                    color: AppColors.main,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: BlocBuilder<SupportDataCubit, SupportData>(
                    builder: (context, state) => Text(
                      'Ваш аккаунт заблокирован. Вы можете выйти из аккаунта или обратиться в службу поддержки: ${state.phone}',
                      textAlign: TextAlign.center,
                      style: AppTextStyle.s14w400.copyWith(
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      actions: [
        Row(
          // mainAxisSize: MainAxisSize.max,
          children: [
            Expanded(
              child: TextButton(
                style: TextButton.styleFrom(
                  foregroundColor: AppColors.main.withOpacity(.34),
                ),
                onPressed: token != null && token.isNotEmpty
                    ? () {
                        context.read<AppState>().onLogOut();
                        context.read<RegisterState>().clear();
                      }
                    : null,
                child: const Text(
                  'Выйти',
                  style: TextStyle(
                    fontSize: 14.0,
                    fontWeight: FontWeight.w500,
                    color: AppColors.main,
                  ),
                ),
              ),
            ),
            Expanded(
              child: BlocBuilder<SupportDataCubit, SupportData>(
                builder: (context, state) => TextButton(
                  style: TextButton.styleFrom(
                    foregroundColor: AppColors.main.withOpacity(.34),
                  ),
                  onPressed: state.phone.isEmpty
                      ? null
                      : () => launchTel(state.clearPhone),
                  child: const Text(
                    'Позвонить',
                    style: TextStyle(
                      fontSize: 14.0,
                      fontWeight: FontWeight.w500,
                      color: AppColors.main,
                    ),
                  ),
                ),
              ),
            ),
            // Flexible(
            //   child: CustomButton(
            //     text: 'Завершить',
            //     onPressed: () => Navigator.pop(context, true),
            //   ),
            // ),
          ],
        ),
      ],
    ),
  );

  isOpened = false;
}

launchTel(String phone) {
  final Uri phoneUrl = Uri(
    scheme: 'tel',
    path: '+$phone',
  );

  launchUrl(phoneUrl);
}

launchWA(String phone) {
  launchUrlString('whatsapp://send/?phone=${phone}');
}
