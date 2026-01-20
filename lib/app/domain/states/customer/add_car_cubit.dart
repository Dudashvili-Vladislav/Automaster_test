import 'package:auto_master/app/domain/models/body_type.dart';
import 'package:auto_master/app/domain/models/car_base_brand.dart';
import 'package:auto_master/app/domain/models/car_base_configuration.dart';
import 'package:auto_master/app/domain/models/car_base_generation.dart';
import 'package:auto_master/app/domain/models/car_base_model.dart';
import 'package:auto_master/app/domain/models/car_base_modification.dart';
import 'package:auto_master/app/domain/models/customer_car.dart';
import 'package:auto_master/app/domain/service/cars_base_service.dart';
import 'package:auto_master/app/domain/service/customer_service.dart';
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'add_car_cubit.g.dart';

@CopyWith()
class CarCubitState {
  final String? selectedCarNationality;
  final String? selectedCarBrand;
  final String? selectedCarModel;
  final String? selectedCarNumber;
  final String? selectedVinNumber;
  final String? selectedBodyType;
  final String? selectedTypeOfDrive;
  final String? selectedEnginePower;
  final String? selectedEngineType;

  final CarBaseBrand? carBaseBrand;
  final CarBaseModel? carBaseModel;
  final CarBaseGeneration? carBaseGeneration;
  final CarBaseModification? carBaseModification;
  final CarBaseConfiguration? carBaseConfiguration;

  final List<CarBaseBrand> brandSuggestions;
  final List<CarBaseModel> modelSuggestions;
  final List<CarBaseGeneration> genSuggestions;
  final List<CarBaseConfiguration> configSuggestions;
  final List<CarBaseModification> modSuggestions;

  final bool isEdit;
  final int? id;
  final int? ownerId;

  final bool isLoading;

  CarCubitState({
    required this.carBaseBrand,
    required this.carBaseModel,
    required this.carBaseGeneration,
    required this.carBaseModification,
    required this.carBaseConfiguration,
    required this.selectedBodyType,
    required this.selectedCarBrand,
    required this.selectedCarModel,
    required this.selectedCarNationality,
    required this.selectedCarNumber,
    required this.selectedEnginePower,
    required this.selectedEngineType,
    required this.selectedTypeOfDrive,
    required this.selectedVinNumber,
    required this.brandSuggestions,
    required this.configSuggestions,
    required this.genSuggestions,
    required this.modSuggestions,
    required this.modelSuggestions,
    required this.isEdit,
    required this.id,
    required this.ownerId,
    required this.isLoading,
  });

  CarCubitState.fromCar(CustomerCarEntity car)
      : selectedCarNationality = car.carNationality,
        selectedCarBrand = car.brand,
        selectedCarModel = car.model,
        selectedCarNumber = car.carNumber,
        selectedVinNumber = car.vinNumber,
        selectedBodyType = car.bodyType,
        selectedTypeOfDrive = car.typeOfDrive,
        selectedEnginePower = car.enginePower,
        selectedEngineType = car.engineType,
        carBaseBrand = null,
        carBaseModel = null,
        carBaseGeneration = null,
        carBaseModification = null,
        carBaseConfiguration = null,
        brandSuggestions = [],
        configSuggestions = [],
        genSuggestions = [],
        modSuggestions = [],
        modelSuggestions = [],
        id = car.id,
        ownerId = car.ownerId,
        isLoading = false,
        isEdit = true;

  CarCubitState.empty()
      : selectedCarNationality = null,
        selectedCarBrand = null,
        selectedCarModel = null,
        selectedCarNumber = null,
        selectedVinNumber = null,
        selectedBodyType = null,
        selectedTypeOfDrive = null,
        selectedEnginePower = null,
        selectedEngineType = null,
        carBaseBrand = null,
        carBaseModel = null,
        carBaseGeneration = null,
        carBaseModification = null,
        carBaseConfiguration = null,
        brandSuggestions = [],
        configSuggestions = [],
        genSuggestions = [],
        modSuggestions = [],
        modelSuggestions = [],
        id = null,
        ownerId = null,
        isLoading = false,
        isEdit = false;
}

class AddCarCubit extends Cubit<CarCubitState> {
  static const drives = ['Передний привод', 'Задний привод', 'Полный привод'];
  static const engineTypes = ['Бензин', 'Дизель'];

  AddCarCubit(CustomerCarEntity? car, BuildContext context)
      : super(
          car != null ? CarCubitState.fromCar(car) : CarCubitState.empty(),
        ) {
    buildBrandSuggestions();
    loadBodies(context);
    // loadBodies
  }

  List<BodyTypes> bodyTypes = [];

  void setLoading(bool value) {
    emit(state.copyWith(isLoading: value));
  }

  Future<void> loadBodies(BuildContext context) async {
    final res = await CustomerService.getBodyList(context);
    if (res != null) {
      bodyTypes = res;
      final bodyNames = bodyTypes.map((e) => e.bodyType);
      bodyNames.forEach((e) => print(e));
    }
  }

  Future<void> buildBrandSuggestions() async {
    final brandS = await CarsBaseService.getCars();
    emit(state.copyWith(brandSuggestions: brandS));

    if (state.selectedCarBrand != null && brandS != null) {
      final currentMark = state.selectedCarBrand!.toLowerCase();
      for (final mark in brandS) {
        if (mark.cyrillicName.toLowerCase() == currentMark ||
            mark.name.toLowerCase() == currentMark) {
          setMark(mark.name, mark, false);
        }
      }
    }
  }

  Future<void> buildModelSuggestions() async {
    final models = await CarsBaseService.getModels(state.carBaseBrand!);
    emit(state.copyWith(modelSuggestions: models));

    if (state.selectedCarModel != null && models != null) {
      final currentModel = state.selectedCarModel!.toLowerCase();
      for (final model in models) {
        if (model.cyrillicName.toLowerCase() == currentModel ||
            model.name.toLowerCase() == currentModel) {
          setModel(model.name, model, false);
        }
      }
    }
  }

  Future<void> buildGenSuggestions() async {
    final gens = await CarsBaseService.getGeneration(
      state.carBaseBrand!,
      state.carBaseModel!,
    );
    emit(state.copyWith(genSuggestions: gens));

    if (gens?.length == 1) {
      setGeneration(gens!.first);
    }
  }

  Future<void> buildConfigSuggestions() async {
    final configs = await CarsBaseService.getConfigurations(
      state.carBaseBrand!,
      state.carBaseModel!,
      state.carBaseGeneration!,
    );

    // if (state.selectedCarConfiguration != null) {
    //   currentConfig = state.selectedCarConfiguration!.toLowerCase();
    // }

    print('buildConfigSuggestions ${configs?.length}');

    emit(state.copyWith(configSuggestions: configs));

    if (configs?.length == 1) {
      setConfiguration(configs!.first);
    }
  }

  Future<void> buildModificationsSuggestions() async {
    final squashMod = <CarBaseModification>[];
    state.carBaseConfiguration!.modifications.forEach((element) {
      bool squashAlreadyHas = false;
      for (final mod in squashMod) {
        if (mod.specifications.drive == element.specifications.drive &&
            mod.specifications.engineType ==
                element.specifications.engineType &&
            mod.specifications.horsePower ==
                element.specifications.horsePower) {
          squashAlreadyHas = true;
        }
      }
      if (!squashAlreadyHas) {
        squashMod.add(element);
      }
    });

    emit(state.copyWith(modSuggestions: squashMod));

    if (squashMod.length == 1) {
      setModification(squashMod.first);
    }
  }

  void selectNationality(String nationality) {
    // state.selectedCarNationality = nationality;
    emit(state.copyWith(selectedCarNationality: nationality));
  }

  void setMark(final String markName, final CarBaseBrand carBaseBrand,
      final bool clear) {
    if (clear) {
      emit(state.copyWith(
        selectedCarBrand: markName.toUpperCase(),
        selectedCarModel: null,
        carBaseModel: null,
        carBaseGeneration: null,
        carBaseConfiguration: null,
        carBaseModification: null,
        carBaseBrand: carBaseBrand,
      ));
    } else {
      emit(state.copyWith(
        selectedCarBrand: markName.toUpperCase(),
        carBaseBrand: carBaseBrand,
      ));
    }
    buildModelSuggestions();
  }

  void setModel(final String modelName, final CarBaseModel carBaseModel,
      final bool clear) {
    if (clear) {
      emit(state.copyWith(
        selectedCarModel: modelName.toUpperCase(),
        carBaseModel: carBaseModel,
        carBaseGeneration: null,
        carBaseConfiguration: null,
        carBaseModification: null,
      ));
    } else {
      emit(state.copyWith(
        selectedCarModel: modelName.toUpperCase(),
        carBaseModel: carBaseModel,
      ));
    }
    // print('set model ${state.selectedCarModel} ${state.carBaseModel?.name}');
    buildGenSuggestions();
  }

  void setGeneration(final CarBaseGeneration carBaseGeneration) {
    emit(state.copyWith(
      carBaseGeneration: carBaseGeneration,
      carBaseConfiguration: null,
      carBaseModification: null,
    ));
    buildConfigSuggestions();
  }

  void setConfiguration(final CarBaseConfiguration carBaseConfiguration) {
    String chosenBodyType = '';
    final chosenCarBase = carBaseConfiguration.bodyType.toLowerCase();
    print('setConfiguration=======================================');
    print('Try find match with: $chosenCarBase');
    for (final bt in bodyTypes) {
      // print(bt.bodyType.toLowerCase());
      if (chosenCarBase.contains(bt.bodyType.toLowerCase())) {
        chosenBodyType = bt.bodyType;
        print('Found $chosenBodyType');
      }
    }
    if (chosenBodyType.isEmpty) {
      chosenBodyType = 'Седан';
    }
    print('chosenBodyType=$chosenBodyType');
    print('setConfiguration=======================================');

    emit(state.copyWith(
      selectedBodyType: chosenBodyType,
      carBaseConfiguration: carBaseConfiguration,
      carBaseModification: null,
    ));
    buildModificationsSuggestions();
  }

  void setModification(final CarBaseModification carBaseModification) {
    String chosenDrive = '';
    print('========================================');
    print(carBaseModification.specifications.drive);
    for (final d in drives) {
      if (d
          .toLowerCase()
          .contains(carBaseModification.specifications.drive.toLowerCase())) {
        chosenDrive = d;
        print('Found chosenDrive $chosenDrive');
      }
    }

    String engineType = '';
    print(carBaseModification.specifications.engineType);
    for (final d in engineTypes) {
      if (carBaseModification.specifications.engineType
          .toLowerCase()
          .contains(d.toLowerCase())) {
        engineType = d;
        print('Found engineType $engineType');
      }
    }
    emit(state.copyWith(
      selectedEngineType: engineType,
      selectedTypeOfDrive: chosenDrive,
      carBaseModification: carBaseModification,
    ));
  }

  void selectVinNumber(final String? vin) {
    emit(state.copyWith(selectedVinNumber: vin));
  }

  void selectCarNumber(final String? number) {
    emit(state.copyWith(selectedCarNumber: number));
  }
}
