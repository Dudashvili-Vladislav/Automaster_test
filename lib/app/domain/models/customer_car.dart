// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'customer_car.g.dart';

@CopyWith()
@JsonSerializable()
class CustomerCarEntity {
  @JsonKey(includeToJson: false)
  int id;
  @JsonKey(includeToJson: false)
  int ownerId;
  String typeOfDrive;
  String vinNumber;
  String? bodyType;
  String brand;
  String carNationality;
  String carNumber;
  String enginePower;
  String engineType;
  String model;
  String icon;
  final String? generation;

  CustomerCarEntity({
    required this.id,
    required this.ownerId,
    required this.typeOfDrive,
    required this.vinNumber,
    required this.bodyType,
    required this.brand,
    required this.carNationality,
    required this.carNumber,
    required this.enginePower,
    required this.engineType,
    required this.model,
    required this.icon,
    required this.generation,
  });

  Map<String, dynamic> toJson() => _$CustomerCarEntityToJson(this);

  factory CustomerCarEntity.fromJson(Map<String, dynamic> json) =>
      _$CustomerCarEntityFromJson(json);

  @override
  bool operator ==(covariant CustomerCarEntity other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.ownerId == ownerId &&
        other.typeOfDrive == typeOfDrive &&
        other.vinNumber == vinNumber &&
        other.bodyType == bodyType &&
        other.brand == brand &&
        other.carNationality == carNationality &&
        other.carNumber == carNumber &&
        other.enginePower == enginePower &&
        other.engineType == engineType &&
        other.model == model &&
        other.generation == generation &&
        other.icon == icon;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        ownerId.hashCode ^
        typeOfDrive.hashCode ^
        vinNumber.hashCode ^
        bodyType.hashCode ^
        brand.hashCode ^
        carNationality.hashCode ^
        carNumber.hashCode ^
        enginePower.hashCode ^
        engineType.hashCode ^
        model.hashCode ^
        generation.hashCode ^
        icon.hashCode;
  }
}
