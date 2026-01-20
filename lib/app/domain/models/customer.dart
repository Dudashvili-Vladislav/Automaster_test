import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';

import 'package:auto_master/app/domain/models/customer_car.dart';

part 'customer.g.dart';

@JsonSerializable()
class CustomerEntity {
  String? avatarUrl;
  @JsonKey(defaultValue: '')
  String name;
  String phone;
  @JsonKey(defaultValue: '')
  String masterStatus;
  List<CustomerCarEntity>? carsList;

  CustomerEntity({
    required this.avatarUrl,
    required this.name,
    required this.phone,
    required this.masterStatus,
    required this.carsList,
  });

  Map<String, dynamic> toJson() => _$CustomerEntityToJson(this);

  factory CustomerEntity.fromJson(Map<String, dynamic> json) =>
      _$CustomerEntityFromJson(json);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is CustomerEntity &&
        other.avatarUrl == avatarUrl &&
        other.name == name &&
        other.phone == phone &&
        listEquals(other.carsList, carsList);
  }

  @override
  int get hashCode {
    return avatarUrl.hashCode ^
        name.hashCode ^
        phone.hashCode ^
        carsList.hashCode;
  }

  CustomerEntity copyWith({
    String? avatarUrl,
    String? name,
    String? phone,
    String? masterStatus,
    List<CustomerCarEntity>? carsList,
  }) {
    return CustomerEntity(
      avatarUrl: avatarUrl ?? this.avatarUrl,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      masterStatus: masterStatus ?? this.masterStatus,
      carsList: carsList ?? this.carsList,
    );
  }
}
