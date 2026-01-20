import 'package:json_annotation/json_annotation.dart';

part 'accessories_entity.g.dart';

@JsonSerializable()
class Accessories {
  int accessoryCategoryId;
  @JsonKey(defaultValue: '')
  String nameOfAccessoriesCategory;
  String? avatarOfAccessoriesCategory;
  List<Accessory>? list;

  Accessories({
    required this.accessoryCategoryId,
    required this.nameOfAccessoriesCategory,
    this.avatarOfAccessoriesCategory,
    this.list,
  });

  Map<String, dynamic> toJson() => _$AccessoriesToJson(this);

  factory Accessories.fromJson(Map<String, dynamic> json) =>
      _$AccessoriesFromJson(json);
}

@JsonSerializable()
class Accessory {
  int id;
  int idOfAccessoriseCategorise;
  @JsonKey(defaultValue: '')
  String name;
  String? image;
  @JsonKey(defaultValue: '')
  String description;

  Accessory({
    required this.id,
    required this.idOfAccessoriseCategorise,
    required this.name,
    this.image,
    required this.description,
  });

  Map<String, dynamic> toJson() => _$AccessoryToJson(this);

  factory Accessory.fromJson(Map<String, dynamic> json) =>
      _$AccessoryFromJson(json);
}
