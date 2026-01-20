// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'master_orders_entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MasterOrdersEntity _$MasterOrdersEntityFromJson(Map<String, dynamic> json) =>
    MasterOrdersEntity(
      activeOrders: (json['activeOrders'] as List<dynamic>)
          .map((e) => MasterOrderEntity.fromJson(e as Map<String, dynamic>))
          .toList(),
      inProgressOrders: (json['inProgressOrders'] as List<dynamic>)
          .map((e) => MasterOrderEntity.fromJson(e as Map<String, dynamic>))
          .toList(),
      completedOrders: (json['completedOrders'] as List<dynamic>)
          .map((e) => MasterOrderEntity.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$MasterOrdersEntityToJson(MasterOrdersEntity instance) =>
    <String, dynamic>{
      'activeOrders': instance.activeOrders,
      'inProgressOrders': instance.inProgressOrders,
      'completedOrders': instance.completedOrders,
    };
