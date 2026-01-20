import 'dart:developer';

import 'package:auto_master/app/data/api_client.dart';
import 'package:auto_master/app/data/app_interceptor.dart';
import 'package:auto_master/app/domain/models/customer_auth_entity.dart';
import 'package:auto_master/app/domain/models/spec.dart';
import 'package:auto_master/app/domain/models/support_entity.dart';
import 'package:auto_master/app/ui/utils/show_message.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class AuthService {
  static Future<String?> checkPhone(BuildContext context, String phone) async {
    dynamic response;
    try {
      response = await ApiClient().dio(context).post(
        '/check_phone',
        queryParameters: {"phone": phone},
      );

      return response.statusCode.toString();
    } catch (e) {
      if (e is BadRequestException) {
        return e.response?.statusCode.toString();
      }
      log('ERROR in checkPhone: $e');
    }
    return response?.statusCode.toString();
  }

  // Восстанавливаем метод getCode
  static Future<String?> getCode(BuildContext context, String phone) async {
    try {
      final response = await ApiClient().dio(context).post(
        '/mobil/get_code',
        queryParameters: {"phone": phone},
      );

      return response.data;
    } catch (e) {
      log('ERROR in getCode: $e');
      showMessage('Не удалось запросить звонок по указанному номеру');
      return null;
    }
  }

  // Восстанавливаем метод checkCode
  static Future<String?> checkCode(
      BuildContext context,
      String phone,
      String code,
      ) async {
    try {
      final response = await ApiClient().dio(context).post(
        '/mobil/check_code',
        queryParameters: {
          "phone": phone,
          "code": code,
        },
      );

      return response.statusCode.toString();
    } catch (e) {
      log('ERROR in checkCode: $e');
      return null;
    }
  }

  // Метод для проверки кода и получения данных пользователя
  static Future<CustomerAuthEntity?> verifyCode(
      BuildContext context, {
        required String phone,
        required String code,
      }) async {
    try {
      final response = await ApiClient().dio(context).post(
        '/mobil/verify_code',
        queryParameters: {
          "phone": phone,
          "code": code,
        },
      );

      final json = response.data as Map<String, dynamic>;
      final res = CustomerAuthEntity.fromJson(json);

      if (res.status == 'Banned') {
        showMessage('Аккаунт заблокирован');
        return null;
      }

      return res;
    } catch (e) {
      log('ERROR in verifyCode: $e');
      showMessage('Неверный код');
      return null;
    }
  }

  static Future<String?> getSMSCode(BuildContext context, String phone) async {
    try {
      final response = await ApiClient().dio(context).post(
        '/mobil/get_sms_code',
        queryParameters: {"phone": phone},
      );

      return response.data;
    } catch (e) {
      log('ERROR in getSMSCode: $e');
      showMessage('Не удалось запросить СМС по указанному номеру');
      return null;
    }
  }

  static Future<bool> getRole(BuildContext context, String phone) async {
    try {
      final response = await ApiClient().dio(context).get(
        '/mobil/get_role',
        queryParameters: {"phone": phone},
      );

      return response.data == 'CUSTOMER';
    } catch (e) {
      log('ERROR in getRole: $e');
    }

    return true;
  }

  static Future<CustomerAuthEntity?> registerCustomer(
      BuildContext context, {
        required String phone,
        required String name,
        required String password,
        String? pushToken,
      }) async {
    try {
      final response = await ApiClient().dio(context).post(
        '/mobil/reg_new_customer',
        queryParameters: {
          "phone": phone,
          "name": name,
          "password": password,
          "pushToken": pushToken,
        },
      );
      final json = response.data as Map<String, dynamic>;
      return CustomerAuthEntity.fromJson(json);
    } catch (e) {
      log('ERROR in registerCustomer: $e');
    }
    return null;
  }

  static Future<CustomerAuthEntity?> registerMaster(
      BuildContext context, Map<String, dynamic> params) async {
    try {
      final response = await ApiClient().dio(context).post(
        '/mobil/reg_new_master',
        queryParameters: params,
      );
      final json = response.data as Map<String, dynamic>;
      return CustomerAuthEntity.fromJson(json);
    } catch (e) {
      log('ERROR in registerMaster: $e');
      Fluttertoast.showToast(msg: 'Ошибка при регистрации. $e');
    }
    return null;
  }


  // Оставляем метод login, поскольку он может использоваться в других частях приложения
  static Future<CustomerAuthEntity?> login(
      BuildContext context, {
        required String phone,
        required String password,
      }) async {
    try {
      print({
        "phone": phone,
        "password": password,
      });
      final response = await ApiClient().dio(context).post(
        '/mobil/login',
        queryParameters: {
          "phone": phone,
          "password": password,
        },
      );
      final json = response.data as Map<String, dynamic>;
      final res = CustomerAuthEntity.fromJson(json);
      if (res.status == 'Banned') {
        showMessage('Аккаунт заблокирован');
      }
      return res;
    } catch (e) {
      log('ERROR in login: $e');
      showMessage('Неверный пароль');
    }
    return null;
  }

  static Future<CustomerAuthEntity?> resetPass(
      BuildContext context, {
        required String code,
        required String phone,
        required String password,
      }) async {
    try {
      final response = await ApiClient().dio(context).post(
        '/mobil/change_password',
        queryParameters: {
          "code": code,
          "phone": phone,
          "password": password,
        },
      );
      final json = response.data as Map<String, dynamic>;
      return CustomerAuthEntity.fromJson(json);
    } catch (e) {
      log('ERROR in resetPass: $e');
    }
    return null;
  }


  static Future<SupportEntity?> getSupportData(BuildContext context) async {
    try {
      final response = await ApiClient().dio(context).get(
        '/mobil/get_support_data',
      );
      log('Response status: ${response.statusCode}');
      log('Response data: ${response.data}');
      final json = response.data as Map<String, dynamic>;
      return SupportEntity.fromJson(json);
    } catch (e) {
      log('ERROR in getSupportData: $e');
    }
    return null;
  }

  static Future<List<Spec>?> getSpecs(BuildContext context) async {
    try {
      final response = await ApiClient().dio(context).get(
        '/mobil/get_specializations_list',
      );
      final json = response.data as List;
      return json.map((e) => Spec.fromJson(e)).toList();
    } catch (e) {
      log('ERROR in getSpecs: $e');
    }
    return null;
  }

  static Future<void> setPosition(
      BuildContext context,
      String token,
      String lat,
      String lon,
      ) async {
    try {
      await ApiClient().dio(context).get(
        '/mobil/customer/main/set_coordinates',
        options: Options(
          headers: {'Authorization': token},
        ),
        queryParameters: {
          'latitude': lat,
          'longitude': lon,
        },
      );
    } catch (e) {
      log('ERROR in setPosition: $e');
    }
  }

  static Future<Map<String, dynamic>?> getPosition(BuildContext context) async {
    try {
      final response = await ApiClient().dio(context).get(
        'https://ipapi.co/json',
      );
      final json = response.data as Map<String, dynamic>;
      return {'lat': json['latitude'], 'lon': json['longitude']};
    } catch (e) {
      log('ERROR in getPosition: $e');
    }
    return null;
  }
}
