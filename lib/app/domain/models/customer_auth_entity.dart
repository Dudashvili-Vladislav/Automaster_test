import 'package:json_annotation/json_annotation.dart';

part 'customer_auth_entity.g.dart';

@JsonSerializable()
class CustomerAuthEntity {
  int id;
  int? extraMasterId;
  @JsonKey(defaultValue: '')
  String name;
  String phone;
  String? avatarUrl;
  String bearerToken;
  @JsonKey(defaultValue: '')
  String registrationDate;
  @JsonKey(defaultValue: '')
  String status;
  dynamic latitude;
  dynamic longitude;
  num? balance;
  String? pushToken;

  CustomerAuthEntity({
    required this.id,
    this.extraMasterId,
    required this.name,
    required this.phone,
    this.avatarUrl,
    required this.bearerToken,
    required this.registrationDate,
    required this.status,
    this.latitude,
    this.longitude,
    this.balance,
    this.pushToken,
  });

  Map<String, dynamic> toJson() => _$CustomerAuthEntityToJson(this);

  factory CustomerAuthEntity.fromJson(Map<String, dynamic> json) =>
      _$CustomerAuthEntityFromJson(json);
}
