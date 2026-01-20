// ignore_for_file: use_build_context_synchronously

import 'dart:developer';
import 'dart:io';

import 'package:auto_master/app/data/api_client.dart';
import 'package:auto_master/app/domain/models/address.dart';
import 'package:auto_master/app/domain/models/master.dart';
import 'package:auto_master/app/domain/models/master_orders_entity.dart';
import 'package:auto_master/app/ui/utils/get_token.dart';
import 'package:auto_master/app/ui/utils/pick_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class MasterService {
  static Future<String?> changeRoleToCustomer(BuildContext context) async {
    try {
      final token = await getToken(context);
      final response = await ApiClient().dio(context).post(
            '/mobil/master/profile/change_role',
            options: Options(
              headers: {'Authorization': token},
            ),
          );

      return response.data;
    } catch (e) {
      log('ERROR: $e');
    }
    return null;
  }

  static Future<bool> deleteMaster(BuildContext context) async {
    try {
      final token = await getToken(context);
      final response = await ApiClient().dio(context).post(
            '/mobil/master/profile/delete_master',
            options: Options(
              headers: {'Authorization': token},
            ),
          );

      return response.statusCode == 200;
    } catch (e) {
      log('ERROR: $e');
      return false;
    }
  }

  static Future<bool> deleteMasterAvatar(BuildContext context) async {
    try {
      final token = await getToken(context);
      final response = await ApiClient().dio(context).post(
            '/mobil/master/profile/del_master_avatar',
            options: Options(
              headers: {'Authorization': token},
            ),
          );

      return response.statusCode == 200;
    } catch (e) {
      log('ERROR: $e');
      return false;
    }
  }

  static Future<bool> editMasterData(
    BuildContext context,
    Map<String, dynamic> params,
  ) async {
    try {
      final token = await getToken(context);
      await ApiClient().dio(context).post(
            '/mobil/master/profile/edit_master_datos',
            queryParameters: params,
            options: Options(
              headers: {'Authorization': token},
            ),
          );
      return true;
    } catch (e) {
      return false;
    }
  }

  static Future<void> setMasterAvatar(
      BuildContext context, PickImageState file) async {
    try {
      final token = await getToken(context);
      FormData data = FormData.fromMap({
        "masterAvatar": MultipartFile.fromBytes(
          file.data,
          filename: DateTime.now().toIso8601String(),
        ),
      });
      await ApiClient().dio(context).post(
            '/mobil/master/profile/set_master_avatar',
            data: data,
            options: Options(
              headers: {'Authorization': token},
            ),
          );
    } catch (e) {
      log('ERROR: $e');
    }
  }

  static Future<void> setResponse(
      BuildContext context, String cost, String orderId) async {
    try {
      final token = await getToken(context);

      await ApiClient().dio(context).post(
            '/mobil/master/order/set_response',
            queryParameters: {
              'cost': cost,
              'orderId': orderId,
            },
            options: Options(
              headers: {'Authorization': token},
            ),
          );
    } catch (e) {
      log('ERROR: $e');
    }
  }

  static Future<MasterOrdersEntity?> getOrders(BuildContext context) async {
    try {
      final token = await getToken(context);

      print(token);

      final response = await ApiClient().dio(context).get(
            '/mobil/master/order/get_order_section_model',
            options: Options(
              headers: {'Authorization': token},
            ),
          );

      final json = response.data as Map<String, dynamic>;
      final res = MasterOrdersEntity.fromJson(json);
      print(
          'Got orders ${res.activeOrders.length} ${res.inProgressOrders.length} ${res.completedOrders.length} ');
      return res;
    } catch (e) {
      log('ERROR: $e');
    }

    return null;
  }

  static Future<MasterOrdersEntity?> getOrdersNoLogs(
      BuildContext context) async {
    try {
      final token = await getToken(context);
      final dio = Dio(
        BaseOptions(baseUrl: ApiClient.baseUrl),
      );

      final response = await dio.get(
        '/mobil/master/order/get_order_section_model',
        options: Options(
          headers: {'Authorization': token},
        ),
      );

      final json = response.data as Map<String, dynamic>;
      return MasterOrdersEntity.fromJson(json);
    } catch (e) {
      log('ERROR: $e');
    }

    return null;
  }

  static Future<bool> cancelOrder(BuildContext context, String orderId) async {
    try {
      final token = await getToken(context);

      print(token);

      final response = await ApiClient()
          .dio(context)
          .post('/mobil/master/order/cancel_order',
              options: Options(
                headers: {'Authorization': token},
              ),
              queryParameters: {
            'orderId': orderId,
          });

      return response.statusCode == 200 || response.statusCode == 201;
    } catch (e) {
      log('ERROR: $e');
    }

    return false;
  }

  static Future<MasterEntity?> getMaster(BuildContext context) async {
    try {
      final token = await getToken(context);
      final response = await ApiClient().dio(context).get(
            '/mobil/master/profile/get_master_info',
            options: Options(
              headers: {'Authorization': token},
            ),
          );

      final json = response.data as Map<String, dynamic>;
      return MasterEntity.fromJson(json);
    } catch (e) {
      log('ERROR: $e');
    }

    return null;
  }

  static Future<List<Address>?> searchAdress(
      BuildContext context, String query) async {
    try {
      final response = await ApiClient().dio(context).post(
            'https://suggestions.dadata.ru/suggestions/api/4_1/rs/suggest/address',
            data: {'query': query},
            options: Options(
              headers: {
                'Authorization':
                    "Token 18a3e43226a851c1dadc16f9c321e4b7572f1615",
              },
            ),
          );

      final data = response.data as Map<String, dynamic>;
      final suggestions = data['suggestions'] as List;
      return suggestions.map((e) => Address.fromJson(e)).toList();
    } catch (e) {
      log("ERROR city: $e");
      return null;
    }
  }
}
