// ignore_for_file: use_build_context_synchronously

import 'package:auto_master/app/data/api_client.dart';
import 'package:auto_master/app/domain/states/master/master_orders_state.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import 'package:auto_master/app/domain/models/master_order_entity.dart';
import 'package:auto_master/app/ui/screens/home_master/pages/finished_order_page.dart';
import 'package:auto_master/app/ui/screens/home_master/pages/order_detail_page.dart';
import 'package:auto_master/app/ui/theme/theme.dart';
import 'package:provider/provider.dart';

import 'widgets.dart';

class OrderCard extends StatelessWidget {
  const OrderCard({
    Key? key,
    this.width = 327.0,
    this.isFinished = false,
    required this.model,
  }) : super(key: key);

  final double width;
  final bool isFinished;
  final MasterOrderEntity model;

  static const double height = 273;

  @override
  Widget build(BuildContext context) {
    final valid = model.responseStatus != 'response';
    return Container(
      width: width,
      height: height,
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.0),
        boxShadow: [AppTheme.shadowBlur4],
      ),
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                isFinished
                    ? 'Заказ выполнен'
                    : model.orderStatus == 'inProgress'
                        ? 'Заказ подтверждён'
                        : 'Вы получили заказ',
                style: AppTextStyle.s16w600.copyWith(
                  color: AppColors.main,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                  top: 23.0,
                  bottom: 20.0,
                ),
                child: Row(
                  children: <Widget>[
                    ClipRRect(
                      borderRadius: BorderRadius.circular(100),
                      child: CachedNetworkImage(
                        imageUrl:
                            '${ApiClient.baseImageUrl}${model.customerAvatar}',
                        width: 50,
                        height: 50,
                        fit: BoxFit.cover,
                        errorWidget: (context, url, error) => const Icon(
                          Icons.account_circle,
                          color: AppColors.greyLight,
                          size: 50.0,
                        ),
                      ),
                    ),
                    const SizedBox(width: 13.0),
                    Flexible(
                      child: Text(
                        model.customerName ?? '',
                        style: AppTextStyle.s12w400.copyWith(
                          color: AppColors.main,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 100.0,
                    ),
                  ],
                ),
              ),
              Text(
                'Марка и модель авто',
                style: AppTextStyle.s12w700.copyWith(
                  color: AppColors.grey,
                ),
              ),
              const SizedBox(height: 7.0),
              Text(
                '${model.carBrand} ${model.carModel}',
                style: AppTextStyle.s12w400.copyWith(
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 15.0),
              Text(
                'Гос. номер авто',
                style: AppTextStyle.s12w700.copyWith(
                  color: AppColors.grey,
                ),
              ),
              const SizedBox(height: 7.0),
              Text(
                model.carNumber,
                style: AppTextStyle.s12w400.copyWith(
                  color: Colors.black,
                ),
              ),
            ],
          ),
          Positioned(
            right: 0,
            top: 0,
            child: Container(
              width: 83.0,
              height: 83.0,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
                boxShadow: [AppTheme.shadowBlur4],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  CachedNetworkImage(
                    imageUrl:
                        '${ApiClient.baseImageUrl}${model.specializationAvatar}',
                    width: 45,
                    height: 32,
                    errorWidget: (context, url, error) => const Icon(
                      Icons.error,
                      color: AppColors.main,
                    ),
                  ),
                  const SizedBox(height: 4.0),
                  Text(
                    model.specialization,
                    style: AppTextStyle.s10w400.copyWith(
                      fontSize: 8.0,
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w600,
                      color: AppColors.grey,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            right: 0,
            bottom: 0,
            child: CustomButton(
              width: 165.0,
              height: 36.0,
              textStyle: AppTextStyle.s12w600.copyWith(
                color: Colors.white,
              ),
              text: isFinished || model.orderStatus == 'inProgress'
                  ? "Выбрать"
                  : valid
                      ? 'Информация о заказе'
                      : 'Ожидаем подтверждение',
              onPressed: () async {
                if (!isFinished && !valid && model.orderStatus == 'active') {
                  return;
                }

                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) =>
                        isFinished || model.orderStatus == 'inProgress'
                            ? FinishedOrderPage(model: model)
                            : ChangeNotifierProvider.value(
                                value: context.read<MasterOrdersState>(),
                                child: OrderDetailPage(model: model),
                              ),
                  ),
                );
                await context.read<MasterOrdersState>().fetchOrders();
              },
            ),
          ),
        ],
      ),
    );
  }
}
