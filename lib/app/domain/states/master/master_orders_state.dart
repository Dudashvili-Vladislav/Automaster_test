import 'dart:async';
import 'package:collection/collection.dart';
import 'package:auto_master/app/domain/models/master_order_entity.dart';
import 'package:auto_master/app/domain/service/customer_order_service.dart';
import 'package:auto_master/app/domain/service/master_service.dart';
import 'package:flutter/material.dart';

class MasterOrdersState extends ChangeNotifier {
  List<MasterOrderEntity> _activeOrders = [];
  List<MasterOrderEntity> _inProgressOrders = [];
  List<MasterOrderEntity> _completedOrders = [];

  bool _isLoading = false;

  bool get isLoading => _isLoading;
  List<MasterOrderEntity> get activeOrders => _activeOrders;
  List<MasterOrderEntity> get inProgressOrders => _inProgressOrders;
  List<MasterOrderEntity> get completeOrders => _completedOrders;

  BuildContext context;
  MasterOrdersState(this.context) {
    Future.microtask(fetchOrders);
  }

  Timer? _timer;

  Future<void> restartTimer() async {
    print('SET TIMER MASTER ORDERS');
    _timer?.cancel();
    _timer = Timer.periodic(
      const Duration(seconds: 2),
      (Timer timer) {
        fetchOrders(showLogs: false);
      },
    );
  }

  // Future<void> easyFetchOrders({bool showLogs = true}) async {
  //   final allOrders = showLogs
  //       ? await CustomerOrderService.getAllOrders(context)
  //       : await CustomerOrderService.allOrdersNoLogs(context);

  //   if (allOrders != null) {
  //     _activeOrders = allOrders.activeOrders.reversed.toList();
  //     _completedOrders = allOrders.completedOrders.reversed.toList();
  //   } else {
  //     _timer?.cancel();
  //   }

  //   notifyListeners();
  // }

  Future<void> fetchOrders({bool showLogs = true}) async {
    if (showLogs) {
      _isLoading = true;
      notifyListeners();
    }

    final allOrders = showLogs
        ? await MasterService.getOrders(context)
        : await MasterService.getOrdersNoLogs(context);

    if (allOrders != null) {
      Function eq = const ListEquality().equals;
      final newOrders = allOrders.activeOrders.reversed.toList();
      final newCompleted = allOrders.completedOrders.reversed.toList();
      final newInProgress = allOrders.inProgressOrders.reversed.toList();

      final eqNew = eq(_activeOrders, newOrders);
      final eqCompleted = eq(_completedOrders, newCompleted);
      final eqInProgress = eq(_inProgressOrders, newInProgress);
      // print(
      //     'eqNew: $eqNew eqCompleted: $eqCompleted eqInProgress: $eqInProgress');

      if (eqNew && eqCompleted && eqInProgress) {
        // Nothing to update
      } else {
        _activeOrders = newOrders;
        _inProgressOrders = newInProgress;
        _completedOrders = newCompleted;
        if (!showLogs) {
          notifyListeners();
        }
      }
    } else {
      _timer?.cancel();
    }

    if (showLogs) {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> setResponse(int cost, String orderId) async {
    await MasterService.setResponse(context, cost.toString(), orderId);
  }
}
