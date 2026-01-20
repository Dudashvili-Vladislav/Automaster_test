import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';

import 'customer_order_entity.dart';

part 'customer_orders_entity.g.dart';

@JsonSerializable(explicitToJson: true)
class CustomerOrdersEntity {
  List<CustomerOrderEntity> activeOrders;
  List<CustomerOrderEntity> completedOrders;

  CustomerOrdersEntity({
    required this.activeOrders,
    required this.completedOrders,
  });

  Map<String, dynamic> toJson() => _$CustomerOrdersEntityToJson(this);

  factory CustomerOrdersEntity.fromJson(Map<String, dynamic> json) =>
      _$CustomerOrdersEntityFromJson(json);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is CustomerOrdersEntity &&
        listEquals(other.activeOrders, activeOrders) &&
        listEquals(other.completedOrders, completedOrders);
  }

  @override
  int get hashCode => activeOrders.hashCode ^ completedOrders.hashCode;
}
