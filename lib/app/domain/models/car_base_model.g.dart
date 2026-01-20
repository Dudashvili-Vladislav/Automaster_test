// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'car_base_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CarBaseModel _$CarBaseModelFromJson(Map<String, dynamic> json) => CarBaseModel(
      id: json['id'] as String,
      name: json['name'] as String,
      cyrillicName: json['cyrillic-name'] as String,
      generations: json['generations'] as int,
    );

Map<String, dynamic> _$CarBaseModelToJson(CarBaseModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'cyrillic-name': instance.cyrillicName,
      'generations': instance.generations,
    };
