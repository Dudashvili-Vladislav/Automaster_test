// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'car_base_modification.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CarBaseModification _$CarBaseModificationFromJson(Map<String, dynamic> json) =>
    CarBaseModification(
      complectationId: json['complectation-id'] as String,
      specifications: CarBaseSpecification.fromJson(
          json['specifications'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$CarBaseModificationToJson(
        CarBaseModification instance) =>
    <String, dynamic>{
      'complectation-id': instance.complectationId,
      'specifications': instance.specifications,
    };
