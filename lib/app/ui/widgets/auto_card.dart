import 'package:auto_master/app/domain/states/customer/profile_state.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import 'package:auto_master/app/domain/models/customer_car.dart';
import 'package:auto_master/app/ui/screens/profile/pages/add_avto_form_page.dart';
import 'package:auto_master/app/ui/theme/theme.dart';

class AutoCard extends StatelessWidget {
  const AutoCard({
    Key? key,
    required this.name,
    required this.type,
    required this.image,
    required this.isChoose,
    required this.model,
  }) : super(key: key);

  final String name;
  final String type;
  final String? image;
  final bool isChoose;
  final CustomerCarEntity model;

  factory AutoCard.fromModel(CustomerCarEntity model, String? image,
      {bool isChoose = false}) {
    // final index =
    //     model.bodyType == null ? 0 : cartTypeBodyNames.indexOf(model.bodyType!);

    return AutoCard(
      name: model.model,
      type: model.bodyType ?? '',
      image: image,
      model: model,
      isChoose: isChoose,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      width: SizerUtil.width * .78,
      // height: 264,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            blurRadius: 4,
            color: AppColors.black.withOpacity(
              .25,
            ),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            name,
            style: AppTextStyle.s16w600.copyWith(
              color: AppColors.black,
            ),
          ),
          const SizedBox(height: 0),
          Text(
            type,
            style: AppTextStyle.s12w500.copyWith(
              color: AppColors.grey,
            ),
          ),
          const SizedBox(height: 8),
          Align(
            alignment: Alignment.center,
            child: CachedNetworkImage(
              imageUrl: image ?? '',
              height: 119.0,
              fit: BoxFit.contain,
              errorWidget: (context, url, error) =>
                  const SizedBox(height: 120.0),
              placeholder: (context, url) => const SizedBox(height: 120.0),
              // width: double.infinity,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              SizedBox(
                height: 36,
                width: 100,
                child: CupertinoButton(
                  color: AppColors.main,
                  borderRadius: BorderRadius.circular(60),
                  padding: EdgeInsets.zero,
                  child: Text(
                    isChoose ? 'Выбрать' : 'Редактировать',
                    style: AppTextStyle.s12w600.copyWith(color: Colors.white),
                  ),
                  onPressed: () {
                    if (isChoose) {
                      context.read<CustomerProfileState>().selectCar(model);
                      Navigator.pop(context);
                    } else {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AddAvtoFormPage(
                            carModel: model,
                            image: image ?? '',
                          ),
                        ),
                      );
                    }
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
