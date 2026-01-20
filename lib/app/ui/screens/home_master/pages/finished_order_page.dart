// ignore_for_file: deprecated_member_use

import 'package:auto_master/app/data/api_client.dart';
import 'package:auto_master/resources/resources.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import 'package:auto_master/app/domain/models/master_order_entity.dart';
import 'package:auto_master/app/ui/theme/theme.dart';
import 'package:auto_master/app/ui/widgets/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';

class FinishedOrderPage extends StatelessWidget {
  const FinishedOrderPage({
    Key? key,
    required this.model,
  }) : super(key: key);

  final MasterOrderEntity model;

  @override
  Widget build(BuildContext context) {
    final date = model.dateTo == null
        ? '${model.dateFrom?.replaceAll('-', '.')},${model.time}'
        : '${model.dateFrom?.replaceAll('-', '.')} - ${model.dateTo?.replaceAll('-', '.')}, ${model.time?.substring(0, 5)}';
    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 15.0)
              .copyWith(bottom: 32.0, top: 36.0),
          physics: const RangeMaintainingScrollPhysics(),
          children: [
            Column(
              children: <Widget>[
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const CustomIconButton(),
                    Container(
                      width: 117.0,
                      height: 117.0,
                      clipBehavior: Clip.hardEdge,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                        boxShadow: model.customerAvatar != null
                            ? [
                                BoxShadow(
                                  blurRadius: 10.0,
                                  color: Colors.black.withOpacity(.3),
                                ),
                              ]
                            : null,
                      ),
                      child: model.customerAvatar != null
                          ? CachedNetworkImage(
                              imageUrl:
                                  '${ApiClient.baseImageUrl}${model.customerAvatar}',
                              width: 45,
                              height: 32,
                              fit: BoxFit.cover,
                              errorWidget: (context, url, error) => const Icon(
                                Icons.error,
                                color: AppColors.main,
                              ),
                            )
                          : SvgPicture.asset(
                              Svgs.profile,
                              width: 135.0,
                              height: 135.0,
                              color: AppColors.greyLight,
                            ),
                    ),
                    const SizedBox(width: 40.0),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 21.0),
                  child: Column(
                    children: <Widget>[
                      const SizedBox(height: 13.0),
                      Text(
                        model.customerName ?? '',
                        style: AppTextStyle.s15w700.copyWith(
                          color: AppColors.main,
                        ),
                      ),
                      const SizedBox(height: 50.0),
                      InfoCard(text: model.specialization),
                      InfoCard(text: model.carBrand),
                      InfoCard(text: model.carModel),
                      InfoCard(text: model.carNumber),
                      InfoCard(text: date),
                      InfoTextAreaCard(text: model.orderDescription ?? ''),
                      if (model.priceFromSelectedMaster != null)
                        Padding(
                          padding: const EdgeInsets.only(top: 30.0),
                          child: Center(
                            child: Text(
                              'Цена заказа:\n${model.priceFromSelectedMaster} рублей',
                              style: AppTextStyle.s20w700.copyWith(
                                color: AppColors.main,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class InfoCard extends StatelessWidget {
  const InfoCard({
    Key? key,
    this.text = '',
  }) : super(key: key);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 20.0),
      padding: const EdgeInsets.symmetric(
        vertical: 16.0,
        horizontal: 22.0,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [AppTheme.shadowBlur4],
        borderRadius: BorderRadius.circular(60.0),
      ),
      child: Text(
        text,
        style: AppTextStyle.s14w400.copyWith(
          color: Colors.black,
        ),
      ),
    );
  }
}

class InfoTextAreaCard extends StatelessWidget {
  const InfoTextAreaCard({
    Key? key,
    this.text = '',
  }) : super(key: key);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 20.0),
      padding: const EdgeInsets.symmetric(
        vertical: 25.0,
        horizontal: 22.0,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [AppTheme.shadowBlur4],
        borderRadius: BorderRadius.circular(25.0),
      ),
      child: Text(
        text,
        style: AppTextStyle.s14w400.copyWith(
          color: Colors.black,
          height: 2,
        ),
      ),
    );
  }
}
