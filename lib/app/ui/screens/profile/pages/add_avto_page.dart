// // ignore_for_file: public_member_api_docs, sort_constructors_first
// // ignore_for_file: use_build_context_synchronously

// import 'package:auto_master/app/ui/screens/profile/pages/add_auto_first_page.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:provider/provider.dart';
// import 'package:searchfield/searchfield.dart';

// import 'package:auto_master/app/constatns.dart';
// import 'package:auto_master/app/domain/models/car_brand.dart';
// import 'package:auto_master/app/domain/states/customer/add_car_state.dart';
// import 'package:auto_master/app/domain/states/customer/profile_state.dart';
// import 'package:auto_master/app/ui/theme/app_text_style.dart';
// import 'package:auto_master/app/ui/theme/theme.dart';
// import 'package:auto_master/app/ui/widgets/widgets.dart';

// class AddAvtoPageOld extends StatefulWidget {
//   const AddAvtoPageOld({super.key});

//   @override
//   State<AddAvtoPageOld> createState() => _AddAvtoPageState();
// }

// class _AddAvtoPageState extends State<AddAvtoPageOld> {
//   int _currentPage = 0;
//   final controller = ScrollController();

//   List<Widget> pages = [];

//   void onChange({bool isBack = false}) async {
//     if (_currentPage == 3 && !isBack) {
//       await context.read<AddCarState>().addOrEditCar(context);

//       if (context.read<AddCarState>().carModel != null) {
//         context.read<CustomerProfileState>().fetchCars();
//         Navigator.pop(context);
//         if (Navigator.canPop(context)) Navigator.pop(context);
//       } else {
//         Navigator.pop(context);
//       }
//       return;
//     }

//     if (isBack && _currentPage != 0) {
//       _currentPage--;
//     } else {
//       _currentPage++;
//     }
//     setState(() {});
//   }

//   @override
//   void initState() {
//     super.initState();
//     pages = [
//       const AddAutoFirst(),
//       AddAutoSecond(onScroll: scrollBottom),
//       const AddAutoThird(),
//       const AddAutoLast()
//     ];
//     Future.microtask(() => context.read<AddCarState>().getBodyList(context));
//   }

//   void scrollBottom() {
//     if (controller.hasClients) {
//       controller.animateTo(
//         100,
//         duration: kThemeAnimationDuration,
//         curve: Curves.linear,
//       );
//     }
//   }

//   @override
//   void dispose() {
//     controller.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final state = context.watch<AddCarState>();
//     final isValid = _currentPage == 0
//         ? state.selectedCarNationality != null
//         : _currentPage == 1
//             ? state.selectedCarBrand != null &&
//                 state.selectedCarModel != null &&
//                 state.selectedBodyType != null
//             : _currentPage == 2
//                 ? state.selectedEngineType != null &&
//                     state.selectedEnginePower != null
//                 : _currentPage == 3
//                     ? (state.selectedCarNumber != null &&
//                             state.selectedCarNumber?.length == 11) &&
//                         state.selectedTypeOfDrive != null
//                     : false;
//     // print(isValid);
//     // print('selectedCarNationality');
//     // print(state.selectedCarNationality != null);
//     // print('selectedCarBrand');
//     // print(state.selectedCarBrand != null);
//     // print('selectedCarModel');
//     // print(state.selectedCarModel != null);
//     // print('selectedBodyType');
//     // print(state.selectedBodyType != null);
//     // print('selectedEngineType');
//     // print(state.selectedEngineType != null);
//     // print('selectedEnginePower');
//     // print(state.selectedEnginePower != null);
//     // print('selectedCarNumber');
//     // print(state.selectedCarNumber != null);
//     // print('selectedCarNumber.length');
//     // print(state.selectedCarNumber?.length);
//     // print('selectedTypeOfDrive');
//     // print(state.selectedTypeOfDrive != null);
//     return GestureDetector(
//       onTap: () => FocusScope.of(context).unfocus(),
//       child: Scaffold(
//         body: SafeArea(
//           child: Column(
//             children: [
//               CustomAppBar(
//                 onBack: _currentPage == 0 || state.isLoading
//                     ? null
//                     : () => onChange(isBack: true),
//                 title: 'Добавление авто',
//               ),
//               Expanded(
//                 child: ListView(
//                   controller: controller,
//                   physics: const RangeMaintainingScrollPhysics(),
//                   children: [
//                     pages[_currentPage],
//                   ],
//                 ),
//               ),
//               const SizedBox(height: 20),
//               CustomButton(
//                 width: 234,
//                 height: 47,
//                 text: _currentPage == 3
//                     ? state.carModel != null
//                         ? 'Изменить авто'
//                         : 'Добавить авто'
//                     : 'Далее',
//                 onPressed: isValid ? onChange : null,
//                 isLoading: state.isLoading,
//               ),
//               const SizedBox(height: 27),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

// class AddAutoLast extends StatefulWidget {
//   const AddAutoLast({super.key});

//   @override
//   State<AddAutoLast> createState() => _AddAutoLastState();
// }

// class _AddAutoLastState extends State<AddAutoLast> {
//   bool isActive = false;
//   int? currentChek;

//   final carNumController = TextEditingController();
//   final vinNumController = TextEditingController();

//   final carNumNode = FocusNode();
//   final vinNumNode = FocusNode();

//   void toggle() {
//     FocusScope.of(context).unfocus();
//     isActive = !isActive;
//     setState(() {});
//   }

//   void selectCheck(newIndex) {
//     currentChek = newIndex;
//     context
//         .read<AddCarState>()
//         .selectType(context.read<AddCarState>().typeOfDrives[newIndex]);
//     setState(() {});
//   }

//   @override
//   void initState() {
//     super.initState();
//     final read = context.read<AddCarState>();

//     if (read.selectedCarNumber != null) {
//       carNumController.text = read.selectedCarNumber ?? '';
//     }
//     if (read.selectedVinNumber != null) {
//       vinNumController.text = read.selectedVinNumber ?? '';
//     }
//     if (read.selectedTypeOfDrive != null) {
//       currentChek = read.typeOfDrives.indexOf(read.selectedTypeOfDrive!);
//     }
//   }

//   // static bool validateNumber(String? value) {
//   //   final alphanumeric = RegExp(r'[А-Я]{1}[0-9]{3}[А-Я]{2}[0-9]{2,3}');
//   //   if (!alphanumeric.hasMatch(value!)) {
//   //     return false;
//   //   }
//   //   return true;
//   // }

//   @override
//   void dispose() {
//     carNumController.dispose();
//     vinNumController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final read = context.read<AddCarState>();
//     return GestureDetector(
//       onTap: () {
//         if (isActive) {
//           toggle();
//         }
//       },
//       child: Column(
//         children: <Widget>[
//           Text(
//             'Введите гос и VIN номер\nвашего авто. Укажите дизель\nу вас или бензин.',
//             style:
//                 AppTextStyle.s14w400.copyWith(color: Colors.black, height: 1.7),
//             textAlign: TextAlign.center,
//           ),
//           const SizedBox(height: 77),
//           Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 36),
//             child: Column(
//               children: [
//                 CustomInput(
//                   node: carNumNode,
//                   controller: carNumController,
//                   hintText: 'Введите гос. номер',
//                   onChange: (v) {
//                     // if (validateNumber(v) != false) {
//                     read.selectCarNumber(v.isEmpty ? null : v);
//                     // }
//                   },
//                   formatters: [
//                     LengthLimitingTextInputFormatter(12),
//                     UpperCaseTextFormatter(),
//                     carNumberMask
//                   ],
//                 ),
//                 const SizedBox(height: 30),
//                 CustomInput(
//                   node: vinNumNode,
//                   controller: vinNumController,
//                   hintText: 'Введите VIN номера',
//                   onChange: (v) => read.selectVinNumber(v.isEmpty ? null : v),
//                 ),
//                 const SizedBox(height: 30),
//                 CustomSelect(
//                   title: 'Бензин или дизель?',
//                   values: read.typeOfDrives,
//                   isActive: isActive,
//                   onPressed: () => toggle(),
//                   currentCheck: currentChek,
//                   onTap: (v) => selectCheck(v),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// class AddAutoThird extends StatefulWidget {
//   const AddAutoThird({super.key});

//   @override
//   State<AddAutoThird> createState() => _AddAutoThirdState();
// }

// class _AddAutoThirdState extends State<AddAutoThird> {
//   bool isActive = false;
//   int? currentChek;
//   final controller = TextEditingController();
//   final node = FocusNode();

//   void toggle() {
//     isActive = !isActive;
//     setState(() {});
//   }

//   void selectCheck(newIndex) {
//     final read = context.read<AddCarState>();
//     currentChek = newIndex;
//     read.selectEngineType(read.transmisions[newIndex]);
//     setState(() {});
//   }

//   @override
//   void initState() {
//     final read = context.read<AddCarState>();
//     if (read.selectedEngineType != null) {
//       final index = read.transmisions.indexOf(read.selectedEngineType!);
//       currentChek = index;
//     }
//     if (read.selectedEnginePower != null) {
//       controller.text = read.selectedEnginePower ?? '';
//     }
//     super.initState();
//   }

//   @override
//   void dispose() {
//     controller.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final read = context.read<AddCarState>();
//     return GestureDetector(
//       onTap: () {
//         if (isActive) {
//           toggle();
//         }
//       },
//       child: Column(
//         children: <Widget>[
//           Text(
//             'Какая мощность ДВС\nи какой привод у вашего авто?',
//             style:
//                 AppTextStyle.s14w400.copyWith(color: Colors.black, height: 1.7),
//             textAlign: TextAlign.center,
//           ),
//           const SizedBox(height: 77),
//           Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 36),
//             child: Column(
//               children: [
//                 CustomSelect(
//                   title: 'Выберете привод?',
//                   values: read.transmisions,
//                   isActive: isActive,
//                   onPressed: () => toggle(),
//                   currentCheck: currentChek,
//                   onTap: (v) => selectCheck(v),
//                 ),
//                 const SizedBox(height: 30),
//                 CustomInput(
//                   controller: controller,
//                   node: node,
//                   hintText: 'Впишите мощность ДВС',
//                   onChange: (v) => read.selectEnginePower(v),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// class AddAutoSecond extends StatefulWidget {
//   const AddAutoSecond({
//     Key? key,
//     required this.onScroll,
//   }) : super(key: key);

//   final VoidCallback onScroll;

//   @override
//   State<AddAutoSecond> createState() => _AddAutoSecondState();
// }

// class _AddAutoSecondState extends State<AddAutoSecond> {
//   bool isActiveDown = false;
//   bool hasValidToNext = false;
//   int? currentDown;

//   final brandController = TextEditingController();
//   final brandNode = FocusNode();

//   final modelController = TextEditingController();
//   final modelNode = FocusNode();

//   void toggleDown() {
//     FocusScope.of(context).unfocus();
//     isActiveDown = !isActiveDown;
//     setState(() {});
//   }

//   void selectDown(newIndex) {
//     currentDown = newIndex;
//     context
//         .read<AddCarState>()
//         .selectBody(context.read<AddCarState>().bodyTypes[newIndex].bodyType);
//     setState(() {});
//   }

//   @override
//   void initState() {
//     super.initState();
//     final read = context.read<AddCarState>();
//     brandController.addListener(() async {
//       final query = brandController.text.trim();
//       if (query.isNotEmpty && brandNode.hasFocus) {
//         await Future.delayed(
//           const Duration(seconds: 1),
//           () => read.searchCarBrand(context, query),
//         );

//         read.selectCarBrand(brandController.text, text: brandController.text);

//         debugPrint(read.selectedCarBrand);
//       }
//     });
//     brandNode.addListener(() {
//       if (brandNode.hasFocus &&
//           (read.selectedCarBrand != null && read.selectedCarModel != null)) {
//         widget.onScroll();
//       }
//     });

//     if (read.selectedCarBrand != null) {
//       brandController.text = read.selectedCarBrand ?? '';
//     }
//     if (read.selectedCarBrand != null) {
//       modelController.text = read.selectedCarModel ?? '';
//     }
//     if (read.selectedBodyType != null) {
//       currentDown = read.bodyTypes
//           .map((e) => e.bodyType)
//           .toList()
//           .indexOf(read.selectedBodyType!);
//     }
//   }

//   @override
//   void dispose() {
//     brandController.dispose();
//     modelController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final state = context.watch<AddCarState>();
//     final read = context.read<AddCarState>();
//     final brands = state.carBrands;
//     final keyboardOn = brandNode.hasFocus || modelNode.hasFocus;
//     return Column(
//       children: <Widget>[
//         Text(
//           'Какая марка и модель\nи кузов у вашего авто?',
//           style:
//               AppTextStyle.s14w400.copyWith(color: Colors.black, height: 1.7),
//           textAlign: TextAlign.center,
//         ),
//         AnimatedContainer(
//           duration: kThemeAnimationDuration,
//           height: keyboardOn ? 30 : 70,
//         ),
//         Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 36),
//           child: Column(
//             children: [
//               SearchInput(
//                 controller: brandController,
//                 node: brandNode,
//                 onTap: (i) {
//                   read.selectCarBrand((i.item as CarBrand).name, tapped: true);
//                   brandController.text = (i.item as CarBrand).name;

//                   FocusScope.of(context).unfocus();
//                 },
//                 suggestions: List.generate(
//                   brands.length,
//                   (index) => SearchFieldListItem(
//                     index.toString(),
//                     item: brands[index],
//                     child: Padding(
//                       padding: const EdgeInsets.symmetric(horizontal: 8.0),
//                       child: Text(brands[index].name),
//                     ),
//                   ),
//                 ),
//               ),
//               if (state.selectedCarBrand != null)
//                 Padding(
//                   padding: const EdgeInsets.symmetric(vertical: 30.0),
//                   child: CustomInput(
//                     hintText: 'Выберете модель',
//                     controller: modelController,
//                     node: modelNode,
//                     scrollPadding: 150,
//                     onChange: (v) {
//                       read.selectCarModel(v);
//                     },
//                   ),
//                 ),
//               // Padding(
//               //   padding: const EdgeInsets.symmetric(vertical: 30.0),
//               //   child: SearchInput(
//               //     controller: modelController,
//               //     node: modelNode,
//               //     hint: 'Выберете модель',

//               //     onTap: (i) {
//               //       read.selectCarModel(i.item.toString());

//               //       modelController.text = i.item.toString();
//               //       FocusScope.of(context).unfocus();
//               //     },
//               //     suggestions: List.generate(
//               //       models.length,
//               //       (index) => SearchFieldListItem(
//               //         index.toString(),
//               //         item: models[index],
//               //         child: Padding(
//               //           padding: const EdgeInsets.symmetric(horizontal: 8.0),
//               //           child: Text(models[index]),
//               //         ),x
//               //       ),
//               //     ),
//               //   ),
//               // ),
//               if (state.selectedCarModel != null)
//                 SizedBox(
//                   height: 200,
//                   child: CustomSelect(
//                     title: 'Выберите кузов',
//                     values: state.bodyTypes.map((e) => e.bodyType).toList(),
//                     isActive: isActiveDown,
//                     onPressed: () => toggleDown(),
//                     currentCheck: currentDown,
//                     onTap: (v) => selectDown(v),
//                   ),
//                 ),
//             ],
//           ),
//         ),
//       ],
//     );
//   }
// }

// class UpperCaseTextFormatter extends TextInputFormatter {
//   @override
//   TextEditingValue formatEditUpdate(oldValue, TextEditingValue newValue) =>
//       TextEditingValue(
//           text: newValue.text.toUpperCase(), selection: newValue.selection);
// }
