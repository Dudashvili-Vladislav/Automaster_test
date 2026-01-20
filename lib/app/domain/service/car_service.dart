import 'dart:developer';

import 'package:auto_master/app/data/api_client.dart';
import 'package:auto_master/app/domain/models/car_brand.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class CarService {
  static Future<List<CarBrand>?> findCarBrand(
      BuildContext context, String query) async {
    try {
      final result = await ApiClient().dio(context).post(
            'https://suggestions.dadata.ru/suggestions/api/4_1/rs/suggest/car_brand',
            data: {'query': query},
            options: Options(
              headers: {
                'Authorization': 'Token ${ApiClient.dadataApiKey}',
              },
            ),
          );

      final data = result.data as Map<String, dynamic>;
      final suggestions = data['suggestions'] as List;
      return suggestions.map((e) => CarBrand.fromJson(e['data'])).toList();
    } catch (e) {
      log('ERROR: $e');
    }
    return null;
  }

  static Future<List<String>?> findCarModel(
      BuildContext context, String query) async {
    try {
      final result = await ApiClient().dio(context).post(
            'https://cleaner.dadata.ru/api/v1/clean/vehicle',
            data: [query],
            options: Options(
              headers: {
                "Content-Type": "application/json",
                "Accept": "application/json",
                'Authorization': 'Token ${ApiClient.dadataApiKey}',
                'X-Secret': '5fb879a70f47aa94dbee3e66bffd554e1e25fd5c',
              },
            ),
          );

      final data = result.data as List;

      return data.map((e) => e['model'] as String).toList();
    } on DioError catch (e) {
      log('ERROR: $e');
    } catch (e) {
      log('ERROR: $e');
    }
    return null;
  }
}
