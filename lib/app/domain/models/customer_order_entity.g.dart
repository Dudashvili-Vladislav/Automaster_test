// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'customer_order_entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CustomerOrderEntity _$CustomerOrderEntityFromJson(Map<String, dynamic> json) =>
    CustomerOrderEntity(
      id: json['id'] as int,
      customerId: json['customerId'] as int,
      selectedMasterId: json['selectedMasterId'] as int?,
      selectedMasterName: json['selectedMasterName'] as String?,
      selectedMasterAvatar: json['selectedMasterAvatar'] as String?,
      paymentStatus: json['paymentStatus'] as String?,
      orderStatus: json['orderStatus'] as String,
      carId: json['carId'] as int,
      carNumber: json['carNumber'] as String,
      carBrand: json['carBrand'] as String,
      carModel: json['carModel'] as String,
      specialization: json['specialization'] as String,
      specializationAvatar: json['specializationAvatar'] as String,
      latitude: (json['latitude'] as num?)?.toDouble(),
      longitude: (json['longitude'] as num?)?.toDouble(),
      orderDescription: json['orderDescription'] as String,
      dateFrom: json['dateFrom'] as String,
      dateTo: json['dateTo'] as String?,
      time: json['time'] as String,
      radius: json['radius'] as int,
      responsesCount: json['responsesCount'] as int?,
    )
      ..selectedMasterAddress = json['selectedMasterAddress'] as String?
      ..selectedMasterStoName = json['selectedMasterStoName'] as String?
      ..selectedMasterPhone = json['selectedMasterPhone'] as String?;

Map<String, dynamic> _$CustomerOrderEntityToJson(
        CustomerOrderEntity instance) =>
    <String, dynamic>{
      'id': instance.id,
      'customerId': instance.customerId,
      'selectedMasterId': instance.selectedMasterId,
      'selectedMasterName': instance.selectedMasterName,
      'selectedMasterAvatar': instance.selectedMasterAvatar,
      'selectedMasterAddress': instance.selectedMasterAddress,
      'selectedMasterStoName': instance.selectedMasterStoName,
      'selectedMasterPhone': instance.selectedMasterPhone,
      'paymentStatus': instance.paymentStatus,
      'orderStatus': instance.orderStatus,
      'carId': instance.carId,
      'carNumber': instance.carNumber,
      'carBrand': instance.carBrand,
      'carModel': instance.carModel,
      'specialization': instance.specialization,
      'specializationAvatar': instance.specializationAvatar,
      'latitude': instance.latitude,
      'longitude': instance.longitude,
      'orderDescription': instance.orderDescription,
      'dateFrom': instance.dateFrom,
      'dateTo': instance.dateTo,
      'time': instance.time,
      'radius': instance.radius,
      'responsesCount': instance.responsesCount,
    };
