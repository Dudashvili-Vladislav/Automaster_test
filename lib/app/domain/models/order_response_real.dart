import 'package:json_annotation/json_annotation.dart';

part 'order_response_real.g.dart';

@JsonSerializable()
class OrderResponseReal {
  final int id;
  final bool ratingStatus;

  const OrderResponseReal({
    required this.id,
    required this.ratingStatus,
  });

  factory OrderResponseReal.fromJson(Map<String, dynamic> json) =>
      _$OrderResponseRealFromJson(json);

  Map<String, dynamic> toJson() => _$OrderResponseRealToJson(this);
}
