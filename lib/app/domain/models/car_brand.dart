class CarBrand {
  String id;
  String name;
  String nameRu;

  CarBrand({
    required this.id,
    required this.name,
    required this.nameRu,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'nameRu': nameRu,
    };
  }

  factory CarBrand.fromJson(Map<String, dynamic> map) {
    return CarBrand(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      nameRu: map['name_ru'] ?? '',
    );
  }
}
