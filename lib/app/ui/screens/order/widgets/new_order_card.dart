import 'dart:io';

import 'package:auto_master/app/app.dart';
import 'package:auto_master/app/data/api_client.dart';
import 'package:auto_master/app/data/error_handler.dart';
import 'package:auto_master/app/domain/models/adress_location.dart';
import 'package:auto_master/app/domain/models/customer_order_entity.dart';
import 'package:auto_master/app/domain/service/customer_service.dart';
import 'package:auto_master/app/domain/service/is_payment_allowed.dart';
import 'package:auto_master/app/domain/states/customer/map_state.dart';
import 'package:auto_master/app/domain/states/customer/orders_state.dart';
import 'package:auto_master/app/ui/screens/order/pages/map_screen.dart';
import 'package:auto_master/app/ui/screens/order/pages/payment_page.dart';
import 'package:auto_master/app/ui/screens/order/pages/review_master_page.dart';
import 'package:auto_master/app/ui/screens/order/pages/your_request_page.dart';
import 'package:auto_master/app/ui/theme/theme.dart';
import 'package:auto_master/app/ui/utils/get_time_text.dart';
import 'package:auto_master/app/ui/widgets/custom_icon_button.dart';
import 'package:auto_master/resources/resources.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher_string.dart';

class NowOrderCard extends StatelessWidget {
  const NowOrderCard({
    Key? key,
    required this.model,
  }) : super(key: key);

  final CustomerOrderEntity model;

  static const double height = 475;

  @override
  Widget build(BuildContext context) {
    final read = context.read<CustomerOrdersState>();

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 15,
        vertical: 17,
      ),
      width: 300,
      height: height,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            blurRadius: 4,
            color: Colors.black.withOpacity(.25),
          )
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    model.orderStatus,
                    style: AppTextStyle.s16w600.copyWith(
                      color: AppColors.main,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    '${model.carBrand} ${model.carModel}',
                    style: AppTextStyle.s14w500.copyWith(
                      color: AppColors.black,
                    ),
                  ),
                ],
              ),
              Container(
                width: 83,
                height: 83,
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      blurRadius: 4,
                      color: Colors.black.withOpacity(.25),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CachedNetworkImage(
                      imageUrl:
                          '${ApiClient.baseImageUrl}${model.specializationAvatar}',
                      width: 58,
                      height: 33,
                    ),
                    Text(
                      model.specialization,
                      style: AppTextStyle.s12w600.copyWith(
                        fontFamily: 'Montserrat',
                        fontSize: 8,
                        color: AppColors.grey,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Text(
            'Дата и время заявки',
            style: AppTextStyle.s12w700.copyWith(
              color: AppColors.grey,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '${getTimeText(model.time)}, ${getDate(dateFrom: model.dateFrom, dateTo: model.dateTo)}',
            style: AppTextStyle.s12w400.copyWith(color: Colors.black),
          ),
          const SizedBox(height: 16),
          MasterInfo(model),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // const SizedBox(height: 16),
                    Text(
                      'Описание заявки',
                      style: AppTextStyle.s12w700.copyWith(
                        color: AppColors.grey,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Flexible(
                      child: Text(
                        model.orderDescription,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyle.s12w400.copyWith(
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              if (model.orderStatus == 'Поиск Мастера')
                SizedBox(
                  height: 85,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const SizedBox(
                        height: 26,
                        width: 26,
                        child: Center(
                          child: CircularProgressIndicator(
                            strokeWidth: 3,
                            valueColor: AlwaysStoppedAnimation(
                              AppColors.main,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Идет поиск\nспециалистов\nвсего (${model.responsesCount ?? 0}) откликов',
                        style: AppTextStyle.s10w400.copyWith(
                          color: AppColors.main,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                )
              else
                const SizedBox(height: 81.0),
            ],
          ),
          const Spacer(),
          // const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            height: 36,
            child: CupertinoButton(
              padding: EdgeInsets.zero,
              color: AppColors.main,
              borderRadius: BorderRadius.circular(60),
              onPressed: model.responsesCount == 0
                  ? null
                  : () async {
                      if (model.orderStatus.toLowerCase() ==
                          'заказ выполняется') {
                        final ToAddress toAddress =
                            ToAddress(model.selectedMasterAddress!);
                        Navigator.of(context, rootNavigator: true).push(
                          CupertinoDialogRoute(
                            builder: (context) => ChangeNotifierProvider(
                              create: (context) => MapState(
                                context,
                                toAddress,
                              ),
                              child: MapScreen(
                                address: model.selectedMasterAddress ?? '',
                                masterAvatar: model.selectedMasterAvatar ?? '',
                                masterName: model.selectedMasterName ?? '',
                                masterId: model.selectedMasterId!,
                                orderId: model.id,
                                toAddress: toAddress,
                                stoName: model.selectedMasterStoName ?? '',
                              ),
                            ),
                            context: context,
                          ),
                        );
                      } else {
                        final extraStatus =
                            await CustomerService.extraStatus(context);
                        print('extraStatus: $extraStatus');

                        final isIos = Platform.isIOS;
                        final isAllowed =
                            isIos ? await isPaymentAllowed() : true;

                        print('isAllowed: $isAllowed');
                        print('model.paymentStatus: ${model.paymentStatus}');

                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) {
                              if (model.paymentStatus != 'paid' &&
                                  extraStatus &&
                                  isAllowed) {
                                return PaymentPage(orderId: model.id);
                              } else {
                                return YourRequestPage(orderId: model.id);
                              }
                            },
                          ),
                        );
                      }
                    },
              child: Text(
                model.orderStatus.toLowerCase() == 'заказ выполняется'
                    ? 'Маршрут в приложении'
                    : 'Показать результаты поиска',
                style: AppTextStyle.s12w600.copyWith(
                  color: Colors.white,
                ),
              ),
            ),
          ),
          if (model.orderStatus.toLowerCase() == 'заказ выполняется')
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: SizedBox(
                width: double.infinity,
                height: 36,
                child: CupertinoButton(
                  padding: EdgeInsets.zero,
                  color: AppColors.main,
                  borderRadius: BorderRadius.circular(60),
                  onPressed: () async {
                    final ToAddress toAddress =
                        ToAddress(model.selectedMasterAddress!);
                    final point = await MapState.getPointByText(toAddress);
                    if (point == null) {
                      Fluttertoast.showToast(
                          msg: 'Не удалось найти местоположение мастера');
                      return;
                    }
                    // final current = await MapState.getCurrentLocation();
                    final toLat = point.latitude;
                    final toLon = point.longitude;

                    print('YES1');
                    // final toLat = 0.0;
                    // final toLon = 0.0;
                    try {
                      final res = await launchUrlString(
                          'yandexnavi://build_route_on_map?lat_to=$toLat&lon_to=$toLon');
                      if (!res) {
                        throw 'yandex navigator is not installed';
                      }
                      // print('YES2');
                    } on Object catch (e) {
                      // print('YES3');
                      print('\n\n\n\nyandex navigator is not installed');
                      try {
                        final res = await launchUrlString(
                            'yandexmaps://maps.yandex.ru/?ll=$toLon,$toLat&z=13&pt=$toLon,$toLat');
                        if (!res) {
                          throw 'yandex maps is not installed';
                        }
                      } on Object catch (e) {
                        try {
                          print('\n\n\n\nyandex maps is not installed');
                          final res = await launchUrlString(
                              'dgis://2gis.ru/routeSearch/rsType/car/to/$toLon,$toLat');
                          if (!res) {
                            throw '2gis is not installed';
                          }
                        } on Object catch (e) {
                          launchUrlString(
                              'https://yandex.ru/maps/?rtext=~$toLon,$toLat');

                          print('Никаких карт не установлено');
                        }
                      }
                    }
                  },
                  child: Text(
                    'Маршрут на карте',
                    style: AppTextStyle.s12w600.copyWith(
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          const SizedBox(height: 8),
          CupertinoButton(
            padding: EdgeInsets.zero,
            // onPressed: () => routemaster.push(AppRoutes.clientReviewOrder),
            onPressed: () async {
              final res = (await closeOrderDialog(context));
              print('CLOSED ORDER DIALOG $res ${model.selectedMasterId}');
              if (res != null && res) {
                if (model.selectedMasterId != null) {
                  reviewMasterUIData = ReviewMasterUIData(
                    masterAvatar: model.selectedMasterAvatar ?? '',
                    masterId: model.selectedMasterId!,
                    orderId: model.id,
                    masterName: model.selectedMasterName ?? '',
                    address: model.selectedMasterAddress ?? '',
                    phone: model.selectedMasterPhone ?? '',
                  );
                  routemaster.push(ReviewMasterPage.routeName);
                  print('PUSH to ${ReviewMasterPage.routeName}');
                } else {
                  read.completeOrder(model.id);
                }
              }
            },
            child: Container(
              height: 36,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(60),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    blurRadius: 4,
                    color: Colors.black.withOpacity(.25),
                  ),
                ],
              ),
              child: Center(
                child: Text(
                  'Завершить заказ',
                  style: AppTextStyle.s12w600.copyWith(
                    color: Colors.black,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class MasterInfo extends StatelessWidget {
  const MasterInfo(this.model, {super.key});

  final CustomerOrderEntity model;

  @override
  Widget build(BuildContext context) {
    if (model.selectedMasterPhone != null) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Мастер',
            style: AppTextStyle.s12w700.copyWith(
              color: AppColors.grey,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            model.selectedMasterName ?? '',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyle.s12w400.copyWith(
              color: Colors.black,
            ),
          ),
          SizedBox(
            height: 20,
            child: CupertinoButton(
              padding: EdgeInsets.zero,
              onPressed: () =>
                  launchTel(phoneToJustDigits(model.selectedMasterPhone!)),
              child: Text(
                model.selectedMasterPhone!,
                style: AppTextStyle.s12w400.copyWith(
                  color: AppColors.main,
                ),
              ),
            ),
          ),

          // Text(

          //   maxLines: 1,
          //   overflow: TextOverflow.ellipsis,
          //   style: AppTextStyle.s12w400.copyWith(
          //     color: Colors.black,
          //   ),
          // ),
        ],
      );
    } else {
      return const SizedBox();
    }
  }
}

Future<dynamic> closeOrderDialog(BuildContext outerContext) {
  return universalDialog(
    outerContext: outerContext,
    title: 'Завершение заказа',
    confirmText: 'Завершить',
    cancelText: 'Отмена',
    content: 'Вы действительно хотите завершить заказ?',
  );
}

Future<dynamic> universalDialog(
    {required BuildContext outerContext,
    required String title,
    required String content,
    required String confirmText,
    required String cancelText}) {
  return showDialog(
    context: outerContext,
    builder: (context) => AlertDialog(
      iconPadding: EdgeInsets.zero,
      // insetPadding: EdgeInsets.zero,
      // contentPadding: EdgeInsets.zero,
      // titlePadding: EdgeInsets.zero,
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
                  title,
                  style: AppTextStyle.s15w700.copyWith(
                    color: AppColors.main,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: Text(
                    content,
                    textAlign: TextAlign.center,
                    style: AppTextStyle.s14w400.copyWith(
                      color: Colors.black,
                    ),
                  ),
                ),
                // Image.asset(
                //   Images.logo,
                //   width: 117.0,
                //   height: 100.0,
                // ),

                // const SizedBox(height: 24.0),
                // CustomButton(
                //   text: 'Готово',
                //   onPressed: () => Navigator.pop(context, price),
                // ),
              ],
            ),
          ),
          const Positioned(
            right: 0,
            top: 0,
            child: CustomIconButton(
              icon: Svgs.close,
              size: Size(24.0, 24.0),
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
                onPressed: () => Navigator.pop(context, false),
                child: Text(
                  cancelText,
                  style: const TextStyle(
                    fontSize: 14.0,
                    fontWeight: FontWeight.w500,
                    color: AppColors.main,
                  ),
                ),
              ),
            ),
            Expanded(
              child: TextButton(
                style: TextButton.styleFrom(
                  foregroundColor: AppColors.main.withOpacity(.34),
                ),
                onPressed: () => Navigator.pop(context, true),
                child: Text(
                  confirmText,
                  style: const TextStyle(
                    fontSize: 14.0,
                    fontWeight: FontWeight.w500,
                    color: AppColors.main,
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    ),
  );
}

String phoneToJustDigits(String phone) {
  return phone.replaceAll(RegExp(r'[^0-9]'), '');
}
