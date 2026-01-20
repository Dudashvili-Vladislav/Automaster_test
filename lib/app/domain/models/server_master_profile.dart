import 'package:json_annotation/json_annotation.dart';

part 'server_master_profile.g.dart';

@JsonSerializable()
class ServerMasterProfile {
  final String name;
  final String phone;
  final String? avatarUrl;

  const ServerMasterProfile({
    required this.avatarUrl,
    required this.name,
    required this.phone,
  });

  Map<String, dynamic> toJson() => _$ServerMasterProfileToJson(this);

  factory ServerMasterProfile.fromJson(Map<String, dynamic> json) =>
      _$ServerMasterProfileFromJson(json);
}
