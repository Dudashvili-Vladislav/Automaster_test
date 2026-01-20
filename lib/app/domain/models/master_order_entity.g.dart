// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'master_order_entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MasterOrderEntity _$MasterOrderEntityFromJson(Map<String, dynamic> json) =>
    MasterOrderEntity(
      id: json['id'] as int,
      customerId: json['customerId'] as int,
      customerName: json['customerName'] as String?,
      customerPhone: json['customerPhone'] as String?,
      customerAvatar: json['customerAvatar'] as String?,
      selectedMasterId: json['selectedMasterId'] as int?,
      selectedMasterName: json['selectedMasterName'] as String?,
      selectedMasterAddress: json['selectedMasterAddress'] as String?,
      selectedMasterStoName: json['selectedMasterStoName'] as String?,
      selectedMasterAvatar: json['selectedMasterAvatar'] as String?,
      selectedMasterPhone: json['selectedMasterPhone'] as String?,
      carNationality: json['carNationality'] as String?,
      bodyType: json['bodyType'] as String?,
      typeOfDrive: json['typeOfDrive'] as String?,
      vinNumber: json['vinNumber'] as String?,
      engineType: json['engineType'] as String?,
      enginePower: json['enginePower'] as String?,
      priceFromSelectedMaster:
          (json['priceFromSelectedMaster'] as num?)?.toDouble(),
      orderStatus: json['orderStatus'] as String?,
      carId: json['carId'] as int,
      carNumber: json['carNumber'] as String? ?? '',
      carBrand: json['carBrand'] as String? ?? '',
      carModel: json['carModel'] as String? ?? '',
      specialization: json['specialization'] as String? ?? '',
      specializationAvatar: json['specializationAvatar'] as String? ?? '',
      latitude: (json['latitude'] as num?)?.toDouble(),
      longitude: (json['longitude'] as num?)?.toDouble(),
      orderDescription: json['orderDescription'] as String?,
      dateFrom: json['dateFrom'] as String?,
      dateTo: json['dateTo'] as String?,
      time: json['time'] as String?,
      radius: json['radius'] as int?,
      responsesCount: json['responsesCount'] as int?,
      responseStatus: json['responseStatus'] as String? ?? '',
    );

Map<String, dynamic> _$MasterOrderEntityToJson(MasterOrderEntity instance) =>
    <String, dynamic>{
      'id': instance.id,
      'customerId': instance.customerId,
      'customerName': instance.customerName,
      'customerPhone': instance.customerPhone,
      'customerAvatar': instance.customerAvatar,
      'selectedMasterId': instance.selectedMasterId,
      'selectedMasterName': instance.selectedMasterName,
      'selectedMasterAddress': instance.selectedMasterAddress,
      'selectedMasterStoName': instance.selectedMasterStoName,
      'selectedMasterPhone': instance.selectedMasterPhone,
      'selectedMasterAvatar': instance.selectedMasterAvatar,
      'carNationality': instance.carNationality,
      'bodyType': instance.bodyType,
      'typeOfDrive': instance.typeOfDrive,
      'vinNumber': instance.vinNumber,
      'engineType': instance.engineType,
      'enginePower': instance.enginePower,
      'priceFromSelectedMaster': instance.priceFromSelectedMaster,
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
      'responseStatus': instance.responseStatus,
    };
