// ignore_for_file: depend_on_referenced_packages

import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import 'package:auto_master/app/ui/widgets/widgets.dart';

import 'custom_calendar.dart';

/// A custom date range picker widget that allows users to select a date range.
/// `const CustomDateRangePicker({
///   Key? key,
///   this.initialStartDate,
///   this.initialEndDate,
///   required this.primaryColor,
///   required this.backgroundColor,
///   required this.onApplyClick,
///   this.barrierDismissible = true,
///   required this.minimumDate,
///   required this.maximumDate,
///   required this.onCancelClick,
/// })`
class CustomDateRangePicker extends StatefulWidget {
  /// The minimum date that can be selected in the calendar.
  final DateTime minimumDate;

  /// The maximum date that can be selected in the calendar.
  final DateTime maximumDate;

  /// Whether the widget can be dismissed by tapping outside of it.
  final bool barrierDismissible;

  /// The initial start date for the date range picker. If not provided, the calendar will default to the minimum date.
  final DateTime? initialStartDate;

  /// The initial end date for the date range picker. If not provided, the calendar will default to the maximum date.
  final DateTime? initialEndDate;

  /// The primary color used for the date range picker.
  final Color primaryColor;

  /// The background color used for the date range picker.
  final Color backgroundColor;

  /// A callback function that is called when the user applies the selected date range.
  final Function(DateTime, DateTime?) onApplyClick;

  /// A callback function that is called when the user cancels the selection of the date range.
  final Function() onCancelClick;

  final String? text;

  const CustomDateRangePicker({
    Key? key,
    required this.minimumDate,
    required this.maximumDate,
    this.barrierDismissible = true,
    this.initialStartDate,
    this.initialEndDate,
    required this.primaryColor,
    required this.backgroundColor,
    required this.onApplyClick,
    required this.onCancelClick,
    this.text,
  }) : super(key: key);

  @override
  CustomDateRangePickerState createState() => CustomDateRangePickerState();
}

class CustomDateRangePickerState extends State<CustomDateRangePicker>
    with TickerProviderStateMixin {
  AnimationController? animationController;

  DateTime? startDate;

  DateTime? endDate;

  @override
  void initState() {
    animationController = AnimationController(
        duration: const Duration(milliseconds: 400), vsync: this);
    startDate = widget.initialStartDate;
    endDate = widget.initialEndDate;
    animationController?.forward();
    super.initState();
  }

  @override
  void dispose() {
    animationController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: InkWell(
          splashColor: Colors.transparent,
          focusColor: Colors.transparent,
          highlightColor: Colors.transparent,
          hoverColor: Colors.transparent,
          onTap: () {
            if (widget.barrierDismissible) {
              Navigator.pop(context);
            }
          },
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              CustomCalendar(
                text: widget.text,
                minimumDate: widget.minimumDate,
                maximumDate: widget.maximumDate,
                initialEndDate: widget.initialEndDate,
                initialStartDate: widget.initialStartDate,
                primaryColor: widget.primaryColor,
                onClickToday: () {
                  widget.onApplyClick(DateTime.now(), null);
                  Navigator.pop(context);
                },
                onClickTomorrow: () {
                  widget.onApplyClick(
                      DateTime.now().add(
                        const Duration(days: 1),
                      ),
                      null);
                  Navigator.pop(context);
                },
                startEndDateChange:
                    (DateTime startDateData, DateTime? endDateData) {
                  setState(() {
                    startDate = startDateData;
                    endDate = endDateData;
                  });
                },
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 30.0),
                child: Center(
                  child: CustomButton(
                    width: 234.0,
                    height: 47.0,
                    text: 'Выбрать',
                    onPressed: () {
                      try {
                        widget.onApplyClick(startDate!, endDate);
                        Navigator.pop(context);
                      } catch (_) {}
                    },
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

/// Displays a custom date range picker dialog box.
/// `context` The context in which to show the dialog.
/// `dismissible` A boolean value indicating whether the dialog can be dismissed by tapping outside of it.
/// `minimumDate` A DateTime object representing the minimum allowable date that can be selected in the date range picker.
/// `maximumDate` A DateTime object representing the maximum allowable date that can be selected in the date range picker.
/// `startDate` A nullable DateTime object representing the initial start date of the date range selection.
/// `endDate` A nullable DateTime object representing the initial end date of the date range selection.
/// `onApplyClick` A function that takes two DateTime parameters representing the selected start and end dates, respectively, and is called when the user taps the "Apply" button.
/// `onCancelClick` A function that is called when the user taps the "Cancel" button.
/// `backgroundColor` The background color of the dialog.
/// `primaryColor` The primary color of the dialog.
/// `fontFamily` The font family to use for the text in the dialog.

Future<void> showCustomDateRangePicker(
  BuildContext context, {
  required bool dismissible,
  required DateTime minimumDate,
  required DateTime maximumDate,
  DateTime? startDate,
  DateTime? endDate,
  required Function(DateTime startDate, DateTime? endDate) onApplyClick,
  required Function() onCancelClick,
  required Color backgroundColor,
  required Color primaryColor,
  String? fontFamily,
  String? text,
}) {
  /// Request focus to take it away from any input field that might be in focus
  FocusScope.of(context).requestFocus(FocusNode());

  /// Show the CustomDateRangePicker dialog box
  return showModalBottomSheet<dynamic>(
    context: context,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(
        top: Radius.circular(30.0),
      ),
    ),
    builder: (BuildContext context) => SizedBox(
      height: SizerUtil.height * (text != null ? .85 : .8),
      child: CustomDateRangePicker(
        barrierDismissible: true,
        text: text,
        backgroundColor: backgroundColor,
        primaryColor: primaryColor,
        minimumDate: minimumDate,
        maximumDate: maximumDate,
        initialStartDate: startDate,
        initialEndDate: endDate,
        onApplyClick: onApplyClick,
        onCancelClick: onCancelClick,
      ),
    ),
  );
}
