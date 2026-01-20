import 'package:json_annotation/json_annotation.dart';

part 'customer_order_entity.g.dart';

@JsonSerializable()
class CustomerOrderEntity {
  int id;
  int customerId;
  int? selectedMasterId;
  String? selectedMasterName;
  String? selectedMasterAvatar;
  String? selectedMasterAddress;
  String? selectedMasterStoName;
  String? selectedMasterPhone;
  String? paymentStatus;
  String orderStatus;
  int carId;
  String carNumber;
  String carBrand;
  String carModel;
  String specialization;
  String specializationAvatar;
  double? latitude;
  double? longitude;
  String orderDescription;
  String dateFrom;
  String? dateTo;
  String time;
  int radius;
  int? responsesCount;

  CustomerOrderEntity({
    required this.id,
    required this.customerId,
    this.selectedMasterId,
    this.selectedMasterName,
    this.selectedMasterAvatar,
    this.paymentStatus,
    required this.orderStatus,
    required this.carId,
    required this.carNumber,
    required this.carBrand,
    required this.carModel,
    required this.specialization,
    required this.specializationAvatar,
    required this.latitude,
    required this.longitude,
    required this.orderDescription,
    required this.dateFrom,
    this.dateTo,
    required this.time,
    required this.radius,
    this.responsesCount,
  });

  Map<String, dynamic> toJson() => _$CustomerOrderEntityToJson(this);

  factory CustomerOrderEntity.fromJson(Map<String, dynamic> json) =>
      _$CustomerOrderEntityFromJson(json);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is CustomerOrderEntity &&
        other.id == id &&
        other.customerId == customerId &&
        other.selectedMasterId == selectedMasterId &&
        other.selectedMasterName == selectedMasterName &&
        other.selectedMasterAvatar == selectedMasterAvatar &&
        other.selectedMasterPhone == selectedMasterPhone &&
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
        other.responsesCount == responsesCount;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        customerId.hashCode ^
        selectedMasterId.hashCode ^
        selectedMasterName.hashCode ^
        selectedMasterAvatar.hashCode ^
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
        selectedMasterPhone.hashCode ^
        responsesCount.hashCode;
  }
}
