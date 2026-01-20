// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'car_base_generation.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CarBaseGeneration _$CarBaseGenerationFromJson(Map<String, dynamic> json) =>
    CarBaseGeneration(
      id: json['id'] as String,
      name: json['name'] as String,
      configurations: json['configurations'] as int,
    );

Map<String, dynamic> _$CarBaseGenerationToJson(CarBaseGeneration instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'configurations': instance.configurations,
    };
