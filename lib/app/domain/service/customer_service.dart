// ignore_for_file: use_build_context_synchronously

import 'dart:developer';
import 'dart:io';

import 'package:auto_master/app/data/api_client.dart';
import 'package:auto_master/app/domain/models/accessories_entity.dart';
import 'package:auto_master/app/domain/models/body_type.dart';
import 'package:auto_master/app/domain/models/customer.dart';
import 'package:auto_master/app/domain/models/customer_car.dart';
import 'package:auto_master/app/domain/models/master.dart';
import 'package:auto_master/app/domain/models/order_response_entity.dart';
import 'package:auto_master/app/ui/utils/get_token.dart';
import 'package:auto_master/app/ui/utils/pick_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class CustomerService {
  static Future<String?> changeRoleToMaster(BuildContext context) async {
    try {
      final token = await getToken(context);
      final response = await ApiClient().dio(context).post(
            '/mobil/customer/profile/change_role',
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

  static Future<List<CustomerCarEntity>?> getCarsList(
      BuildContext context) async {
    try {
      final token = await getToken(context);
      final response = await ApiClient()
          .dio(context)
          .get('/mobil/customer/main/get_car_list',
              options: Options(
                headers: {'Authorization': token},
              ));
      final json = response.data as List;
      return json.map((e) => CustomerCarEntity.fromJson(e)).toList();
    } catch (e) {
      log('ERROR: $e');
    }
    return null;
  }

  static Future<CustomerEntity?> getCustomer(BuildContext context) async {
    try {
      final token = await getToken(context);
      final response = await ApiClient().dio(context).get(
            '/mobil/customer/profile/get_customer_model',
            options: Options(
              headers: {'Authorization': token},
            ),
          );
      final json = response.data as Map<String, dynamic>;
      return CustomerEntity.fromJson(json);
    } catch (e) {
      log('ERROR: $e');
    }
    return null;
  }

  static Future<CustomerCarEntity?> addCustomerCar(
      BuildContext context, CustomerCarEntity model) async {
    try {
      final token = await getToken(context);
      final json = model.toJson();
      json['carModel'] = model.model;

      await ApiClient().dio(context).post(
            '/mobil/customer/profile/add_customer_car',
            queryParameters: json,
            // {
            //   'bodyType': model.bodyType,
            //   'brand': model.brand,
            //   'carModel': model.model,
            //   'carNationality': model.carNationality,
            //   'carNumber': model.carNumber,
            //   'enginePower': model.enginePower,
            //   'engineType': model.engineType,
            //   'typeOfDrive': model.typeOfDrive,
            //   'vinNumber': model.vinNumber,
            // },
            options: Options(
              headers: {'Authorization': token},
            ),
          );
    } catch (e) {
      log('ERROR: $e');
    }
    return null;
  }

  static Future<CustomerCarEntity?> editCustomerCar(
      BuildContext context, CustomerCarEntity model) async {
    try {
      final token = await getToken(context);
      final json = model.toJson();
      json['carId'] = model.id.toString();
      json['carModel'] = model.model;

      await ApiClient().dio(context).post(
            '/mobil/customer/profile/edit_customer_car',
            queryParameters: json,
            //  {
            //   'bodyType': model.bodyType,
            //   'brand': model.brand,
            //   'carModel': model.model,
            //   'carNationality': model.carNationality,
            //   'carNumber': model.carNumber,
            //   'enginePower': model.enginePower,
            //   'engineType': model.engineType,
            //   'typeOfDrive': model.typeOfDrive,
            //   'vinNumber': model.vinNumber,
            //   'carId': model.id.toString(),
            // },
            options: Options(
              headers: {'Authorization': token},
            ),
          );
    } catch (e) {
      log('ERROR: $e');
    }
    return null;
  }

  static Future<CustomerEntity?> editCustomer(
      BuildContext context, CustomerEntity model) async {
    try {
      final token = await getToken(context);
      final response = await ApiClient().dio(context).post(
            '/mobil/customer/profile/edit_customer_profile',
            queryParameters: {
              'name': model.name,
              'phone': model.phone,
            },
            options: Options(
              headers: {'Authorization': token},
            ),
          );
      final json = response.data as Map<String, dynamic>;
      return CustomerEntity.fromJson(json);
    } catch (e) {
      log('ERROR: $e');
    }
    return null;
  }

  static Future<bool> deleteCustomer(BuildContext context) async {
    try {
      final token = await getToken(context);
      final response = await ApiClient().dio(context).post(
            '/mobil/customer/profile/delete_customer',
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

  static Future<List<BodyTypes>?> getBodyList(BuildContext context) async {
    try {
      final token = await getToken(context);
      final response = await ApiClient().dio(context).post(
            '/mobil/customer/profile/get_body_list',
            // queryParameters: {
            //   'name': model.name,
            //   'phone': model.phone,
            // },
            options: Options(
              headers: {'Authorization': token},
            ),
          );
      // final json = response.data as Map<String, dynamic>;
      return List<BodyTypes>.from(
          response.data.map((x) => BodyTypes.fromJson(x)));
    } catch (e) {
      log('ERROR: $e');
    }
    return null;
  }

  static Future<CustomerEntity?> setCustomerAvatar(
      BuildContext context, PickImageState file) async {
    try {
      final token = await getToken(context);
      FormData data = FormData.fromMap({
        "avatar": MultipartFile.fromBytes(
          file.data,
          filename: DateTime.now().toIso8601String(),
        ),
      });
      final response = await ApiClient().dio(context).post(
            '/mobil/customer/profile/set_customer_avatar',
            data: data,
            options: Options(
              headers: {'Authorization': token},
            ),
          );
      final json = response.data as Map<String, dynamic>;
      return CustomerEntity.fromJson(json);
    } catch (e) {
      log('ERROR: $e');
    }
    return null;
  }

  static Future<CustomerEntity?> deleteCustomerAvatar(
      BuildContext context) async {
    try {
      final token = await getToken(context);
      final response = await ApiClient().dio(context).delete(
            '/mobil/customer/profile/delete_customer_avatar',
            options: Options(
              headers: {'Authorization': token},
            ),
          );
      final json = response.data as Map<String, dynamic>;
      return CustomerEntity.fromJson(json);
    } catch (e) {
      log('ERROR: $e');
    }
    return null;
  }

  static Future<void> deleteCustomerCar(BuildContext context, int carId) async {
    try {
      final token = await getToken(context);
      await ApiClient().dio(context).delete(
            '/mobil/customer/profile/delete_customer_car',
            queryParameters: {'carId': carId},
            options: Options(
              headers: {'Authorization': token},
            ),
          );
    } catch (e) {
      log('ERROR: $e');
    }
  }

  static Future<void> completeOrder(BuildContext context, int orderId) async {
    try {
      await ApiClient().dio(context).post(
            '/mobil/customer/order/complete_order',
            queryParameters: {'orderId': orderId},
            options: Options(
              headers: {'Authorization': 'Bearer '},
            ),
          );
    } catch (e) {
      log('ERROR: $e');
    }
  }

  static Future<bool?> createOrder(
      BuildContext context, Map<String, dynamic> params) async {
    try {
      final token = await getToken(context);
      await ApiClient().dio(context).post(
            '/mobil/customer/order/create_order',
            queryParameters: params,
            options: Options(
              headers: {'Authorization': token},
            ),
          );

      return true;
    } catch (e) {
      log('ERROR: $e');
    }
    return null;
  }

  static Future<void> selectMaster(BuildContext context, int responseId) async {
    try {
      final token = await getToken(context);
      await ApiClient().dio(context).post(
            '/mobil/customer/order/select_master',
            queryParameters: {'responseId': responseId},
            options: Options(
              headers: {'Authorization': token},
            ),
          );
    } catch (e) {
      log('ERROR: $e');
    }
  }

  static Future<void> iosPayment(BuildContext context, int orderId) async {
    try {
      final token = await getToken(context);
      await ApiClient().dio(context).post(
            '/mobil/customer/order/ios_payment',
            queryParameters: {'orderId': orderId},
            options: Options(
              headers: {'Authorization': token},
            ),
          );
    } catch (e) {
      log('ERROR: $e');
    }
  }

  static Future<bool> extraStatus(BuildContext context) async {
    try {
      final token = await getToken(context);
      final response = await ApiClient().dio(context).post(
            '/mobil/customer/order/extra_status',
            // queryParameters: {'orderId': orderId},
            options: Options(
              headers: {'Authorization': token},
            ),
          );

      return response.data == 'true';
    } catch (e) {
      log('ERROR: $e');
      return false;
    }
  }

  static Future<void> setRating(
      BuildContext context, Map<String, dynamic> params) async {
    try {
      final token = await getToken(context);
      await ApiClient().dio(context).post(
            '/mobil/customer/order/set_rating',
            queryParameters: params,
            options: Options(
              headers: {'Authorization': token},
            ),
          );
    } catch (e) {
      log('ERROR: $e');
    }
  }

  // static Future<void> getMasterInfo(
  //     BuildContext context, int responseId) async {
  //   try {
  //     await ApiClient().dio(context).get(
  //           '/mobil/customer/order/get_master_info',
  //           queryParameters: {'responseId': responseId},
  //           options: Options(
  //             headers: {'Authorization': 'Bearer '},
  //           ),
  //         );
  //   } catch (e) {
  //     log('ERROR: $e');
  //   }
  // }

  static Future<List<MasterEntity>?> getMastersBySpec(
      BuildContext context, String specialization) async {
    try {
      final token = await getToken(context);
      final response = await ApiClient().dio(context).get(
            '/mobil/customer/order/get_master_list_by_specialization',
            queryParameters: {'specialization': specialization},
            options: Options(
              headers: {'Authorization': token},
            ),
          );

      final json = response.data as List;
      return json.map((e) => MasterEntity.fromJson(e)).toList();
    } catch (e) {
      log('ERROR: $e');
    }
    return null;
  }

  // static Future<void> getOrders(BuildContext context) async {
  //   try {
  //     await ApiClient().dio(context).get(
  //           '/mobil/customer/order/get_order_section_model',
  //           options: Options(
  //             headers: {'Authorization': 'Bearer '},
  //           ),
  //         );
  //   } catch (e) {
  //     log('ERROR: $e');
  //   }
  // }

  static Future<List<OrderResponseEntity>?> getResponseList(
      BuildContext context, int orderId) async {
    try {
      final token = await getToken(context);
      final response = await ApiClient().dio(context).get(
            '/mobil/customer/order/get_response_list',
            queryParameters: {'orderId': orderId},
            options: Options(
              headers: {'Authorization': token},
            ),
          );

      final data = response.data as List;

      return data.map((e) => OrderResponseEntity.fromJson(e)).toList();
    } catch (e) {
      log('ERROR: $e');
    }

    return null;
  }

  static Future<List<Accessories>?> getAccessories(BuildContext context) async {
    try {
      final token = await getToken(context);
      final response = await ApiClient().dio(context).get(
            '/mobil/customer/car_accessories/get_car_accessories_model',
            options: Options(
              headers: {'Authorization': token},
            ),
          );

      final data = response.data as List;

      return data.map((e) => Accessories.fromJson(e)).toList();
    } catch (e) {
      log('ERROR: $e');
    }

    return null;
  }

  static Future<String?> getAccessoriesLink(BuildContext context) async {
    try {
      final response = await ApiClient().dio(context).get(
            '/mobil/customer/car_accessories/get_whats_app_seller',
          );

      return response.data;
    } catch (e) {
      log('ERROR: $e');
    }

    return null;
  }
}
