// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'accessories_entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Accessories _$AccessoriesFromJson(Map<String, dynamic> json) => Accessories(
      accessoryCategoryId: json['accessoryCategoryId'] as int,
      nameOfAccessoriesCategory:
          json['nameOfAccessoriesCategory'] as String? ?? '',
      avatarOfAccessoriesCategory:
          json['avatarOfAccessoriesCategory'] as String?,
      list: (json['list'] as List<dynamic>?)
          ?.map((e) => Accessory.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$AccessoriesToJson(Accessories instance) =>
    <String, dynamic>{
      'accessoryCategoryId': instance.accessoryCategoryId,
      'nameOfAccessoriesCategory': instance.nameOfAccessoriesCategory,
      'avatarOfAccessoriesCategory': instance.avatarOfAccessoriesCategory,
      'list': instance.list,
    };

Accessory _$AccessoryFromJson(Map<String, dynamic> json) => Accessory(
      id: json['id'] as int,
      idOfAccessoriseCategorise: json['idOfAccessoriseCategorise'] as int,
      name: json['name'] as String? ?? '',
      image: json['image'] as String?,
      description: json['description'] as String? ?? '',
    );

Map<String, dynamic> _$AccessoryToJson(Accessory instance) => <String, dynamic>{
      'id': instance.id,
      'idOfAccessoriseCategorise': instance.idOfAccessoriseCategorise,
      'name': instance.name,
      'image': instance.image,
      'description': instance.description,
    };
