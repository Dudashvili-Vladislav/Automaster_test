import 'package:json_annotation/json_annotation.dart';

part 'order_response_entity.g.dart';

@JsonSerializable()
class OrderResponseEntity {
  int id;
  int orderId;
  int customerId;
  @JsonKey(defaultValue: '')
  String nameOfMaster;
  String? avatarOfMaster;
  @JsonKey(defaultValue: '')
  String stoName;
  double? latitude;
  double? longitude;
  num rating;
  @JsonKey(defaultValue: '')
  String address;
  num priceFromMaster;
  @JsonKey(defaultValue: '')
  String masterDescription;
  String experience;
  String masterPhone;
  @JsonKey(includeFromJson: false, includeToJson: false)
  int km;

  OrderResponseEntity({
    required this.id,
    required this.orderId,
    required this.customerId,
    required this.nameOfMaster,
    this.avatarOfMaster,
    required this.stoName,
    this.latitude,
    this.longitude,
    required this.rating,
    required this.address,
    required this.priceFromMaster,
    required this.masterDescription,
    required this.experience,
    required this.masterPhone,
    this.km = 0,
  });

  Map<String, dynamic> toJson() => _$OrderResponseEntityToJson(this);

  factory OrderResponseEntity.fromJson(Map<String, dynamic> json) =>
      _$OrderResponseEntityFromJson(json);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is OrderResponseEntity &&
        other.id == id &&
        other.orderId == orderId &&
        other.customerId == customerId &&
        other.nameOfMaster == nameOfMaster &&
        other.avatarOfMaster == avatarOfMaster &&
        other.stoName == stoName &&
        other.latitude == latitude &&
        other.longitude == longitude &&
        other.rating == rating &&
        other.address == address &&
        other.priceFromMaster == priceFromMaster &&
        other.masterDescription == masterDescription &&
        other.experience == experience;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        orderId.hashCode ^
        customerId.hashCode ^
        nameOfMaster.hashCode ^
        avatarOfMaster.hashCode ^
        stoName.hashCode ^
        latitude.hashCode ^
        longitude.hashCode ^
        rating.hashCode ^
        address.hashCode ^
        priceFromMaster.hashCode ^
        masterDescription.hashCode ^
        experience.hashCode;
  }

  OrderResponseEntity copyWith({
    int? id,
    int? orderId,
    int? customerId,
    String? nameOfMaster,
    String? avatarOfMaster,
    String? stoName,
    double? latitude,
    double? longitude,
    num? rating,
    String? address,
    num? priceFromMaster,
    String? masterDescription,
    String? experience,
    String? masterPhone,
    int? km,
  }) {
    return OrderResponseEntity(
      id: id ?? this.id,
      orderId: orderId ?? this.orderId,
      customerId: customerId ?? this.customerId,
      nameOfMaster: nameOfMaster ?? this.nameOfMaster,
      avatarOfMaster: avatarOfMaster ?? this.avatarOfMaster,
      stoName: stoName ?? this.stoName,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      rating: rating ?? this.rating,
      address: address ?? this.address,
      priceFromMaster: priceFromMaster ?? this.priceFromMaster,
      masterDescription: masterDescription ?? this.masterDescription,
      experience: experience ?? this.experience,
      masterPhone: masterPhone ?? this.masterPhone,
      km: km ?? this.km,
    );
  }
}
