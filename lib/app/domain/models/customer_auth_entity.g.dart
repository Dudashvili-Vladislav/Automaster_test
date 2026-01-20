// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'customer_auth_entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CustomerAuthEntity _$CustomerAuthEntityFromJson(Map<String, dynamic> json) =>
    CustomerAuthEntity(
      id: json['id'] as int,
      extraMasterId: json['extraMasterId'] as int?,
      name: json['name'] as String? ?? '',
      phone: json['phone'] as String,
      avatarUrl: json['avatarUrl'] as String?,
      bearerToken: json['bearerToken'] as String,
      registrationDate: json['registrationDate'] as String? ?? '',
      status: json['status'] as String? ?? '',
      latitude: json['latitude'],
      longitude: json['longitude'],
      balance: json['balance'] as num?,
      pushToken: json['pushToken'] as String?,
    );

Map<String, dynamic> _$CustomerAuthEntityToJson(CustomerAuthEntity instance) =>
    <String, dynamic>{
      'id': instance.id,
      'extraMasterId': instance.extraMasterId,
      'name': instance.name,
      'phone': instance.phone,
      'avatarUrl': instance.avatarUrl,
      'bearerToken': instance.bearerToken,
      'registrationDate': instance.registrationDate,
      'status': instance.status,
      'latitude': instance.latitude,
      'longitude': instance.longitude,
      'balance': instance.balance,
      'pushToken': instance.pushToken,
    };
