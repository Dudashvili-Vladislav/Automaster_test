import 'package:flutter/foundation.dart';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class Spec {
  String iconName;
  String nameOfCategory;
  List<String>? listOfSubCategory;
  bool carModelStatus;

  Spec({
    required this.iconName,
    required this.nameOfCategory,
    this.listOfSubCategory,
    required this.carModelStatus,
  });

  Map<String, dynamic> toJson() {
    return {
      'iconName': iconName,
      'nameOfCategory': nameOfCategory,
      'listOfSubCategory': listOfSubCategory,
      'carModelStatus': carModelStatus,
    };
  }

  factory Spec.fromJson(Map<String, dynamic> map) {
    return Spec(
      carModelStatus: map['carModelStatus'] ?? false,
      iconName: map['iconName'] ?? '',
      nameOfCategory: map['nameOfCategory'] ?? '',
      listOfSubCategory: List<String>.from(map['listOfSubCategory']),
    );
  }

  @override
  bool operator ==(covariant Spec other) {
    if (identical(this, other)) return true;

    return other.iconName == iconName &&
        other.nameOfCategory == nameOfCategory &&
        listEquals(other.listOfSubCategory, listOfSubCategory) &&
        other.carModelStatus == carModelStatus;
  }

  @override
  int get hashCode {
    return iconName.hashCode ^
        nameOfCategory.hashCode ^
        listOfSubCategory.hashCode ^
        carModelStatus.hashCode;
  }
}
