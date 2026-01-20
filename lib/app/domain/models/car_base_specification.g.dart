// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'car_base_specification.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CarBaseSpecification _$CarBaseSpecificationFromJson(
        Map<String, dynamic> json) =>
    CarBaseSpecification(
      engineType: json['engine-type'] as String,
      drive: json['drive'] as String,
      horsePower: json['horse-power'] as int,
    );

Map<String, dynamic> _$CarBaseSpecificationToJson(
        CarBaseSpecification instance) =>
    <String, dynamic>{
      'engine-type': instance.engineType,
      'drive': instance.drive,
      'horse-power': instance.horsePower,
    };
