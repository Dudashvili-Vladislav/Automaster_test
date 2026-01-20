// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:json_annotation/json_annotation.dart';

part 'master_order_entity.g.dart';

@JsonSerializable()
class MasterOrderEntity {
  int id;
  int customerId;
  String? customerName;
  String? customerPhone;
  String? customerAvatar;
  int? selectedMasterId;
  String? selectedMasterName;
  String? selectedMasterAddress;
  String? selectedMasterStoName;
  String? selectedMasterPhone;
  String? selectedMasterAvatar;
  String? carNationality;
  String? bodyType;
  String? typeOfDrive;
  String? vinNumber;
  String? engineType;
  String? enginePower;
  double? priceFromSelectedMaster;
  String? orderStatus;
  int carId;
  @JsonKey(defaultValue: '')
  String carNumber;
  @JsonKey(defaultValue: '')
  String carBrand;
  @JsonKey(defaultValue: '')
  String carModel;
  @JsonKey(defaultValue: '')
  String specialization;
  @JsonKey(defaultValue: '')
  String specializationAvatar;
  double? latitude;
  double? longitude;
  String? orderDescription;
  String? dateFrom;
  String? dateTo;
  String? time;
  int? radius;
  int? responsesCount;
  @JsonKey(defaultValue: '')
  String responseStatus;

  MasterOrderEntity({
    required this.id,
    required this.customerId,
    required this.customerName,
    this.customerPhone,
    this.customerAvatar,
    this.selectedMasterId,
    this.selectedMasterName,
    this.selectedMasterAddress,
    this.selectedMasterStoName,
    this.selectedMasterAvatar,
    this.selectedMasterPhone,
    this.carNationality,
    this.bodyType,
    this.typeOfDrive,
    this.vinNumber,
    this.engineType,
    this.enginePower,
    this.priceFromSelectedMaster,
    this.orderStatus,
    required this.carId,
    required this.carNumber,
    required this.carBrand,
    required this.carModel,
    required this.specialization,
    required this.specializationAvatar,
    this.latitude,
    this.longitude,
    this.orderDescription,
    this.dateFrom,
    this.dateTo,
    this.time,
    required this.radius,
    required this.responsesCount,
    required this.responseStatus,
  });

  Map<String, dynamic> toJson() => _$MasterOrderEntityToJson(this);

  factory MasterOrderEntity.fromJson(Map<String, dynamic> json) =>
      _$MasterOrderEntityFromJson(json);

  MasterOrderEntity copyWith({
    int? id,
    int? customerId,
    String? customerName,
    String? customerPhone,
    String? customerAvatar,
    int? selectedMasterId,
    String? selectedMasterName,
    String? selectedMasterAddress,
    String? selectedMasterStoName,
    String? selectedMasterPhone,
    String? selectedMasterAvatar,
    String? carNationality,
    String? bodyType,
    String? typeOfDrive,
    String? vinNumber,
    String? engineType,
    String? enginePower,
    double? priceFromSelectedMaster,
    String? orderStatus,
    int? carId,
    String? carNumber,
    String? carBrand,
    String? carModel,
    String? specialization,
    String? specializationAvatar,
    double? latitude,
    double? longitude,
    String? orderDescription,
    String? dateFrom,
    String? dateTo,
    String? time,
    int? radius,
    int? responsesCount,
    String? responseStatus,
  }) {
    return MasterOrderEntity(
      id: id ?? this.id,
      customerId: customerId ?? this.customerId,
      customerName: customerName ?? this.customerName,
      customerPhone: customerPhone ?? this.customerPhone,
      customerAvatar: customerAvatar ?? this.customerAvatar,
      selectedMasterId: selectedMasterId ?? this.selectedMasterId,
      selectedMasterName: selectedMasterName ?? this.selectedMasterName,
      selectedMasterAddress:
          selectedMasterAddress ?? this.selectedMasterAddress,
      selectedMasterStoName:
          selectedMasterStoName ?? this.selectedMasterStoName,
      selectedMasterPhone: selectedMasterPhone ?? this.selectedMasterPhone,
      selectedMasterAvatar: selectedMasterAvatar ?? this.selectedMasterAvatar,
      carNationality: carNationality ?? this.carNationality,
      bodyType: bodyType ?? this.bodyType,
      typeOfDrive: typeOfDrive ?? this.typeOfDrive,
      vinNumber: vinNumber ?? this.vinNumber,
      engineType: engineType ?? this.engineType,
      enginePower: enginePower ?? this.enginePower,
      priceFromSelectedMaster:
          priceFromSelectedMaster ?? this.priceFromSelectedMaster,
      orderStatus: orderStatus ?? this.orderStatus,
      carId: carId ?? this.carId,
      carNumber: carNumber ?? this.carNumber,
      carBrand: carBrand ?? this.carBrand,
      carModel: carModel ?? this.carModel,
      specialization: specialization ?? this.specialization,
      specializationAvatar: specializationAvatar ?? this.specializationAvatar,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      orderDescription: orderDescription ?? this.orderDescription,
      dateFrom: dateFrom ?? this.dateFrom,
      dateTo: dateTo ?? this.dateTo,
      time: time ?? this.time,
      radius: radius ?? this.radius,
      responsesCount: responsesCount ?? this.responsesCount,
      responseStatus: responseStatus ?? this.responseStatus,
    );
  }

  @override
  bool operator ==(covariant MasterOrderEntity other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.customerId == customerId &&
        other.customerName == customerName &&
        other.customerPhone == customerPhone &&
        other.customerAvatar == customerAvatar &&
        other.selectedMasterId == selectedMasterId &&
        other.selectedMasterName == selectedMasterName &&
        other.selectedMasterAddress == selectedMasterAddress &&
        other.selectedMasterStoName == selectedMasterStoName &&
        other.selectedMasterAvatar == selectedMasterAvatar &&
        other.selectedMasterPhone == selectedMasterPhone &&
        other.carNationality == carNationality &&
        other.bodyType == bodyType &&
        other.typeOfDrive == typeOfDrive &&
        other.vinNumber == vinNumber &&
        other.engineType == engineType &&
        other.enginePower == enginePower &&
        other.priceFromSelectedMaster == priceFromSelectedMaster &&
        other.orderStatus == orderStatus &&
        other.carId == carId &&
        other.carNumber == carNumber &&
        other.carBrand == carBrand &&
        other.carModel == carModel &&
        other.specialization == specialization &&
        other.specializationAvatar == specializationAvatar &&
        other.latitude == latitude &&
        other.longitude == longitude &&
        other.orderDescription == orderDescription &&
        other.dateFrom == dateFrom &&
        other.dateTo == dateTo &&
        other.time == time &&
        other.radius == radius &&
        other.responsesCount == responsesCount &&
        other.responseStatus == responseStatus;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        customerId.hashCode ^
        customerName.hashCode ^
        customerPhone.hashCode ^
        customerAvatar.hashCode ^
        selectedMasterId.hashCode ^
        selectedMasterName.hashCode ^
        selectedMasterAddress.hashCode ^
        selectedMasterStoName.hashCode ^
        selectedMasterAvatar.hashCode ^
        carNationality.hashCode ^
        bodyType.hashCode ^
        typeOfDrive.hashCode ^
        vinNumber.hashCode ^
        engineType.hashCode ^
        enginePower.hashCode ^
        priceFromSelectedMaster.hashCode ^
        orderStatus.hashCode ^
        carId.hashCode ^
        carNumber.hashCode ^
        carBrand.hashCode ^
        carModel.hashCode ^
        specialization.hashCode ^
        specializationAvatar.hashCode ^
        latitude.hashCode ^
        longitude.hashCode ^
        orderDescription.hashCode ^
        dateFrom.hashCode ^
        dateTo.hashCode ^
        time.hashCode ^
        radius.hashCode ^
        responsesCount.hashCode ^
        selectedMasterPhone.hashCode ^
        responseStatus.hashCode;
  }
}
