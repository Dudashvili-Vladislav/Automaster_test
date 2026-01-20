// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'car_base_configuration.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CarBaseConfiguration _$CarBaseConfigurationFromJson(
        Map<String, dynamic> json) =>
    CarBaseConfiguration(
      id: json['id'] as String,
      bodyType: json['body-type'] as String,
      modifications: (json['modifications'] as List<dynamic>)
          .map((e) => CarBaseModification.fromJson(e as Map<String, dynamic>))
          .toList(),
      steertingWheel: json['steering-wheel'] as String,
    );

Map<String, dynamic> _$CarBaseConfigurationToJson(
        CarBaseConfiguration instance) =>
    <String, dynamic>{
      'id': instance.id,
      'body-type': instance.bodyType,
      'steering-wheel': instance.steertingWheel,
      'modifications': instance.modifications,
    };
