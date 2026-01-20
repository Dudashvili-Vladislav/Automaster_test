import 'package:auto_master/app/domain/models/car_base_brand.dart';
import 'package:auto_master/app/domain/models/car_base_configuration.dart';
import 'package:auto_master/app/domain/models/car_base_generation.dart';
import 'package:auto_master/app/domain/models/car_base_model.dart';
import 'package:auto_master/app/domain/models/car_base_modification.dart';
import 'package:auto_master/app/domain/states/customer/add_car_cubit.dart';
import 'package:auto_master/app/ui/screens/profile/pages/add_auto_last.dart';
import 'package:auto_master/app/ui/screens/profile/pages/add_auto_pattern.dart';
import 'package:auto_master/app/ui/theme/app_text_style.dart';
import 'package:auto_master/app/ui/widgets/custom_button.dart';
import 'package:auto_master/app/ui/widgets/search_input.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:searchfield/searchfield.dart';

class AddAutoSecondPage extends StatelessWidget {
  AddAutoSecondPage({super.key});

  final FocusNode brandNode = FocusNode();
  final FocusNode modelNode = FocusNode();
  final FocusNode genNode = FocusNode();
  final FocusNode configNode = FocusNode();
  final FocusNode modifNode = FocusNode();
  final ScrollController controller = ScrollController();
  final itemKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    controller.addListener(() {
      // print(controller.offset);
    });
    modifNode.addListener(() {
      // print(modifNode.hasFocus);
      // print(controller.hasClients);
      if (modifNode.hasFocus) {
        // print(controller.position.maxScrollExtent);
        // print(controller.position);
        // print(controller.offset);
        Future.delayed(Duration(milliseconds: 500), () {
          controller.animateTo(1488,
              duration: Duration(seconds: 1), curve: Curves.linear);
        });

        // print('animated');
      }
    });
    return AddAutoPattern(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 36),
        child: BlocBuilder<AddCarCubit, CarCubitState>(
          buildWhen: (previous, current) => false,
          builder: (context, state) => Column(
            children: [
              Flexible(
                child: SingleChildScrollView(
                  key: itemKey,
                  controller: controller,
                  child: Column(
                    // padding: EdgeInsets.only(
                    //     bottom: MediaQuery.of(context).viewInsets.bottom),
                    children: [
                      Text(
                        'Какая марка и модель вашего авто?',
                        style: AppTextStyle.s14w400
                            .copyWith(color: Colors.black, height: 1.7),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 42),
                      InputMark(brandNode: brandNode),
                      const SizedBox(height: 16),
                      InputModel(brandNode: modelNode),
                      const SizedBox(height: 16),
                      // InputGeneration(brandNode: genNode),
                      InputGeneration2(node: genNode),
                      const SizedBox(height: 16),
                      InputConfig2(node: configNode),
                      // InputConfiguration(brandNode: configNode),
                      const SizedBox(height: 16),
                      InputModification2(brandNode: modifNode),
                      // InputModification(brandNode: modifNode),
                      // Spacer(),
                      const SizedBox(height: 42),
                      BlocBuilder<AddCarCubit, CarCubitState>(
                        builder: (context, state) => CustomButton(
                          width: 234,
                          height: 47,
                          text: 'Далее',
                          onPressed: state.carBaseModification != null
                              ? () => Navigator.push(
                                    context,
                                    CupertinoPageRoute(
                                      builder: (_) =>
                                          BlocProvider<AddCarCubit>.value(
                                        value: BlocProvider.of<AddCarCubit>(
                                            context),
                                        child: AddAutoLast(),
                                      ),
                                    ),
                                  )
                              : null,
                          isLoading: false,
                        ),
                      ),
                      const SizedBox(height: 19 * 5),
                      const SizedBox(height: 32),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class InputMark extends StatelessWidget {
  const InputMark({super.key, required this.brandNode});

  final FocusNode brandNode;

  @override
  Widget build(BuildContext context) {
    final cubit = BlocProvider.of<AddCarCubit>(context);

    return BlocBuilder<AddCarCubit, CarCubitState>(
      buildWhen: (previous, current) =>
          previous.carBaseBrand != current.carBaseBrand ||
          previous.brandSuggestions != current.brandSuggestions,
      builder: (context, state) => BasicSearhInput<CarBaseBrand>(
        brandNode: brandNode,
        initialText: cubit.state.carBaseBrand?.name ?? '',
        suggestions: state.brandSuggestions,
        // suggestions: () => CarsBaseService.getCars(context),
        generator: (index, item) => SearchFieldListItem<CarBaseBrand>(
          '${item.name} ${item.cyrillicName}',
          item: item,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Text(item.name),
          ),
        ),
        onTap: (i, focus, controller) {
          if (i.item != null) {
            final cbb = i.item! as CarBaseBrand;
            final addCarCubit = BlocProvider.of<AddCarCubit>(context);
            // if (addCarCubit.state.selectedCarNationality
            //         ?.contains(AddAutoFirst.russianCar) ??
            //     false) {
            //   addCarCubit.setMark(cbb.cyrillicName, cbb);
            //   controller.text = cbb.cyrillicName;
            // } else {
            addCarCubit.setMark(cbb.name, cbb, true);
            controller.text = cbb.name;
            // }
          }
          // focus.unfocus();
          FocusScope.of(context).unfocus();
        },
        hint: 'Выберите марку',
      ),
    );
  }
}

class InputModel extends StatelessWidget {
  const InputModel({super.key, required this.brandNode});

  final FocusNode brandNode;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AddCarCubit, CarCubitState>(
      buildWhen: (previous, current) =>
          previous.carBaseBrand != current.carBaseBrand ||
          previous.selectedCarModel != current.selectedCarModel ||
          previous.modelSuggestions != current.modelSuggestions,
      builder: (context, state) {
        if (state.carBaseBrand == null) {
          return const SizedBox();
        }
        // print(state.selectedCarModel);
        print('InputModel ${state.carBaseModel?.name}');
        return BasicSearhInput<CarBaseModel>(
          brandNode: brandNode,
          initialText: state.carBaseModel?.name ?? '',
          suggestions: state.modelSuggestions,
          // () =>
          //     CarsBaseService.getModels(context, state.carBaseBrand!),
          generator: (index, item) => SearchFieldListItem<CarBaseModel>(
            '${item.name} ${item.cyrillicName}',
            item: item,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Text(item.name),
            ),
          ),
          onTap: (i, focus, controller) {
            if (i.item != null) {
              final cbb = i.item! as CarBaseModel;
              final addCarCubit = BlocProvider.of<AddCarCubit>(context);
              // if (addCarCubit.state.selectedCarNationality
              //         ?.contains(AddAutoFirst.russianCar) ??
              //     false) {
              //   addCarCubit.setModel(cbb.cyrillicName, cbb);
              //   controller.text = cbb.cyrillicName;
              // } else {
              print('setModel ${cbb.name}');
              addCarCubit.setModel(cbb.name, cbb, true);
              controller.text = cbb.name;
              // }
            }

            FocusScope.of(context).unfocus();
          },
          hint: 'Выберите модель',
        );
      },
    );
  }
}

// class InputGeneration extends StatelessWidget {
//   const InputGeneration({super.key, required this.brandNode});

//   final FocusNode brandNode;

//   @override
//   Widget build(BuildContext context) {
//     return BlocBuilder<AddCarCubit, CarCubitState>(
//       buildWhen: (previous, current) =>
//           previous.carBaseModel != current.carBaseModel ||
//           previous.carBaseGeneration != current.carBaseGeneration ||
//           previous.genSuggestions != current.genSuggestions,
//       builder: (context, state) {
//         if (state.carBaseBrand == null || state.carBaseModel == null) {
//           return const SizedBox();
//         }

//         print(
//             'InputGeneration build ${state.carBaseModel?.name} ${state.carBaseModel?.id}');
//         return BasicSearhInput<CarBaseGeneration>(
//           brandNode: brandNode,
//           initialText: state.carBaseGeneration?.name ?? '',
//           suggestions: state.genSuggestions,
//           // () => CarsBaseService.getGeneration(
//           //     context, state.carBaseBrand!, state.carBaseModel!),
//           generator: (index, item) {
//             item as CarBaseGeneration;
//             return SearchFieldListItem<CarBaseGeneration>(
//               item.name,
//               item: item,
//               child: Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 8.0),
//                 child: Text(item.name),
//               ),
//             );
//           },
//           onTap: (i, focus, controller) {
//             if (i.item != null) {
//               final cbb = i.item! as CarBaseGeneration;
//               final addCarCubit = BlocProvider.of<AddCarCubit>(context);
//               addCarCubit.setGeneration(cbb);
//               controller.text = cbb.name;
//               print('set generation id = ${cbb.id}');
//             }

//             FocusScope.of(context).unfocus();
//           },
//           hint: 'Выберите поколение',
//         );
//       },
//     );
//   }
// }

// class InputConfiguration extends StatelessWidget {
//   const InputConfiguration({super.key, required this.brandNode});

//   final FocusNode brandNode;

//   @override
//   Widget build(BuildContext context) {
//     return BlocBuilder<AddCarCubit, CarCubitState>(
//       buildWhen: (previous, current) =>
//           previous.carBaseGeneration != current.carBaseGeneration ||
//           previous.carBaseConfiguration != current.carBaseConfiguration ||
//           previous.configSuggestions != current.configSuggestions,
//       builder: (context, state) {
//         if (state.carBaseBrand == null ||
//             state.carBaseModel == null ||
//             state.carBaseGeneration == null) {
//           return const SizedBox();
//         }
//         print('InputConfiguration genId=${state.carBaseGeneration?.id}');
//         return BasicSearhInput<CarBaseConfiguration>(
//           brandNode: brandNode,
//           initialText: state.carBaseConfiguration?.bodyType ?? '',
//           suggestions: state.configSuggestions,
//           // () => CarsBaseService.getConfigurations(
//           //     context,
//           //     state.carBaseBrand!,
//           //     state.carBaseModel!,
//           //     state.carBaseGeneration!),
//           generator: (index, item) {
//             item as CarBaseConfiguration;
//             return SearchFieldListItem<CarBaseConfiguration>(
//               item.bodyType,
//               item: item,
//               child: Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 8.0),
//                 child: Text(item.bodyType),
//               ),
//             );
//           },
//           onTap: (i, focus, controller) {
//             if (i.item != null) {
//               final cbb = i.item! as CarBaseConfiguration;
//               final addCarCubit = BlocProvider.of<AddCarCubit>(context);
//               addCarCubit.setConfiguration(cbb);
//               controller.text = cbb.bodyType;
//             }

//             FocusScope.of(context).unfocus();
//           },
//           hint: 'Выберите конфигурацию',
//         );
//       },
//     );
//   }
// }

class InputModification extends StatelessWidget {
  const InputModification({super.key, required this.brandNode});

  final FocusNode brandNode;

  static String toText(CarBaseModification item) {
    return '${item.specifications.horsePower} л.с. ${item.specifications.drive} привод ${item.specifications.engineType} ';
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AddCarCubit, CarCubitState>(
      buildWhen: (previous, current) =>
          previous.carBaseConfiguration != current.carBaseConfiguration ||
          previous.carBaseModification != current.carBaseModification ||
          previous.modSuggestions != current.modSuggestions,
      builder: (context, state) {
        if (state.carBaseConfiguration == null) {
          return const SizedBox();
        }
        print('InputModification ${state.carBaseConfiguration?.id}');
        return BasicSearhInput<CarBaseModification>(
          brandNode: brandNode,
          initialText: state.carBaseModification != null
              ? toText(state.carBaseModification!)
              : '',
          suggestions: state.modSuggestions,
          // () =>
          //     Future.value(state.carBaseConfiguration?.modifications ?? []),
          generator: (index, item) {
            item as CarBaseModification;
            return SearchFieldListItem<CarBaseModification>(
              toText(item),
              item: item,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Text(toText(item)),
              ),
            );
          },
          onTap: (i, focus, controller) {
            if (i.item != null) {
              final cbb = i.item! as CarBaseModification;
              final addCarCubit = BlocProvider.of<AddCarCubit>(context);
              addCarCubit.setModification(cbb);
              controller.text = toText(cbb);
            }

            FocusScope.of(context).unfocus();
          },
          hint: 'Выберите модификации',
        );
      },
    );
  }
}

class BasicSearhInput<T> extends StatelessWidget {
  const BasicSearhInput({
    super.key,
    required this.suggestions,
    required this.generator,
    required this.onTap,
    required this.hint,
    required this.initialText,
    required this.brandNode,
    // required this.listener,
  });

  final String initialText;
  final String hint;
  final List<T> suggestions;
  final SearchFieldListItem<Object?> Function(int, dynamic) generator;
  final dynamic Function(
      SearchFieldListItem<Object?>, FocusNode, TextEditingController) onTap;
  final FocusNode brandNode;
  // final void Function(TextEditingController, List<T>) listener;

  // @override
  // State<StatefulWidget> createState() => _BasicInputState<T>();

  @override
  Widget build(BuildContext context) {
    final controller = TextEditingController(
      text: initialText,
    );
    return SearchInput(
      hint: hint,
      controller: controller,
      node: brandNode,
      onTap: (i) => onTap(i, brandNode, controller),
      suggestions: List.generate(
        suggestions.length,
        (index) => generator(index, suggestions[index]),
      ),
    );
  }
}

class InputConfig2 extends StatelessWidget {
  const InputConfig2({required this.node, super.key});

  final FocusNode node;

  static String toText(CarBaseConfiguration item) {
    return '${item.bodyType} ${item.steertingWheel.toLowerCase()} руль';
  }
  // final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    final addCarCubit = BlocProvider.of<AddCarCubit>(context);
    return BlocBuilder<AddCarCubit, CarCubitState>(
      // buildWhen: (previous, current) {
      //   pr
      //     return previous.carBaseGeneration != current.carBaseGeneration ||
      //     previous.carBaseConfiguration != current.carBaseConfiguration ||
      //     previous.configSuggestions != current.configSuggestions;},
      builder: (context, state) {
        if (state.carBaseBrand == null ||
            state.carBaseModel == null ||
            state.carBaseGeneration == null) {
          return const SizedBox();
        }
        print(
            'Build config choice 2 configsLen=${state.configSuggestions.length}}');
        return GestureDetector(
          onTap: () {
            showDialog(
              context: context,
              builder: (_) => Dialog(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
                  child: ListView.separated(
                    shrinkWrap: true,
                    separatorBuilder: (final _, final __) =>
                        const Divider(height: 2),
                    itemCount: state.configSuggestions.length,
                    itemBuilder: (final context, final index) {
                      final option = state.configSuggestions[index];
                      return InkWell(
                        onTap: () {
                          addCarCubit.setConfiguration(option);
                          Navigator.pop(context);
                          // controller.text = option.bodyType;
                        },
                        child: SizedBox(
                          height: 42,
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(toText(option)),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            );
          },
          child: SearchInput(
            node: node,
            enabled: false,
            hint: 'Выберите конфигурацию',
            controller: TextEditingController(
                text: state.carBaseConfiguration != null
                    ? toText(state.carBaseConfiguration!)
                    : null),
          ),
        );
      },
    );
  }
}

class InputGeneration2 extends StatelessWidget {
  const InputGeneration2({required this.node, super.key});

  final FocusNode node;

  static String toText(CarBaseGeneration? item) {
    if (item != null) {
      if (item.name.trim().isEmpty) {
        return 'I';
      } else {
        return item.name;
      }
    } else {
      return '';
    }
  }

  // final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    final addCarCubit = BlocProvider.of<AddCarCubit>(context);
    return BlocBuilder<AddCarCubit, CarCubitState>(
      // buildWhen: (previous, current) {
      //   pr
      //     return previous.carBaseGeneration != current.carBaseGeneration ||
      //     previous.carBaseConfiguration != current.carBaseConfiguration ||
      //     previous.configSuggestions != current.configSuggestions;},
      builder: (context, state) {
        if (state.carBaseBrand == null || state.carBaseModel == null) {
          return const SizedBox();
        }
        print('Build InputGeneration2 len=${state.genSuggestions.length}}');
        return GestureDetector(
          onTap: () {
            // if (state.genSuggestions.length < 2) {
            //   return;
            // }
            showDialog(
              context: context,
              builder: (_) => Dialog(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
                  child: ListView.separated(
                    shrinkWrap: true,
                    separatorBuilder: (final _, final __) =>
                        const Divider(height: 2),
                    itemCount: state.genSuggestions.length,
                    itemBuilder: (final context, final index) {
                      final option = state.genSuggestions[index];
                      return InkWell(
                        onTap: () {
                          addCarCubit.setGeneration(option);
                          Navigator.pop(context);
                          // controller.text = option.bodyType;
                        },
                        child: SizedBox(
                          height: 42,
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(toText(option)),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            );
          },
          child: SearchInput(
            node: node,
            enabled: false,
            hint: 'Выберите поколение',
            controller: TextEditingController(
              text: toText(state.carBaseGeneration),
            ),
          ),
        );
      },
    );
  }
}

class InputModification2 extends StatelessWidget {
  const InputModification2({required this.brandNode, super.key});

  final FocusNode brandNode;

  static String toText(CarBaseModification item) {
    return '${item.specifications.horsePower} л.с. ${item.specifications.drive} привод ${item.specifications.engineType} ';
  }

  @override
  Widget build(BuildContext context) {
    final addCarCubit = BlocProvider.of<AddCarCubit>(context);
    return BlocBuilder<AddCarCubit, CarCubitState>(
      // buildWhen: (previous, current) =>
      //     previous.carBaseConfiguration != current.carBaseConfiguration ||
      //     previous.carBaseModification != current.carBaseModification ||
      //     previous.modSuggestions != current.modSuggestions &&
      //         current.carBaseModification != previous.carBaseModification,
      builder: (context, state) {
        if (state.carBaseConfiguration == null) {
          return const SizedBox();
        }
        return GestureDetector(
          onTap: () {
            showDialog(
              context: context,
              builder: (_) => Dialog(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
                  child: ListView.separated(
                    shrinkWrap: true,
                    separatorBuilder: (final _, final __) =>
                        const Divider(height: 2),
                    itemCount: state.modSuggestions.length,
                    itemBuilder: (final context, final index) {
                      final option = state.modSuggestions[index];
                      return InkWell(
                        onTap: () {
                          addCarCubit.setModification(option);
                          Navigator.pop(context);
                          // controller.text = option.bodyType;
                        },
                        child: SizedBox(
                          height: 42,
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(toText(option)),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            );
          },
          child: SearchInput(
            node: brandNode,
            enabled: false,
            hint: 'Выберите модификацию',
            controller: TextEditingController(
                text: state.carBaseModification != null
                    ? toText(state.carBaseModification!)
                    : null),
          ),
        );
        // print('InputModification ${state.carBaseConfiguration?.id}');
        // return BasicSearhInput<CarBaseModification>(
        //   brandNode: brandNode,
        //   initialText: state.carBaseModification != null
        //       ? toText(state.carBaseModification!)
        //       : '',
        //   suggestions: state.modSuggestions,
        //   // () =>
        //   //     Future.value(state.carBaseConfiguration?.modifications ?? []),
        //   generator: (index, item) {
        //     item as CarBaseModification;
        //     return SearchFieldListItem<CarBaseModification>(
        //       toText(item),
        //       item: item,
        //       child: Padding(
        //         padding: const EdgeInsets.symmetric(horizontal: 8.0),
        //         child: Text(toText(item)),
        //       ),
        //     );
        //   },
        //   onTap: (i, focus, controller) {
        //     if (i.item != null) {
        //       final cbb = i.item! as CarBaseModification;
        //       final addCarCubit = BlocProvider.of<AddCarCubit>(context);
        //       addCarCubit.setModification(cbb);
        //       controller.text = toText(cbb);
        //     }

        //     FocusScope.of(context).unfocus();
        //   },
        //   hint: 'Выберите модификации',
        // );
      },
    );
  }
}

// class _BasicInputState<T> extends State<BasicSearhInput> {
//   List<T> suggestions = [];
//   final brandNode = FocusNode();

//   @override
//   void initState() {
//     // controller.addListener(() {
//     //   // widget.listener(controller, suggestions);
//     // });
//     _loadData();
//     super.initState();
//   }


//   @override
//   didChangeDependencies() {
//     print('didChangeDependencies ' + widget.hint);
//     super.didChangeDependencies();
//   }

//   Future<void> _loadData() async {
//     final res = await widget.suggestions() as List<T>?;
//     print('_loadData ' + widget.hint + ' ' + (res?.length.toString() ?? ''));
//     if (res != null) {
//       setState(() {
//         suggestions = res;
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final controller = TextEditingController(
//       text: widget.initialText,
//     );
//     return SearchInput(
//       hint: widget.hint,
//       controller: controller,
//       node: brandNode,
//       onTap: (i) => widget.onTap(i, brandNode, controller),
//       suggestions: List.generate(
//         suggestions.length,
//         (index) => widget.generator(index, suggestions[index]),
//       ),
//     );
//   }
// }
