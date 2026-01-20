import 'package:auto_master/app/domain/models/car_base_specification.dart';
import 'package:json_annotation/json_annotation.dart';

part 'car_base_modification.g.dart';

@JsonSerializable()
class CarBaseModification {
  @JsonKey(name: 'complectation-id')
  final String complectationId;
  final CarBaseSpecification specifications;

  const CarBaseModification({
    required this.complectationId,
    required this.specifications,
  });

  Map<String, dynamic> toJson() => _$CarBaseModificationToJson(this);

  factory CarBaseModification.fromJson(Map<String, dynamic> json) =>
      _$CarBaseModificationFromJson(json);
}
