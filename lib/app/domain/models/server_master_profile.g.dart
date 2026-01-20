// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'server_master_profile.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ServerMasterProfile _$ServerMasterProfileFromJson(Map<String, dynamic> json) =>
    ServerMasterProfile(
      avatarUrl: json['avatarUrl'] as String?,
      name: json['name'] as String,
      phone: json['phone'] as String,
    );

Map<String, dynamic> _$ServerMasterProfileToJson(
        ServerMasterProfile instance) =>
    <String, dynamic>{
      'name': instance.name,
      'phone': instance.phone,
      'avatarUrl': instance.avatarUrl,
    };
