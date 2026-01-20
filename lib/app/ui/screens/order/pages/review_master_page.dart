// ignore_for_file: use_build_context_synchronously, deprecated_member_use

import 'package:auto_master/app/app.dart';
import 'package:auto_master/app/data/api_client.dart';
import 'package:auto_master/app/domain/states/customer/orders_state.dart';
import 'package:auto_master/app/ui/routes/routes.dart';
import 'package:auto_master/main.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:auto_master/app/ui/screens/order/pages/review_now_master_page.dart';
import 'package:auto_master/app/ui/theme/theme.dart';

import 'package:auto_master/app/ui/widgets/widgets.dart';
import 'package:auto_master/resources/resources.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class ReviewMasterUIData {
  final String masterAvatar;
  final String masterName;
  final String address;
  final String phone;
  final int orderId;
  final int masterId;

  ReviewMasterUIData({
    required this.masterAvatar,
    required this.masterName,
    required this.address,
    required this.phone,
    required this.orderId,
    required this.masterId,
  });
}

ReviewMasterUIData? reviewMasterUIData;

class ReviewMasterPage extends StatelessWidget {
  const ReviewMasterPage();

  static const routeName = '/review_master_page';

  Future<void> _dialNumber() async {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: '+7 966 277 04 34',
    );
    await launchUrl(launchUri);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            CustomAppBar(
              title: 'Оцените работу',
              onBack: () {
                routemaster.history.back();
              },
            ),
            const SizedBox(height: 9),
            Expanded(
              child: ListView(
                children: [
                  Text(
                    'Поставьте оценку мастеру,\nэто поможет нам понимать\nнасколько качественно он выполнил\nработу',
                    style: AppTextStyle.s14w400.copyWith(color: Colors.black),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 35),
                  Center(
                    child: Container(
                      width: 117,
                      height: 117,
                      clipBehavior: Clip.hardEdge,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                      ),
                      child: CachedNetworkImage(
                        imageUrl:
                            '${ApiClient.baseImageUrl}${reviewMasterUIData!.masterAvatar}',
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
                  ),
                  const SizedBox(height: 13),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Center(
                      child: Text(
                        reviewMasterUIData!.masterName,
                        textAlign: TextAlign.center,
                        style: AppTextStyle.s15w700.copyWith(
                          color: AppColors.main,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 15),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Center(
                      child: Text(
                        reviewMasterUIData!.address,
                        textAlign: TextAlign.center,
                        style: AppTextStyle.s13w400,
                      ),
                    ),
                  ),
                  const SizedBox(height: 53),
                  Center(
                    child: Text(
                      'Телефон горячей линии',
                      style: AppTextStyle.s15w700.copyWith(
                        color: AppColors.main,
                      ),
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
                  const SizedBox(height: 20.0),
                  Center(
                    child: CustomButton(
                      width: 234,
                      height: 47,
                      text: 'Оценить сейчас',
                      onPressed: () =>
                          routemaster.push(ReviewNowMasterPage.routeName),
                    ),
                  ),
                  const SizedBox(height: 42),
                  CupertinoButton(
                    padding: EdgeInsets.zero,
                    onPressed: () async {
                      await showModalBottomSheet(
                        context: context,
                        enableDrag: false,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(30.0),
                          ),
                        ),
                        isScrollControlled: true,
                        builder: (context) {
                          DateTime date = DateTime.now();
                          return Column(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              const SizedBox(height: 20.0),
                              Padding(
                                padding: const EdgeInsets.only(bottom: 20.0),
                                child: Text(
                                  'Мы отправим вам\npush уведомления c напоминанием\nоставить отзыв, укажите в какое число',
                                  textAlign: TextAlign.center,
                                  style: AppTextStyle.s14w400
                                      .copyWith(color: AppColors.grey),
                                ),
                              ),
                              SizedBox(
                                width: double.infinity,
                                height: 200.0,
                                child: CupertinoDatePicker(
                                  use24hFormat: true,
                                  minimumDate: DateTime.now(),
                                  onDateTimeChanged: (value) {
                                    date = value;
                                  },
                                ),
                              ),
                              const SizedBox(height: 30.0),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: <Widget>[
                                  SizedBox(
                                    width: 77.0,
                                    height: 36.0,
                                    child: CupertinoButton(
                                      padding: EdgeInsets.zero,
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: Text(
                                        'назад'.toUpperCase(),
                                        style: AppTextStyle.s14w500.copyWith(
                                          color: AppColors.main,
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 64.0,
                                    height: 36.0,
                                    child: CupertinoButton(
                                      padding: EdgeInsets.zero,
                                      onPressed: () async {
                                        final now = DateTime.now();

                                        // if (now.year == date.year &&
                                        //     now.month == date.month &&
                                        //     now.day == date.day) {

                                        print('SET NOTIFICATION' +
                                            (date.isAfter(now)
                                                    ? date
                                                    : now.add(const Duration(
                                                        seconds: 10)))
                                                .toIso8601String());

                                        await localNotifyService
                                            .scheduleNotification(
                                          reviewMasterUIData!.masterName,
                                          reviewMasterUIData!.masterAvatar,
                                          reviewMasterUIData!.address,
                                          reviewMasterUIData!.phone,
                                          reviewMasterUIData!.orderId,
                                          reviewMasterUIData!.masterId,
                                          date.isAfter(now)
                                              ? date
                                              : now.add(
                                                  const Duration(seconds: 10)),
                                        );

                                        // } else {
                                        //   await localNotifyService
                                        //       .scheduleNotification(
                                        //     masterName,
                                        //     masterAvatar,
                                        //     address,
                                        //     phone,
                                        //     orderId,
                                        //     masterId,
                                        //     date,
                                        //   );
                                        // }

                                        routemaster.popUntil((routeData) =>
                                            routeData.path == AppRoutes.home);

                                        // routemaster
                                        //     .popUntil((routeData) => false);
                                        // Navigator.pop(context);
                                      },
                                      child: Text(
                                        'OK',
                                        style: AppTextStyle.s14w500.copyWith(
                                          color: AppColors.main,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 20.0),
                            ],
                          );
                        },
                      );
                      // if (isOkPressed) {
                      //   Navigator.pop(context);
                      // }
                      // DateTime? date;
                      // await showCustomDateRangePicker(
                      //   context,
                      //   dismissible: false,
                      //   text:
                      //       'Мы отправим вам\npush уведомления c напоминанием\nоставить отзыв, укажите в какое число',
                      //   primaryColor: AppColors.main,
                      //   backgroundColor: Colors.white,
                      //   minimumDate: DateTime.now(),
                      //   maximumDate: DateTime.now().add(
                      //     const Duration(days: 365),
                      //   ),
                      //   onApplyClick: (d, a) {
                      //     date = d;
                      //   },
                      //   onCancelClick: () {},
                      // );
                      // if (date != null) {
                      //   showModalBottomSheet(
                      //     context: context,
                      //     shape: const RoundedRectangleBorder(
                      //       borderRadius: BorderRadius.vertical(
                      //         top: Radius.circular(30.0),
                      //       ),
                      //     ),
                      //     isScrollControlled: true,
                      //     builder: (childContext) {
                      //       final bottom =
                      //           MediaQuery.of(childContext).viewInsets.bottom;

                      //       return Padding(
                      //         padding:
                      //             const EdgeInsets.symmetric(horizontal: 30.0)
                      //                 .copyWith(top: 10.0, bottom: bottom),
                      //         child: Column(
                      //           mainAxisSize: MainAxisSize.min,
                      //           children: <Widget>[
                      //             const Align(
                      //               alignment: Alignment.topRight,
                      //               child: CustomIconButton(
                      //                 icon: Svgs.close,
                      //               ),
                      //             ),
                      //             Text(
                      //               'Мы отправим вам\npush уведомления c напоминанием\nоставить отзыв, укажите в какое время',
                      //               textAlign: TextAlign.center,
                      //               style: AppTextStyle.s14w400
                      //                   .copyWith(color: AppColors.grey),
                      //             ),
                      //             const SizedBox(height: 28.0),
                      //             CustomTimePicker(
                      //               initialTime: TimeOfDay.now().replacing(
                      //                 minute: TimeOfDay.now().minute + 5,
                      //               ),
                      //               onTimeChanged: (TimeOfDay v) async {
                      // final now = DateTime.now();
                      // final dateTime = DateTime(
                      //   date!.year,
                      //   date!.month,
                      //   date!.day,
                      //   v.hour,
                      //   v.minute,
                      // );
                      // if (now.year == date!.year &&
                      //     now.month == date!.month &&
                      //     now.day == date!.day) {
                      //   if (dateTime.isAfter(now)) {
                      //     await localNotifyService
                      //         .scheduleNotification(
                      //       masterName,
                      //       masterAvatar,
                      //       address,
                      //       phone,
                      //       orderId,
                      //       masterId,
                      //       dateTime,
                      //     );
                      //   } else {
                      //     await localNotifyService
                      //         .scheduleNotification(
                      //       masterName,
                      //       masterAvatar,
                      //       address,
                      //       phone,
                      //       orderId,
                      //       masterId,
                      //       now.add(
                      //           const Duration(minutes: 10)),
                      //     );
                      //   }
                      // } else {
                      //   await localNotifyService
                      //       .scheduleNotification(
                      //     masterName,
                      //     masterAvatar,
                      //     address,
                      //     phone,
                      //     orderId,
                      //     masterId,
                      //     dateTime,
                      //   );
                      // }

                      //                 Navigator.pop(childContext);
                      //               },
                      //             ),
                      //           ],
                      //         ),
                      //       );
                      //     },
                      //   );
                      // }
                    },
                    child: Container(
                      width: 234,
                      height: 47,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(60),
                        boxShadow: [
                          BoxShadow(
                            blurRadius: 4,
                            color: Colors.black.withOpacity(.25),
                          ),
                        ],
                      ),
                      child: Center(
                        child: Text(
                          'Оценить позже',
                          style: AppTextStyle.s18w700.copyWith(
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 34),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
