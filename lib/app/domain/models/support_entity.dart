class SupportEntity {
  String phone;
  String whatsApp;

  SupportEntity({
    required this.phone,
    required this.whatsApp,
  });

  Map<String, dynamic> toJson() {
    return {
      'phone': phone,
      'whatsApp': whatsApp,
    };
  }

  factory SupportEntity.fromJson(Map<String, dynamic> map) {
    return SupportEntity(
      phone: map['phone'] ?? '',
      whatsApp: map['whatsApp'] ?? '',
    );
  }
}
