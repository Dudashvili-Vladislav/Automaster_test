// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'customer.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CustomerEntity _$CustomerEntityFromJson(Map<String, dynamic> json) =>
    CustomerEntity(
      avatarUrl: json['avatarUrl'] as String?,
      name: json['name'] as String? ?? '',
      phone: json['phone'] as String,
      masterStatus: json['masterStatus'] as String? ?? '',
      carsList: (json['carsList'] as List<dynamic>?)
          ?.map((e) => CustomerCarEntity.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$CustomerEntityToJson(CustomerEntity instance) =>
    <String, dynamic>{
      'avatarUrl': instance.avatarUrl,
      'name': instance.name,
      'phone': instance.phone,
      'masterStatus': instance.masterStatus,
      'carsList': instance.carsList,
    };
