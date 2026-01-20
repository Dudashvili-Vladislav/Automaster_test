import 'package:auto_master/app/data/api_client.dart';
import 'package:auto_master/app/data/error_handler.dart';
import 'package:auto_master/app/domain/service/customer_service.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:sizer/sizer.dart';

import 'package:auto_master/app/domain/models/accessories_entity.dart';
import 'package:auto_master/app/ui/theme/theme.dart';
import 'package:auto_master/app/ui/widgets/widgets.dart';
import 'package:url_launcher/url_launcher_string.dart';

class AccessoriesDetailPage extends StatefulWidget {
  final Accessory data;
  const AccessoriesDetailPage({
    Key? key,
    required this.data,
  }) : super(key: key);

  @override
  State<AccessoriesDetailPage> createState() => _AccessoriesDetailPageState();
}

class _AccessoriesDetailPageState extends State<AccessoriesDetailPage> {
  bool buttonIsLoading = false;

  Future<void> loadLink() async {
    buttonIsLoading = true;
    if (mounted) setState(() {});

    final link = await CustomerService.getAccessoriesLink(context);

    if (link != null) {
      buttonIsLoading = false;
      if (mounted) setState(() {});
      await launchWA(link);
    }

    buttonIsLoading = false;
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          CachedNetworkImage(
            imageUrl: '${ApiClient.baseImageUrl}${widget.data.image}',
            height: SizerUtil.width,
            width: SizerUtil.width,
            fit: BoxFit.cover,
          ),
          Container(
            width: SizerUtil.width,
            margin: EdgeInsets.only(top: SizerUtil.width - 25),
            padding: const EdgeInsets.symmetric(
              horizontal: 36.0,
              vertical: 16.0,
            ),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(20.0),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  widget.data.name,
                  style: AppTextStyle.s24w600.copyWith(
                    color: AppColors.main,
                  ),
                ),
                const SizedBox(height: 24.0),
                Text(
                  'Описание товара',
                  style: AppTextStyle.s12w700.copyWith(
                    color: AppColors.grey,
                  ),
                ),
                const SizedBox(height: 8.0),
                Expanded(
                  child: SingleChildScrollView(
                    child: SizedBox(
                      width: double.infinity,
                      child: Text(
                        widget.data.description,
                        style: AppTextStyle.s12w400.copyWith(
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 24.0),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    // vertical: 30.0,
                    horizontal: 36.0,
                  ),
                  child: CustomButton(
                    hasIcon: true,
                    width: 247,
                    height: 47,
                    text: 'Заказать товар',
                    isLoading: buttonIsLoading,
                    onPressed: loadLink,
                  ),
                ),
              ],
            ),
          ),
          const Positioned(
            top: 20,
            left: 10,
            child: SafeArea(
              child: CustomIconButton(
                iconColor: AppColors.main,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
