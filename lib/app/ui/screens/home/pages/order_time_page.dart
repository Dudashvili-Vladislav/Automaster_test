// import 'package:auto_master/app/app.dart';
// import 'package:auto_master/app/domain/states/customer/home_state.dart';
// import 'package:auto_master/app/ui/routes/routes.dart';
// import 'package:auto_master/app/ui/theme/theme.dart';
// import 'package:auto_master/app/ui/widgets/cutom_time_picker.dart';
// import 'package:auto_master/app/ui/widgets/widgets.dart';
// import 'package:auto_master/resources/resources.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:intl/date_symbol_data_local.dart';
// import 'package:intl/intl.dart';
// import 'package:provider/provider.dart';
// import 'package:sizer/sizer.dart';

// class OrderTimePage extends StatefulWidget {
//   const OrderTimePage({super.key});

//   @override
//   State<OrderTimePage> createState() => _OrderTimePageState();
// }

// class _OrderTimePageState extends State<OrderTimePage> {
//   List<DateTime> dates = [];
//   DateTime? selectedTime;

//   @override
//   void initState() {
//     super.initState();
//     initializeDateFormatting();
//     context.read<HomeState>().clearTime();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final state = context.watch<HomeState>();
//     final read = context.read<HomeState>();
//     return Scaffold(
//       resizeToAvoidBottomInset: false,
//       body: SafeArea(
//         child: Column(
//           children: [
//             const CustomAppBar(
//               title: 'Создание заявки',
//             ),
//             const SizedBox(height: 38),
//             Expanded(
//               child: Padding(
//                 padding: const EdgeInsets.symmetric(
//                   horizontal: 36,
//                 ),
//                 child: Column(
//                   children: [
//                     Text(
//                       'Выберете время приёма у мастера, когда\nвам будет более удобно',
//                       style: AppTextStyle.s14w400.copyWith(
//                         color: AppColors.black,
//                       ),
//                       textAlign: TextAlign.center,
//                     ),
//                     const Spacer(),
//                     CupertinoButton(
//                       padding: EdgeInsets.zero,
//                       onPressed: () {
//                         showModalBottomSheet(
//                           context: context,
//                           enableDrag: false,
//                           shape: const RoundedRectangleBorder(
//                             borderRadius: BorderRadius.vertical(
//                               top: Radius.circular(30.0),
//                             ),
//                           ),
//                           isScrollControlled: true,
//                           builder: (context) => Padding(
//                             padding:
//                                 const EdgeInsets.symmetric(horizontal: 30.0)
//                                     .copyWith(top: 10.0),
//                             child: Column(
//                               mainAxisSize: MainAxisSize.min,
//                               children: [
//                                 const Align(
//                                   alignment: Alignment.topRight,
//                                   child: CustomIconButton(
//                                     icon: Svgs.close,
//                                   ),
//                                 ),
//                                 const Padding(
//                                   padding: EdgeInsets.only(
//                                     top: 21.0,
//                                     bottom: 28.0,
//                                   ),
//                                   child: SelectHour(),
//                                 ),
//                                 const SelectMinute(),
//                                 const SizedBox(height: 50.0),
//                                 Row(
//                                   mainAxisAlignment: MainAxisAlignment.end,
//                                   children: <Widget>[
//                                     SizedBox(
//                                       width: 77.0,
//                                       height: 36.0,
//                                       child: CupertinoButton(
//                                         padding: EdgeInsets.zero,
//                                         onPressed: () {
//                                           read.clearTime();
//                                           Navigator.pop(context);
//                                         },
//                                         child: Text(
//                                           'назад'.toUpperCase(),
//                                           style: AppTextStyle.s14w500.copyWith(
//                                             color: AppColors.main,
//                                           ),
//                                         ),
//                                       ),
//                                     ),
//                                     SizedBox(
//                                       width: 64.0,
//                                       height: 36.0,
//                                       child: CupertinoButton(
//                                         padding: EdgeInsets.zero,
//                                         onPressed: () {
//                                           final hour = state.hour;
//                                           final minute = state.minute;
//                                           if (hour != null && minute != null) {
//                                             selectedTime = DateTime.now()
//                                                 .copyWith(
//                                                     hour: hour, minute: minute);

//                                             if (mounted) setState(() {});
//                                           }
//                                           Navigator.pop(context);
//                                         },
//                                         child: Text(
//                                           'OK',
//                                           style: AppTextStyle.s14w500.copyWith(
//                                             color: AppColors.main,
//                                           ),
//                                         ),
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                                 const SizedBox(height: 30.0),
//                                 // CustomTimePicker(
//                                 //   helpText: 'Выберите время',
//                                 //   hourLabelText: 'Часов',
//                                 //   minuteLabelText: 'Минута',
//                                 //   initialTime: TimeOfDay.now().replacing(
//                                 //       hour: TimeOfDay.now().hourOfPeriod),
//                                 //   onTimeChanged: (TimeOfDay v) {
//                                 //     selectedTimeOfday = v;
//                                 //     selectedTime =
//                                 //         '${v.hour.toString().padLeft(2, '0')}:${v.minute.toString().padLeft(2, '0')} ${v.period.toString().split('.')[1] == 'pm' ? 'день' : 'утра'}';
//                                 //     setState(() {});
//                                 //   },
//                                 // ),
//                               ],
//                             ),
//                           ),
//                         );
//                       },
//                       child: Container(
//                         width: double.infinity,
//                         padding: const EdgeInsets.symmetric(
//                           horizontal: 22.0,
//                           vertical: 16.0,
//                         ),
//                         decoration: BoxDecoration(
//                           borderRadius: BorderRadius.circular(60),
//                           boxShadow: [
//                             selectedTime == null
//                                 ? AppTheme.shadowBlur4
//                                 : BoxShadow(
//                                     color: AppColors.main.withOpacity(.25),
//                                     blurRadius: 4.0,
//                                   ),
//                           ],
//                           color: Colors.white,
//                         ),
//                         child: Text(
//                           selectedTime != null
//                               ? DateFormat('HH:mm').format(selectedTime!)
//                               : 'Выберете время',
//                           style: AppTextStyle.s14w400.copyWith(
//                             color: selectedTime == null
//                                 ? const Color(0xFFB6B6B6)
//                                 : AppColors.main,
//                           ),
//                         ),
//                       ),
//                     ),
//                     const Spacer(flex: 2),
//                     CustomButton(
//                       width: 234,
//                       height: 47,
//                       text: 'Далее',
//                       onPressed: selectedTime == null
//                           ? null
//                           : () {
//                               context.read<HomeState>().setTime(selectedTime!);
//                               routemaster.push(AppRoutes.selectKM);
//                             },
//                     ),
//                     const SizedBox(height: 27),
//                   ],
//                 ),
//               ),
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }

// class SelectMinute extends StatelessWidget {
//   const SelectMinute({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     final state = context.watch<HomeState>();
//     final read = context.read<HomeState>();
//     return CupertinoButton(
//       padding: EdgeInsets.zero,
//       onPressed: () async {
//         final minute = await showModalBottomSheet(
//           context: context,
//           isScrollControlled: true,
//           shape: const RoundedRectangleBorder(
//             borderRadius: BorderRadius.vertical(
//               top: Radius.circular(30.0),
//             ),
//           ),
//           builder: (context) => Column(
//             mainAxisSize: MainAxisSize.min,
//             children: <Widget>[
//               Padding(
//                 padding: const EdgeInsets.symmetric(vertical: 15.0),
//                 child: Text(
//                   'Выберете минуту',
//                   style: AppTextStyle.s18w700.copyWith(
//                     color: AppColors.black,
//                   ),
//                 ),
//               ),
//               SizedBox(
//                 height: SizerUtil.height * .5,
//                 child: ListView.builder(
//                   itemBuilder: (_, index) => ListTile(
//                     onTap: () {
//                       Navigator.pop(context, index * 10);
//                     },
//                     title: Text(
//                       '${index * 10}'.padLeft(2, '0'),
//                       style: AppTextStyle.s15w700,
//                     ),
//                   ),
//                   itemCount: 7,
//                 ),
//               ),
//             ],
//           ),
//         );
//         read.setMinute(minute);
//       },
//       child: Container(
//         height: 46.0,
//         width: double.infinity,
//         decoration: BoxDecoration(
//           boxShadow: [
//             BoxShadow(
//               blurRadius: 4.0,
//               color: Colors.black.withOpacity(.25),
//             ),
//           ],
//           color: Colors.white,
//           borderRadius: BorderRadius.circular(60),
//         ),
//         padding: const EdgeInsets.only(
//           top: 16.0,
//           left: 16.0,
//         ),
//         child: Text(
//           state.minute == null
//               ? 'Выберете минуту'
//               : state.minute.toString().padLeft(2, '0'),
//           style: AppTextStyle.s14w400.copyWith(
//             color: state.minute == null
//                 ? const Color(0xFFB6B6B6)
//                 : AppColors.black,
//           ),
//         ),
//       ),
//     );
//   }
// }

// class SelectHour extends StatelessWidget {
//   const SelectHour({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     final state = context.watch<HomeState>();
//     final read = context.read<HomeState>();
//     return CupertinoButton(
//       onPressed: () async {
//         final hour = await showModalBottomSheet(
//           context: context,
//           isScrollControlled: true,
//           shape: const RoundedRectangleBorder(
//             borderRadius: BorderRadius.vertical(
//               top: Radius.circular(30.0),
//             ),
//           ),
//           builder: (context) => Column(
//             mainAxisSize: MainAxisSize.min,
//             children: <Widget>[
//               Padding(
//                 padding: const EdgeInsets.symmetric(vertical: 15.0),
//                 child: Text(
//                   'Выберете час',
//                   style: AppTextStyle.s18w700.copyWith(
//                     color: AppColors.black,
//                   ),
//                 ),
//               ),
//               SizedBox(
//                 height: SizerUtil.height * .7,
//                 child: ListView.builder(
//                   itemBuilder: (_, index) => ListTile(
//                     onTap: () {
//                       Navigator.pop(context, index + 1);
//                     },
//                     title: Text(
//                       '${index + 1}',
//                       style: AppTextStyle.s15w700,
//                     ),
//                   ),
//                   itemCount: 24,
//                 ),
//               ),
//             ],
//           ),
//         );
//         read.setHour(hour);
//       },
//       padding: EdgeInsets.zero,
//       child: Container(
//         height: 46.0,
//         width: double.infinity,
//         decoration: BoxDecoration(
//           boxShadow: [
//             BoxShadow(
//               blurRadius: 4.0,
//               color: Colors.black.withOpacity(.25),
//             ),
//           ],
//           color: Colors.white,
//           borderRadius: BorderRadius.circular(60),
//         ),
//         padding: const EdgeInsets.only(
//           top: 16.0,
//           left: 16.0,
//         ),
//         child: Text(
//           state.hour == null
//               ? 'Выберете час'
//               : state.hour.toString().padLeft(2, '0'),
//           style: AppTextStyle.s14w400.copyWith(
//             color:
//                 state.hour == null ? const Color(0xFFB6B6B6) : AppColors.black,
//           ),
//         ),
//       ),
//     );
//   }
// }
