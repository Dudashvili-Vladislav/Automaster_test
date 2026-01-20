// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'customer_orders_entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CustomerOrdersEntity _$CustomerOrdersEntityFromJson(
        Map<String, dynamic> json) =>
    CustomerOrdersEntity(
      activeOrders: (json['activeOrders'] as List<dynamic>)
          .map((e) => CustomerOrderEntity.fromJson(e as Map<String, dynamic>))
          .toList(),
      completedOrders: (json['completedOrders'] as List<dynamic>)
          .map((e) => CustomerOrderEntity.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$CustomerOrdersEntityToJson(
        CustomerOrdersEntity instance) =>
    <String, dynamic>{
      'activeOrders': instance.activeOrders.map((e) => e.toJson()).toList(),
      'completedOrders':
          instance.completedOrders.map((e) => e.toJson()).toList(),
    };
