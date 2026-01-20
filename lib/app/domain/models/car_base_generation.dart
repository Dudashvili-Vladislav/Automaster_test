import 'package:json_annotation/json_annotation.dart';

part 'car_base_generation.g.dart';

@JsonSerializable()
class CarBaseGeneration {
  final String id;
  final String name;
  final int configurations;

  const CarBaseGeneration({
    required this.id,
    required this.name,
    required this.configurations,
  });

  Map<String, dynamic> toJson() => _$CarBaseGenerationToJson(this);

  factory CarBaseGeneration.fromJson(Map<String, dynamic> json) =>
      _$CarBaseGenerationFromJson(json);
}
