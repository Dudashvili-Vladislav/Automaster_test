import 'package:json_annotation/json_annotation.dart';

part 'car_base_model.g.dart';

@JsonSerializable()
class CarBaseModel {
  final String id;
  final String name;
  @JsonKey(name: 'cyrillic-name')
  final String cyrillicName;
  final int generations;

  const CarBaseModel({
    required this.id,
    required this.name,
    required this.cyrillicName,
    required this.generations,
  });

  Map<String, dynamic> toJson() => _$CarBaseModelToJson(this);

  factory CarBaseModel.fromJson(Map<String, dynamic> json) =>
      _$CarBaseModelFromJson(json);
}
