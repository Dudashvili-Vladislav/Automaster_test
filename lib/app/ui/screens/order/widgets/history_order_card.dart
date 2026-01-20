import 'package:auto_master/app/data/api_client.dart';
import 'package:auto_master/app/domain/models/customer_order_entity.dart';
import 'package:auto_master/app/ui/theme/theme.dart';
import 'package:auto_master/app/ui/utils/get_time_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class HistoryOrderCard extends StatelessWidget {
  const HistoryOrderCard({
    Key? key,
    required this.model,
  }) : super(key: key);
  final CustomerOrderEntity model;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 17)
          .copyWith(bottom: 25),
      width: 300,
      height: 285,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            blurRadius: 4,
            color: Colors.black.withOpacity(.25),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    model.orderStatus,
                    style: AppTextStyle.s16w600.copyWith(
                      color: AppColors.main,
                    ),
                  ),
                  const SizedBox(height: 13),
                  Text(
                    model.carModel,
                    style: AppTextStyle.s14w500.copyWith(
                      color: Colors.black,
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
                  boxShadow: [AppTheme.shadowBlur4],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
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
          const SizedBox(height: 7),
          Text(
            '${getTimeText(model.time)}, ${getDate(dateFrom: model.dateFrom, dateTo: model.dateTo)}',
            style: AppTextStyle.s12w400.copyWith(color: Colors.black),
          ),
          const SizedBox(height: 23),
          Text(
            'Описание заявки',
            style: AppTextStyle.s12w700.copyWith(
              color: AppColors.grey,
            ),
          ),
          const SizedBox(height: 7),
          Text(
            model.orderDescription,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyle.s12w400.copyWith(
              color: Colors.black,
            ),
          )
        ],
      ),
    );
  }
}
