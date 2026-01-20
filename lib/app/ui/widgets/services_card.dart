import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:auto_master/app/data/api_client.dart';
import 'package:auto_master/app/ui/theme/app_colors.dart';

import '../theme/app_text_style.dart';

class ServicesCard extends StatelessWidget {
  const ServicesCard({
    Key? key,
    required this.text,
    required this.image,
    this.isAsset = false,
    required this.onPressed,
  }) : super(key: key);
  final String text;
  final String image;
  final bool isAsset;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      padding: EdgeInsets.zero,
      onPressed: onPressed,
      child: Container(
        width: 100,
        height: 100,
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              blurRadius: 6,
              color: Colors.black.withOpacity(.25),
            ),
          ],
        ),
        child: Column(
          children: [
            const SizedBox(height: 8),
            SizedBox(
              width: 100,
              height: 52,
              // Expanded(
              child: isAsset
                  ? Image.asset(
                      image,
                    )
                  : CachedNetworkImage(
                      imageUrl: '${ApiClient.baseImageUrl}$image',
                      errorWidget: (context, url, error) => const Icon(
                        Icons.error,
                        color: AppColors.main,
                      ),
                      placeholder: (context, url) => const Center(
                        child: SizedBox(
                          width: 20.0,
                          height: 20.0,
                          child: CircularProgressIndicator(
                            strokeWidth: 3,
                            valueColor: AlwaysStoppedAnimation(AppColors.main),
                          ),
                        ),
                      ),
                    ),
            ),
            const SizedBox(height: 4.0),
            Text(
              text,
              maxLines: 2,
              textAlign: TextAlign.center,
              style: AppTextStyle.s12w600.copyWith(
                color: AppColors.black,
              ),
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 8.0),
          ],
        ),
      ),
    );
  }
}
