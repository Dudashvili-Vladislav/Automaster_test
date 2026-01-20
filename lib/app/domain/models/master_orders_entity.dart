import 'package:auto_master/app/domain/models/master_order_entity.dart';
import 'package:json_annotation/json_annotation.dart';

part 'master_orders_entity.g.dart';

@JsonSerializable()
class MasterOrdersEntity {
  List<MasterOrderEntity> activeOrders;
  List<MasterOrderEntity> inProgressOrders;
  List<MasterOrderEntity> completedOrders;

  MasterOrdersEntity({
    required this.activeOrders,
    required this.inProgressOrders,
    required this.completedOrders,
  });

  Map<String, dynamic> toJson() => _$MasterOrdersEntityToJson(this);

  factory MasterOrdersEntity.fromJson(Map<String, dynamic> json) =>
      _$MasterOrdersEntityFromJson(json);
}
