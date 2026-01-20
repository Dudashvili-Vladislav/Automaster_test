import 'package:auto_master/app/data/api_client.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:auto_master/app/domain/models/order_response_entity.dart';
import 'package:auto_master/app/ui/theme/app_colors.dart';
import 'package:auto_master/app/ui/theme/app_text_style.dart';
import 'package:auto_master/resources/resources.dart';

class RequestCard extends StatelessWidget {
  const RequestCard({
    Key? key,
    required this.onPressed,
    required this.model,
  }) : super(key: key);
  final VoidCallback onPressed;
  final OrderResponseEntity model;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(
        left: 18,
        right: 14,
        bottom: 21,
        top: 17,
      ),
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
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
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(100),
                child: CachedNetworkImage(
                  imageUrl: '${ApiClient.baseImageUrl}${model.avatarOfMaster}',
                  width: 62,
                  height: 62,
                  fit: BoxFit.cover,
                  errorWidget: (context, url, error) => Container(
                    width: 62,
                    height: 62,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: SvgPicture.asset(
                        Svgs.profile,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            model.nameOfMaster,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: AppTextStyle.s12w400.copyWith(
                              color: AppColors.main,
                            ),
                          ),
                        ),
                        const SizedBox(width: 30),
                        Flexible(
                          child: Text(
                            model.stoName,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: AppTextStyle.s12w700
                                .copyWith(color: AppColors.main),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Text(
                          'Рейтинг исполнителя:',
                          style: AppTextStyle.s12w400
                              .copyWith(color: AppColors.grey),
                        ),
                        const SizedBox(width: 5),
                        SvgPicture.asset(
                          Svgs.activeStar,
                          width: 14,
                          height: 14,
                        ),
                        const SizedBox(width: 5),
                        Text(
                          model.rating.toDouble().toStringAsFixed(1),
                          style: AppTextStyle.s12w400
                              .copyWith(color: AppColors.grey),
                        )
                      ],
                    ),
                  ],
                ),
              )
            ],
          ),
          const SizedBox(height: 28),
          Text(
            'Расстояние до ${model.stoName}',
            style: AppTextStyle.s12w400.copyWith(color: AppColors.grey),
          ),
          const SizedBox(height: 3),
          Text(
            '${model.km} км',
            style: AppTextStyle.s12w700.copyWith(color: AppColors.main),
          ),
          const SizedBox(height: 25),
          Text(
            'Полный адрес',
            style: AppTextStyle.s12w400.copyWith(color: AppColors.grey),
          ),
          const SizedBox(height: 3),
          Text(
            model.address,
            style: AppTextStyle.s12w700.copyWith(color: AppColors.main),
          ),
          const SizedBox(height: 30),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              SizedBox(
                height: 36,
                width: 100,
                child: CupertinoButton(
                  padding: EdgeInsets.zero,
                  color: AppColors.main,
                  borderRadius: BorderRadius.circular(60),
                  onPressed: onPressed,
                  child: Text(
                    'Информация',
                    style: AppTextStyle.s12w600.copyWith(color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
