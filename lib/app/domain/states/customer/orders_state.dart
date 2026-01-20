import 'dart:async';

import 'package:auto_master/app/domain/models/customer_order_entity.dart';
import 'package:auto_master/app/domain/service/customer_order_service.dart';
import 'package:flutter/material.dart';

class CustomerOrdersState extends ChangeNotifier {
  List<CustomerOrderEntity> _activeOrders = [];
  List<CustomerOrderEntity> _completedOrders = [];

  bool _isLoading = false;

  bool get isLoading => _isLoading;
  List<CustomerOrderEntity> get activeOrders => _activeOrders;
  List<CustomerOrderEntity> get completeOrders => _completedOrders;

  BuildContext context;

  Timer? _timer;

  CustomerOrdersState(this.context) {
    Future.microtask(fetchOrders);
  }

  Future<void> restartTimer() async {
    print('SET TIMER CUSTOMER ORDERS');
    _timer?.cancel();
    _timer = Timer.periodic(
      const Duration(seconds: 2),
      (Timer timer) {
        easyFetchOrders(showLogs: false);
      },
    );
  }

  Future<void> easyFetchOrders({bool showLogs = true}) async {
    final allOrders = showLogs
        ? await CustomerOrderService.getAllOrders(context)
        : await CustomerOrderService.allOrdersNoLogs(context);

    if (allOrders != null) {
      _activeOrders = allOrders.activeOrders.reversed.toList();
      _completedOrders = allOrders.completedOrders.reversed.toList();
    } else {
      _timer?.cancel();
    }

    notifyListeners();
  }

  Future<void> fetchOrders() async {
    _isLoading = true;
    notifyListeners();

    await easyFetchOrders();

    _isLoading = false;
    notifyListeners();
  }

  // Future<int?> getOrderRating(){

  // }

  Future<bool> orderHasRating(int orderId) async {
    final resp = await CustomerOrderService.orderHasRating(context, orderId);
    if (resp != null) {
      return resp.ratingStatus;
    } else {
      return false;
    }
  }

  Future<void> completeOrder(int orderId) async {
    await CustomerOrderService.completeOrder(context, orderId);
    await fetchOrders();
  }

  Future<String> getPaymentLink(int orderId) async {
    return await CustomerOrderService.getPaymentLink(context, orderId);
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
