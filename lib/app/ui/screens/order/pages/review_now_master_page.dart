// ignore_for_file: deprecated_member_use, use_build_context_synchronously

import 'package:auto_master/app/app.dart';
import 'package:auto_master/app/data/api_client.dart';
import 'package:auto_master/app/domain/states/customer/orders_state.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_svg/svg.dart';

import 'package:auto_master/app/domain/service/customer_service.dart';
import 'package:auto_master/app/ui/theme/theme.dart';
import 'package:auto_master/app/ui/utils/show_message.dart';
import 'package:auto_master/app/ui/widgets/widgets.dart';
import 'package:auto_master/resources/resources.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class ReviewNowMasterPage extends StatefulWidget {
  final String masterAvatar;
  final String masterName;
  final String address;
  final String phone;
  final int orderId;
  final int masterId;

  const ReviewNowMasterPage({
    Key? key,
    required this.masterAvatar,
    required this.masterName,
    this.address = '',
    this.phone = '',
    required this.orderId,
    required this.masterId,
  }) : super(key: key);

  static const routeName = '/review_now_master_page';

  @override
  State<ReviewNowMasterPage> createState() => _ReviewNowMasterPageState();
}

class _ReviewNowMasterPageState extends State<ReviewNowMasterPage> {
  int rating = 0;
  bool isLoading = false;
  bool? alreadySetRating;

  @override
  void initState() {
    super.initState();
    setState(() {
      isLoading = true;
    });
    getAlreadySetRating();
  }

  getAlreadySetRating() async {
    alreadySetRating = await context
        .read<CustomerOrdersState>()
        .orderHasRating(widget.orderId);
    setState(() {
      isLoading = false;
    });
  }

  void sendRating() async {
    if (rating == 0) {
      showMessage('Поставьте оценку!');
      return;
    }

    isLoading = true;
    if (mounted) setState(() {});
    await context.read<CustomerOrdersState>().completeOrder(widget.orderId);
    await CustomerService.setRating(
      context,
      {
        'masterId': widget.masterId,
        'orderId': widget.orderId,
        'rating': rating,
      },
    );
    Navigator.pop(context);
    isLoading = false;
    if (mounted) setState(() {});
  }

  Future<void> _dialNumber() async {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: '+7 966 277 04 34',
    );
    await launchUrl(launchUri);
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(color: AppColors.main),
        ),
      );
    }
    if (alreadySetRating != null && alreadySetRating!) {
      return AlreadySetRatingPlaceholder(
        masterName: widget.masterName,
        address: widget.address,
        masterAvatar: widget.masterAvatar,
      );
    }
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 48),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 29,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CupertinoButton(
                    padding: EdgeInsets.zero,
                    onPressed: () => routemaster.history.back(),
                    child: SvgPicture.asset(
                      Svgs.arrow,
                      color: AppColors.black,
                    ),
                  ),
                  Text(
                    'Оцените работу',
                    style: AppTextStyle.s15w700.copyWith(
                      color: AppColors.main,
                    ),
                  ),
                  const SizedBox(width: 44),
                ],
              ),
            ),
            const SizedBox(height: 29),
            Text(
              'Вам понравилось\nвыполнение работы?',
              style: AppTextStyle.s14w400.copyWith(color: Colors.black),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 35),
            Container(
              width: 117,
              height: 117,
              clipBehavior: Clip.hardEdge,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
              ),
              child: CachedNetworkImage(
                imageUrl: '${ApiClient.baseImageUrl}${widget.masterAvatar}',
                fit: BoxFit.cover,
                width: 117,
                height: 117,
                errorWidget: (context, url, error) => SvgPicture.asset(
                  Svgs.profile,
                  fit: BoxFit.cover,
                  color: AppColors.greyLight,
                  width: 117,
                  height: 117,
                ),
              ),
            ),
            const SizedBox(height: 13),
            Text(
              widget.masterName,
              style: AppTextStyle.s15w700.copyWith(
                color: AppColors.main,
              ),
            ),
            const SizedBox(height: 15),
            Text(
              widget.address,
              style: AppTextStyle.s13w400,
            ),
            const SizedBox(height: 55),
            RatingBar.builder(
              glow: false,
              unratedColor: const Color(0xFFFFA200),
              itemPadding: const EdgeInsets.symmetric(horizontal: 11.0),
              itemSize: 46.0,
              itemBuilder: (context, index) => SvgPicture.asset(
                rating > index ? Svgs.activeStar : Svgs.star,
                color: const Color(0xFFFFA200),
              ),
              onRatingUpdate: (value) {
                rating = value.toInt();
                setState(() {});
              },
            ),
            const SizedBox(height: 62),
            Text(
              'Телефон горячей линии',
              style: AppTextStyle.s15w700.copyWith(
                color: AppColors.main,
              ),
            ),
            const SizedBox(height: 15),
            Center(
              child: GestureDetector(
                onTap: () {
                  _dialNumber();
                },
                child: Text(
                  '+7 966 277 04-34',
                  style: AppTextStyle.s15w400.copyWith(
                    color: AppColors.grey,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 15),
            //   Text(
            //   'Телефон горячей линии',
            //   style: AppTextStyle.s15w700.copyWith(
            //     color: AppColors.main,
            //   ),
            // ),
            // Text(
            //   widget.phone,
            //   style: AppTextStyle.s15w400.copyWith(
            //     color: AppColors.grey,
            //   ),
            // ),
            const Spacer(),
            CustomButton(
              width: 234,
              height: 47,
              text: 'Отправить оценку',
              onPressed: sendRating,
              isLoading: isLoading,
            ),
            const SizedBox(height: 38),
          ],
        ),
      ),
    );
  }
}

class AlreadySetRatingPlaceholder extends StatelessWidget {
  const AlreadySetRatingPlaceholder(
      {required this.address,
      required this.masterAvatar,
      required this.masterName,
      super.key});

  final String masterAvatar;
  final String masterName;
  final String address;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 48),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 29,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CupertinoButton(
                    padding: EdgeInsets.zero,
                    onPressed: () => routemaster.history.back(),
                    child: SvgPicture.asset(
                      Svgs.arrow,
                      color: AppColors.black,
                    ),
                  ),
                  Text(
                    'Оцените работу',
                    style: AppTextStyle.s15w700.copyWith(
                      color: AppColors.main,
                    ),
                  ),
                  const SizedBox(width: 44),
                ],
              ),
            ),
            const SizedBox(height: 35),
            Container(
              width: 117,
              height: 117,
              clipBehavior: Clip.hardEdge,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
              ),
              child: CachedNetworkImage(
                imageUrl: '${ApiClient.baseImageUrl}${masterAvatar}',
                fit: BoxFit.cover,
                width: 117,
                height: 117,
                errorWidget: (context, url, error) => SvgPicture.asset(
                  Svgs.profile,
                  fit: BoxFit.cover,
                  color: AppColors.greyLight,
                  width: 117,
                  height: 117,
                ),
              ),
            ),
            const SizedBox(height: 13),
            Text(
              masterName,
              style: AppTextStyle.s15w700.copyWith(
                color: AppColors.main,
              ),
            ),
            const SizedBox(height: 15),
            Text(
              address,
              style: AppTextStyle.s13w400,
            ),
            const SizedBox(height: 35),
            const Text(
              'Вы уже оценили этого мастера',
              style: AppTextStyle.s16w600,
            ),
          ],
        ),
      ),
    );
  }
}
