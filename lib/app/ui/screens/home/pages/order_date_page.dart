import 'package:auto_master/app/app.dart';
import 'package:auto_master/app/constatns.dart';
import 'package:auto_master/app/domain/states/customer/home_state.dart';
import 'package:auto_master/app/ui/routes/routes.dart';
import 'package:auto_master/app/ui/theme/theme.dart';
import 'package:auto_master/app/ui/widgets/widgets.dart';
import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'package:provider/provider.dart';

class OrderDatePage extends StatefulWidget {
  const OrderDatePage({super.key});

  @override
  State<OrderDatePage> createState() => _OrderDatePageState();
}

class _OrderDatePageState extends State<OrderDatePage> {
  // List<DateTime> dates = [];
  String? selectedDate;

  @override
  void initState() {
    super.initState();
    initializeDateFormatting();
  }

  // void onChangeDate(List<DateTime>? newDates) {
  //   if (newDates == null) {
  //     dates.clear();
  //   } else {
  //     dates = newDates;
  //     if (dates.length > 1) {
  //       selectedDate =
  //           '${dates.first.day} - ${DateFormat('dd MMMM yyyy года', 'ru').format(dates.last)}';
  //     } else {
  //       selectedDate =
  //           DateFormat('dd MMMM yyyy года', 'ru').format(dates.first);
  //     }
  //   }
  //   setState(() {});
  // }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<HomeState>();
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const CustomAppBar(
              title: 'Создание заявки',
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 35,
                ),
                child: Column(
                  children: [
                    Text(
                      'Выберете дату приёма у мастера, когда\nвам будет более удобно',
                      style: AppTextStyle.s14w400.copyWith(
                        color: AppColors.black,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const Spacer(),
                    CupertinoButton(
                      padding: EdgeInsets.zero,
                      onPressed: () {
                        showModalBottomSheet(
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
                                const SizedBox(height: 30.0),
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
                                          routemaster.history.back();
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
                                        onPressed: () {
                                          context
                                              .read<HomeState>()
                                              .setDate(dateFrom: date);
                                          Navigator.pop(context);
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
                      },
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 22.0,
                          vertical: 16.0,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(60),
                          boxShadow: [
                            state.date == null
                                ? AppTheme.shadowBlur4
                                : BoxShadow(
                                    color: AppColors.main.withOpacity(.25),
                                    blurRadius: 4.0,
                                  ),
                          ],
                          color: Colors.white,
                        ),
                        child: Text(
                          state.date == null
                              ? 'Выберете дату и время'
                              : dateTimeFormatter.format(state.date!),
                          style: AppTextStyle.s14w400.copyWith(
                            color: selectedDate == null
                                ? const Color(0xFFB6B6B6)
                                : AppColors.main,
                          ),
                        ),
                      ),
                    ),
                    const Spacer(flex: 2),
                    CustomButton(
                      width: 234,
                      height: 47,
                      text: 'Далее',
                      onPressed: state.date == null
                          ? null
                          : () {
                              routemaster.push(AppRoutes.selectKM);
                            },
                    ),
                    const SizedBox(height: 27),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
