import 'package:json_annotation/json_annotation.dart';

part 'car_base_brand.g.dart';

@JsonSerializable()
class CarBaseBrand {
  final String id;
  final String name;
  @JsonKey(name: 'cyrillic-name')
  final String cyrillicName;

  const CarBaseBrand({
    required this.id,
    required this.name,
    required this.cyrillicName,
  });

  Map<String, dynamic> toJson() => _$CarBaseBrandToJson(this);

  factory CarBaseBrand.fromJson(Map<String, dynamic> json) =>
      _$CarBaseBrandFromJson(json);
}
