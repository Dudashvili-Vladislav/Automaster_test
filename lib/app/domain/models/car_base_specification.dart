import 'package:json_annotation/json_annotation.dart';

part 'car_base_specification.g.dart';

@JsonSerializable()
class CarBaseSpecification {
  @JsonKey(name: 'engine-type')
  final String engineType;
  final String drive;
  @JsonKey(name: 'horse-power')
  final int horsePower;

  const CarBaseSpecification({
    required this.engineType,
    required this.drive,
    required this.horsePower,
  });

  Map<String, dynamic> toJson() => _$CarBaseSpecificationToJson(this);

  factory CarBaseSpecification.fromJson(Map<String, dynamic> json) =>
      _$CarBaseSpecificationFromJson(json);
}
