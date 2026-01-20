import 'package:auto_master/app/constatns.dart';
import 'package:auto_master/app/domain/models/customer_car.dart';
import 'package:auto_master/app/domain/service/customer_service.dart';
import 'package:auto_master/app/domain/states/customer/add_car_cubit.dart';
import 'package:auto_master/app/domain/states/customer/profile_state.dart';
import 'package:auto_master/app/ui/screens/profile/pages/add_auto_first_page.dart';
import 'package:auto_master/app/ui/screens/profile/pages/add_auto_pattern.dart';
import 'package:auto_master/app/ui/theme/app_text_style.dart';
import 'package:auto_master/app/ui/widgets/custom_button.dart';
import 'package:auto_master/app/ui/widgets/custom_input.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddAutoLast extends StatelessWidget {
  AddAutoLast({super.key});

  final carNumController = TextEditingController();
  final vinNumController = TextEditingController();

  final carNumNode = FocusNode();
  final vinNumNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    final state = BlocProvider.of<AddCarCubit>(context).state;
    final isRussianCar =
        state.selectedCarNationality == AddAutoFirst.russianCar;
    return AddAutoPattern(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 36),
        child: BlocBuilder<AddCarCubit, CarCubitState>(
          builder: (context, state) => Column(
            children: [
              Text(
                'Введите гос и VIN номер вашего авто.',
                style: AppTextStyle.s14w400
                    .copyWith(color: Colors.black, height: 1.7),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 99),
              CustomInput(
                node: carNumNode,
                controller: carNumController,
                hintText: 'Введите гос. номер',
                onChange: (v) {
                  // if (validateNumber(v) != false) {
                  // read.selectCarNumber(v.isEmpty ? null : v);
                  // print(v.length);
                  if (v.length > 10) {
                    BlocProvider.of<AddCarCubit>(context)
                        .selectCarNumber(v.isEmpty ? null : v);
                  } else {
                    BlocProvider.of<AddCarCubit>(context).selectCarNumber(null);
                  }
                  // }
                },
                formatters: [
                  LengthLimitingTextInputFormatter(13),
                  UpperCaseTextFormatter(),
                  carNumberMask
                ],
              ),
              const SizedBox(height: 30),
              if (!isRussianCar)
                Padding(
                  padding: const EdgeInsets.only(left: 16, bottom: 8),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Без VIN поиск может быть не точным',
                      style: AppTextStyle.s12w400.copyWith(color: Colors.black),
                      textAlign: TextAlign.start,
                    ),
                  ),
                ),
              CustomInput(
                  node: vinNumNode,
                  controller: vinNumController,
                  hintText: 'Введите VIN номера',
                  onChange: (v) {
                    if (v.length == 17) {
                      BlocProvider.of<AddCarCubit>(context).selectVinNumber(v);
                    } else {
                      BlocProvider.of<AddCarCubit>(context)
                          .selectVinNumber(null);
                    }
                  }),
              const Spacer(),
              BlocBuilder<AddCarCubit, CarCubitState>(
                builder: (context, state) {
                  final stateNumberIsValid =
                      state.selectedCarNumber?.isNotEmpty ?? false;

                  final cubit = BlocProvider.of<AddCarCubit>(context);
                  // final isVINvalid =
                  //     state.selectedVinNumber?.isNotEmpty ?? false;
                  final conditions = stateNumberIsValid;
                  return CustomButton(
                    width: 234,
                    height: 47,
                    isLoading: state.isLoading,
                    text: state.isEdit ? 'Изменить авто' : 'Добавить авто',
                    onPressed: conditions
                        ? () async {
                            cubit.setLoading(true);
                            final model = CustomerCarEntity(
                              id: state.id ?? 0,
                              ownerId: state.ownerId ?? 0,
                              model: state.selectedCarModel ?? '',
                              bodyType: state.selectedBodyType!,
                              brand: state.selectedCarBrand!,
                              carNationality: state.selectedCarNationality!,
                              carNumber: state.selectedCarNumber!,
                              enginePower: state.carBaseModification!
                                  .specifications.horsePower
                                  .toString(),
                              engineType: state.selectedEngineType!,
                              typeOfDrive: state.selectedTypeOfDrive!,
                              vinNumber: state.selectedVinNumber ?? '',
                              generation: state.carBaseGeneration?.name ?? '',
                              // (state.carBaseGeneration?.name.isEmpty ??
                              //         true)
                              //     ? '_'
                              //     : state.carBaseGeneration?.name,
                              icon: '',
                            );

                            // await Future.delayed(Duration(seconds: 3));

                            if (state.isEdit) {
                              await CustomerService.editCustomerCar(
                                  context, model);
                            } else {
                              await CustomerService.addCustomerCar(
                                  context, model);
                            }

                            await context
                                .read<CustomerProfileState>()
                                .fetchCars();

                            cubit.setLoading(false);

                            Navigator.of(context)
                                .popUntil((route) => route.isFirst);
                          }
                        : null,
                  );
                },
              ),
              const SizedBox(height: 27),
            ],
          ),
        ),
      ),
    );
  }
}

class UpperCaseTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(oldValue, TextEditingValue newValue) =>
      TextEditingValue(
          text: newValue.text.toUpperCase(), selection: newValue.selection);
}

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
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }