import 'package:auto_master/app/domain/models/car_base_modification.dart';
import 'package:json_annotation/json_annotation.dart';

part 'car_base_configuration.g.dart';

@JsonSerializable()
class CarBaseConfiguration {
  final String id;
  @JsonKey(name: 'body-type')
  final String bodyType;
  @JsonKey(name: 'steering-wheel')
  final String steertingWheel;
  final List<CarBaseModification> modifications;

  const CarBaseConfiguration({
    required this.id,
    required this.bodyType,
    required this.modifications,
    required this.steertingWheel,
  });

  Map<String, dynamic> toJson() => _$CarBaseConfigurationToJson(this);

  factory CarBaseConfiguration.fromJson(Map<String, dynamic> json) =>
      _$CarBaseConfigurationFromJson(json);
}
