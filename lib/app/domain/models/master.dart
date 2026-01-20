// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'master.g.dart';

@JsonSerializable()
@CopyWith()
class MasterEntity {
  int id;
  int? extraCustomerId;
  @JsonKey(defaultValue: '')
  String name;
  // @JsonKey(defaultValue: '')
  String phone;
  String? avatarUrl;
  @JsonKey(defaultValue: '')
  String specialization;
  @JsonKey(defaultValue: '')
  String countryCar;
  @JsonKey(defaultValue: '')
  String workAddress;
  @JsonKey(defaultValue: '')
  String stoName;
  @JsonKey(defaultValue: '')
  String workDescription;
  @JsonKey(defaultValue: '')
  String bearerToken;
  @JsonKey(defaultValue: '')
  String registrationDate;
  @JsonKey(defaultValue: '')
  String status;
  @JsonKey(defaultValue: '')
  String extraStatus;
  @JsonKey(defaultValue: '')
  String experience;
  double? latitude;
  double? longitude;
  String? rating;
  String? pushToken;
  String? extraSpecialization;

  MasterEntity({
    required this.id,
    this.extraCustomerId,
    required this.name,
    required this.phone,
    this.avatarUrl,
    required this.specialization,
    required this.countryCar,
    required this.workAddress,
    required this.stoName,
    required this.workDescription,
    required this.bearerToken,
    required this.registrationDate,
    required this.status,
    required this.extraStatus,
    required this.experience,
    this.latitude,
    this.longitude,
    this.rating,
    this.pushToken,
    this.extraSpecialization,
  });

  Map<String, dynamic> toJson() => _$MasterEntityToJson(this);

  factory MasterEntity.fromJson(Map<String, dynamic> json) =>
      _$MasterEntityFromJson(json);

  // MasterEntity copyWith({
  //   int? id,
  //   int? extraCustomerId,
  //   String? name,
  //   String? phone,
  //   String? avatarUrl,
  //   String? specialization,
  //   String? countryCar,
  //   String? workAddress,
  //   String? stoName,
  //   String? workDescription,
  //   String? bearerToken,
  //   String? registrationDate,
  //   String? status,
  //   String? extraStatus,
  //   String? experience,
  //   double? latitude,
  //   double? longitude,
  //   String? rating,
  //   String? pushToken,
  // }) {
  //   return MasterEntity(
  //     id: id ?? this.id,
  //     extraCustomerId: extraCustomerId ?? this.extraCustomerId,
  //     name: name ?? this.name,
  //     phone: phone ?? this.phone,
  //     avatarUrl: avatarUrl ?? this.avatarUrl,
  //     specialization: specialization ?? this.specialization,
  //     countryCar: countryCar ?? this.countryCar,
  //     workAddress: workAddress ?? this.workAddress,
  //     stoName: stoName ?? this.stoName,
  //     workDescription: workDescription ?? this.workDescription,
  //     bearerToken: bearerToken ?? this.bearerToken,
  //     registrationDate: registrationDate ?? this.registrationDate,
  //     status: status ?? this.status,
  //     extraStatus: extraStatus ?? this.extraStatus,
  //     experience: experience ?? this.experience,
  //     latitude: latitude ?? this.latitude,
  //     longitude: longitude ?? this.longitude,
  //     rating: rating ?? this.rating,
  //     pushToken: pushToken ?? this.pushToken,
  //   );
  // }
}
