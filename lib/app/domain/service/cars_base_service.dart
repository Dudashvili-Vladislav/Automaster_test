import 'dart:developer';

import 'package:auto_master/app/domain/models/car_base_brand.dart';
import 'package:auto_master/app/domain/models/car_base_configuration.dart';
import 'package:auto_master/app/domain/models/car_base_generation.dart';
import 'package:auto_master/app/domain/models/car_base_model.dart';
import 'package:dio/dio.dart';

class CarsBaseService {
  static const key = 'da86903c1';

  static Future<List<CarBaseBrand>?> getCars(
      // BuildContext context,
      ) async {
    try {
      final result = await Dio().get(
        'https://cars-base.ru/api/cars',
      );

      final data = result.data as List;

      return data.map((e) => CarBaseBrand.fromJson(e)).toList();
      // return [];
    } on DioError catch (e) {
      log('ERROR: ${e.requestOptions.path} $e');
    } catch (e) {
      log('ERROR: $e');
    }

    return null;
  }

  static Future<List<CarBaseModel>?> getModels(
    // BuildContext context,
    CarBaseBrand carBaseBrand,
  ) async {
    try {
      final result = await Dio().get(
        'https://cars-base.ru/api/cars/${carBaseBrand.id}',
      );

      final data = result.data as List;

      return data.map((e) => CarBaseModel.fromJson(e)).toList();
      // return [];
    } on DioError catch (e) {
      log('ERROR: ${e.requestOptions.path} $e');
    } catch (e) {
      log('ERROR: $e');
    }

    return null;
  }

  static Future<List<CarBaseGeneration>?> getGeneration(
    // BuildContext context,
    CarBaseBrand carBaseBrand,
    CarBaseModel carBaseModel,
  ) async {
    try {
      final result = await Dio().get(
          'https://cars-base.ru/api/cars/${carBaseBrand.id}/${carBaseModel.id}',
          queryParameters: {'key': key});

      final data = result.data as List;

      return data.map((e) => CarBaseGeneration.fromJson(e)).toList();
      // return [];
    } on DioError catch (e) {
      log('ERROR: ${e.requestOptions.path} $e');
    } catch (e) {
      log('ERROR: $e');
    }

    return null;
  }

  static Future<List<CarBaseConfiguration>?> getConfigurations(
    // BuildContext context,
    CarBaseBrand carBaseBrand,
    CarBaseModel carBaseModel,
    CarBaseGeneration carBaseGeneration,
  ) async {
    try {
      final result = await Dio().get(
          'https://cars-base.ru/api/cars/${carBaseBrand.id}/${carBaseModel.id}/${carBaseGeneration.id}',
          queryParameters: {'key': key});

      print(result.data);

      final data = result.data as List;

      return data.map((e) => CarBaseConfiguration.fromJson(e)).toList();
      // return [];
    } on DioError catch (e) {
      log('ERROR: ${e.requestOptions.path} ${e.response?.data} $e');
    } catch (e) {
      print('Not dio error');
      log('ERROR: $e');
    }

    return null;
  }
}
