import 'dart:convert';

class BodyTypes {
  final int id;
  final String bodyType;
  final String icon;

  BodyTypes({
    required this.id,
    required this.bodyType,
    required this.icon,
  });

  factory BodyTypes.fromRawJson(String str) =>
      BodyTypes.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory BodyTypes.fromJson(Map<String, dynamic> json) => BodyTypes(
        id: json["id"],
        bodyType: json["bodyType"],
        icon: json["icon"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "bodyType": bodyType,
        "icon": icon,
      };
}
