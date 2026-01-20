// ignore_for_file: use_build_context_synchronously

import 'dart:developer';

import 'package:auto_master/app/data/api_client.dart';
import 'package:auto_master/app/domain/models/customer_orders_entity.dart';
import 'package:auto_master/app/domain/models/order_response_real.dart';
import 'package:auto_master/app/ui/utils/get_token.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class CustomerOrderService {
  static Future<CustomerOrdersEntity?> allOrdersNoLogs(
      BuildContext context) async {
    print('Updated customer orders');
    try {
      final token = await getToken(context);
      final response = await Dio(
        BaseOptions(baseUrl: ApiClient.baseUrl),
      ).get(
        '/mobil/customer/order/get_order_section_model',
        options: Options(
          headers: {'Authorization': token},
        ),
      );
      final json = response.data as Map<String, dynamic>;
      return CustomerOrdersEntity.fromJson(json);
    } catch (e) {
      log('ERROR: $e');
    }
    return null;
  }

  static Future<CustomerOrdersEntity?> getAllOrders(
      BuildContext context) async {
    try {
      final token = await getToken(context);
      final response = await ApiClient().dio(context).get(
            '/mobil/customer/order/get_order_section_model',
            options: Options(
              headers: {'Authorization': token},
            ),
          );
      final json = response.data as Map<String, dynamic>;
      return CustomerOrdersEntity.fromJson(json);
    } catch (e) {
      log('ERROR: $e');
    }
    return null;
  }

  static Future<Map<String, dynamic>?> getCostAndBalance(
      BuildContext context) async {
    try {
      final token = await getToken(context);
      final response = await ApiClient()
          .dio(context)
          .get('/mobil/customer/order/get_cost_and_user_balance',
              options: Options(
                headers: {'Authorization': token},
              ));
      final json = response.data as Map<String, dynamic>;
      return json;
    } catch (e) {
      log('ERROR: $e');
    }
    return null;
  }

  static Future<OrderResponseReal?> orderHasRating(
      BuildContext context, int orderId) async {
    try {
      final token = await getToken(context);
      final response = await ApiClient().dio(context).get(
            '/mobil/customer/order/get_order',
            queryParameters: {'orderId': orderId},
            options: Options(
              headers: {'Authorization': token},
            ),
          );

      return OrderResponseReal.fromJson(response.data);
    } catch (e) {
      log('ERROR: $e');
      return null;
    }
  }

  static Future<void> completeOrder(BuildContext context, int orderId) async {
    try {
      final token = await getToken(context);
      await ApiClient().dio(context).post(
            '/mobil/customer/order/complete_order',
            queryParameters: {'orderId': orderId},
            options: Options(
              headers: {'Authorization': token},
            ),
          );
    } catch (e) {
      log('ERROR: $e');
    }
  }

  static Future<String> getPaymentLink(
      BuildContext context, int orderId) async {
    final token = await getToken(context);
    final response = await ApiClient().dio(context).get(
          '/mobil/customer/main/get_payment_link',
          queryParameters: {'orderId': orderId},
          options: Options(
            headers: {'Authorization': token},
          ),
        );
    return response.data;
  }
}
