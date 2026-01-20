// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order_response_entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OrderResponseEntity _$OrderResponseEntityFromJson(Map<String, dynamic> json) =>
    OrderResponseEntity(
      id: json['id'] as int,
      orderId: json['orderId'] as int,
      customerId: json['customerId'] as int,
      nameOfMaster: json['nameOfMaster'] as String? ?? '',
      avatarOfMaster: json['avatarOfMaster'] as String?,
      stoName: json['stoName'] as String? ?? '',
      latitude: (json['latitude'] as num?)?.toDouble(),
      longitude: (json['longitude'] as num?)?.toDouble(),
      rating: json['rating'] as num,
      address: json['address'] as String? ?? '',
      priceFromMaster: json['priceFromMaster'] as num,
      masterDescription: json['masterDescription'] as String? ?? '',
      experience: json['experience'] as String,
      masterPhone: json['masterPhone'] as String,
    );

Map<String, dynamic> _$OrderResponseEntityToJson(
        OrderResponseEntity instance) =>
    <String, dynamic>{
      'id': instance.id,
      'orderId': instance.orderId,
      'customerId': instance.customerId,
      'nameOfMaster': instance.nameOfMaster,
      'avatarOfMaster': instance.avatarOfMaster,
      'stoName': instance.stoName,
      'latitude': instance.latitude,
      'longitude': instance.longitude,
      'rating': instance.rating,
      'address': instance.address,
      'priceFromMaster': instance.priceFromMaster,
      'masterDescription': instance.masterDescription,
      'experience': instance.experience,
      'masterPhone': instance.masterPhone,
    };
