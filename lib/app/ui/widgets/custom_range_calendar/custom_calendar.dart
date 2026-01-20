// ignore_for_file: depend_on_referenced_packages

import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';

import 'package:auto_master/app/ui/theme/theme.dart';
import 'package:auto_master/app/ui/widgets/widgets.dart';
import 'package:auto_master/resources/resources.dart';

/// `const CustomCalendar({
///   Key? key,
///   this.initialStartDate,
///   this.initialEndDate,
///   this.startEndDateChange,
///   this.minimumDate,
///   this.maximumDate,
///   required this.primaryColor,
/// })`
class CustomCalendar extends StatefulWidget {
  /// The minimum date that can be selected on the calendar
  final DateTime? minimumDate;

  /// The maximum date that can be selected on the calendar
  final DateTime? maximumDate;

  /// The initial start date to be shown on the calendar
  final DateTime? initialStartDate;

  /// The initial end date to be shown on the calendar
  final DateTime? initialEndDate;

  final String? text;

  /// The primary color to be used in the calendar's color scheme
  final Color primaryColor;

  /// A function to be called when the selected date range changes
  final Function(DateTime, DateTime?)? startEndDateChange;

  final VoidCallback? onClickToday;
  final VoidCallback? onClickTomorrow;

  const CustomCalendar({
    Key? key,
    this.minimumDate,
    this.maximumDate,
    this.initialStartDate,
    this.initialEndDate,
    this.text,
    required this.primaryColor,
    this.startEndDateChange,
    this.onClickToday,
    this.onClickTomorrow,
  }) : super(key: key);

  @override
  CustomCalendarState createState() => CustomCalendarState();
}

class CustomCalendarState extends State<CustomCalendar> {
  List<DateTime> dateList = <DateTime>[];

  DateTime currentMonthDate = DateTime.now();

  DateTime? startDate;

  DateTime? endDate;

  @override
  void initState() {
    setListOfDate(currentMonthDate);
    if (widget.initialStartDate != null) {
      startDate = widget.initialStartDate;
    }
    if (widget.initialEndDate != null) {
      endDate = widget.initialEndDate;
    }
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void setListOfDate(DateTime monthDate) {
    dateList.clear();
    final DateTime newDate = DateTime(monthDate.year, monthDate.month, 0);
    int previousMothDay = 0;
    if (newDate.weekday < 7) {
      previousMothDay = newDate.weekday;
      for (int i = 1; i <= previousMothDay; i++) {
        dateList.add(newDate.subtract(Duration(days: previousMothDay - i)));
      }
    }
    for (int i = 0; i < (42 - previousMothDay); i++) {
      dateList.add(newDate.add(Duration(days: i + 1)));
    }
  }

  @override
  Widget build(BuildContext context) {
    initializeDateFormatting();
    return Column(
      children: <Widget>[
        const Align(
          alignment: Alignment.centerRight,
          child: Padding(
            padding: EdgeInsets.only(
              top: 5.0,
              right: 10.0,
              bottom: 0.0,
            ),
            child: CustomIconButton(
              icon: Svgs.close,
            ),
          ),
        ),
        if (widget.text != null)
          Padding(
            padding: const EdgeInsets.only(bottom: 10.0),
            child: Text(
              widget.text!,
              textAlign: TextAlign.center,
              style: AppTextStyle.s14w400.copyWith(color: AppColors.grey),
            ),
          ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18.0),
          child: Row(
            children: <Widget>[
              CustomElevationButton(
                width: 99.0,
                height: 26.0,
                title: 'Сегодня',
                onPressed: () {
                  widget.onClickToday?.call();
                },
              ),
              const SizedBox(width: 20.0),
              CustomElevationButton(
                width: 99.0,
                height: 26.0,
                title: 'Завтра',
                onPressed: () {
                  widget.onClickTomorrow?.call();
                },
              ),
            ],
          ),
        ),
        SizedBox(
          height: widget.text == null
              ? SizerUtil.height * .53
              : SizerUtil.height * .5,
          child: ListView(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(
                  left: 18.0,
                  right: 18.0,
                  top: 4,
                  bottom: 4,
                ),
                child: Row(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        height: 38,
                        width: 38,
                        decoration: BoxDecoration(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(24.0)),
                          border: Border.all(
                            color: Colors.grey.shade300,
                          ),
                        ),
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(24.0)),
                            onTap: () {
                              setState(() {
                                currentMonthDate = DateTime(
                                    currentMonthDate.year,
                                    currentMonthDate.month,
                                    0);
                                setListOfDate(currentMonthDate);
                              });
                            },
                            child: const Icon(
                              Icons.keyboard_arrow_left,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Center(
                        child: Text(
                          DateFormat('MMMM yyyy', 'ru')
                              .format(currentMonthDate),
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 20,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(18.0),
                      child: Container(
                        height: 38,
                        width: 38,
                        decoration: BoxDecoration(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(24.0)),
                          border: Border.all(
                            color: Colors.grey.shade300,
                          ),
                        ),
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(24.0)),
                            onTap: () {
                              setState(() {
                                currentMonthDate = DateTime(
                                    currentMonthDate.year,
                                    currentMonthDate.month + 2,
                                    0);
                                setListOfDate(currentMonthDate);
                              });
                            },
                            child: const Icon(
                              Icons.keyboard_arrow_right,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 18, left: 18, bottom: 10),
                child: Row(
                  children: getDaysNameUI(),
                ),
              ),
              const Divider(
                color: Color(0xFFF5F5F5),
                height: 1.0,
                thickness: 1.0,
                indent: 18,
                endIndent: 18,
              ),
              Padding(
                padding: const EdgeInsets.only(
                  right: 18,
                  left: 18,
                  top: 10,
                ),
                child: Column(
                  children: getDaysNoUI(),
                ),
              ),
            ],
          ),
        )
      ],
    );
  }

  List<Widget> getDaysNameUI() {
    final List<Widget> listUI = <Widget>[];
    for (int i = 0; i < 7; i++) {
      listUI.add(
        Expanded(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.only(top: 20.0),
              child: Text(
                DateFormat('E', 'ru').format(dateList[i])[0].toUpperCase(),
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: i > 4 ? widget.primaryColor : Colors.black,
                ),
              ),
            ),
          ),
        ),
      );
    }
    return listUI;
  }

  List<Widget> getDaysNoUI() {
    final List<Widget> noList = <Widget>[];
    int count = 0;
    for (int i = 0; i < dateList.length / 7; i++) {
      final List<Widget> listUI = <Widget>[];
      for (int i = 0; i < 7; i++) {
        final DateTime date = dateList[count];
        final isOffDay = date.weekday == DateTime.sunday ||
            date.weekday == DateTime.saturday;

        listUI.add(
          Expanded(
            child: AspectRatio(
              aspectRatio: 1.0,
              child: Stack(
                children: <Widget>[
                  Material(
                    color: Colors.transparent,
                    child: Padding(
                      padding: EdgeInsets.only(
                        top: 2,
                        bottom: 2,
                        left: isStartDateRadius(date) ? 4 : 0,
                        right: isEndDateRadius(date) ? 4 : 0,
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                          color: getIsNow(date) && !getIsInRange(date)
                              ? const Color(0xFFEDEDED)
                              : startDate != null && endDate != null
                                  ? getIsItStartAndEndDate(date) ||
                                          getIsInRange(date)
                                      ? widget.primaryColor
                                      : Colors.transparent
                                  : Colors.transparent,
                          borderRadius: getIsNow(date) && !getIsInRange(date)
                              ? BorderRadius.circular(100)
                              : endDate == null
                                  ? BorderRadius.circular(100)
                                  : BorderRadius.only(
                                      bottomLeft: isStartDateRadius(date)
                                          ? const Radius.circular(24.0)
                                          : const Radius.circular(0.0),
                                      topLeft: isStartDateRadius(date)
                                          ? const Radius.circular(24.0)
                                          : const Radius.circular(0.0),
                                      topRight: isEndDateRadius(date)
                                          ? const Radius.circular(24.0)
                                          : const Radius.circular(0.0),
                                      bottomRight: isEndDateRadius(date)
                                          ? const Radius.circular(24.0)
                                          : const Radius.circular(0.0),
                                    ),
                        ),
                      ),
                    ),
                  ),
                  Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius:
                          const BorderRadius.all(Radius.circular(32.0)),
                      onTap: () {
                        if (currentMonthDate.month == date.month) {
                          if (widget.minimumDate != null &&
                              widget.maximumDate != null) {
                            final DateTime newminimumDate = DateTime(
                                widget.minimumDate!.year,
                                widget.minimumDate!.month,
                                widget.minimumDate!.day - 1);
                            final DateTime newmaximumDate = DateTime(
                                widget.maximumDate!.year,
                                widget.maximumDate!.month,
                                widget.maximumDate!.day + 1);
                            if (date.isAfter(newminimumDate) &&
                                date.isBefore(newmaximumDate)) {
                              onDateClick(date);
                            }
                          } else if (widget.minimumDate != null) {
                            final DateTime newminimumDate = DateTime(
                                widget.minimumDate!.year,
                                widget.minimumDate!.month,
                                widget.minimumDate!.day - 1);
                            if (date.isAfter(newminimumDate)) {
                              onDateClick(date);
                            }
                          } else if (widget.maximumDate != null) {
                            final DateTime newmaximumDate = DateTime(
                                widget.maximumDate!.year,
                                widget.maximumDate!.month,
                                widget.maximumDate!.day + 1);
                            if (date.isBefore(newmaximumDate)) {
                              onDateClick(date);
                            }
                          } else {
                            onDateClick(date);
                          }
                        }
                      },
                      child: Container(
                        margin: const EdgeInsets.all(2.0),
                        decoration: BoxDecoration(
                          color: getIsItStartAndEndDate(date)
                              ? widget.primaryColor
                              : Colors.transparent,
                          borderRadius: endDate == null
                              ? BorderRadius.circular(100)
                              : BorderRadius.only(
                                  bottomLeft: isStartDateRadius(date)
                                      ? const Radius.circular(24.0)
                                      : const Radius.circular(0.0),
                                  topLeft: isStartDateRadius(date)
                                      ? const Radius.circular(24.0)
                                      : const Radius.circular(0.0),
                                  topRight: isEndDateRadius(date)
                                      ? const Radius.circular(24.0)
                                      : const Radius.circular(0.0),
                                  bottomRight: isEndDateRadius(date)
                                      ? const Radius.circular(24.0)
                                      : const Radius.circular(0.0),
                                ),
                        ),
                        child: Center(
                          child: Text(
                            currentMonthDate.month != date.month
                                ? ''
                                : '${date.day}',
                            style: TextStyle(
                              color: getIsItStartAndEndDate(date) ||
                                      getIsInRange(date)
                                  ? Colors.white
                                  : currentMonthDate.month == date.month
                                      ? isOffDay
                                          ? widget.primaryColor
                                          : Colors.black
                                      : Colors.grey.withOpacity(0.6),
                              fontSize: MediaQuery.of(context).size.width > 360
                                  ? 18
                                  : 16,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
        count += 1;
      }
      noList.add(Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: listUI,
      ));
    }
    return noList;
  }

  bool getIsInRange(DateTime date) {
    if (startDate != null && endDate != null) {
      if (date.isAfter(startDate!) && date.isBefore(endDate!)) {
        return true;
      } else {
        return false;
      }
    } else {
      return false;
    }
  }

  bool getIsNow(DateTime date) {
    return DateTime.now().day == date.day &&
        DateTime.now().month == date.month &&
        DateTime.now().year == date.year;
  }

  bool getIsItStartAndEndDate(DateTime date) {
    if (startDate != null &&
        startDate!.day == date.day &&
        startDate!.month == date.month &&
        startDate!.year == date.year) {
      return true;
    } else if (endDate != null &&
        endDate!.day == date.day &&
        endDate!.month == date.month &&
        endDate!.year == date.year) {
      return true;
    } else {
      return false;
    }
  }

  bool isStartDateRadius(DateTime date) {
    if (startDate != null &&
        startDate!.day == date.day &&
        startDate!.month == date.month) {
      return true;
    } else if (date.weekday == 1) {
      return true;
    } else {
      return false;
    }
  }

  bool isEndDateRadius(DateTime date) {
    if (endDate != null &&
        endDate!.day == date.day &&
        endDate!.month == date.month) {
      return true;
    } else if (date.weekday == 7) {
      return true;
    } else {
      return false;
    }
  }

  void onDateClick(DateTime date) {
    if (startDate == null) {
      startDate = date;
    } else if (startDate != date && endDate == null) {
      endDate = date;
    } else if (startDate!.day == date.day && startDate!.month == date.month) {
      startDate = null;
    } else if (endDate!.day == date.day && endDate!.month == date.month) {
      endDate = null;
    }
    if (startDate == null && endDate != null) {
      startDate = endDate;
      endDate = null;
    }
    if (startDate != null && endDate != null) {
      if (!endDate!.isAfter(startDate!)) {
        final DateTime d = startDate!;
        startDate = endDate;
        endDate = d;
      }
      if (date.isBefore(startDate!)) {
        startDate = date;
      }
      if (date.isAfter(endDate!)) {
        endDate = date;
      }
    }
    setState(() {
      try {
        widget.startEndDateChange!(startDate!, endDate);
      } catch (_) {}
    });
  }
}
