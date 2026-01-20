class Address {
  String value;
  String unrestrictedValue;
  String country;
  String city;
  String geoLat;
  String geoLon;

  Address({
    required this.value,
    required this.unrestrictedValue,
    required this.country,
    required this.city,
    required this.geoLat,
    required this.geoLon,
  });

  Map<String, dynamic> toMap() {
    return {
      'value': value,
      'unrestrictedValue': unrestrictedValue,
      'country': country,
      'city': city,
      'geoLat': geoLat,
      'geoLon': geoLon,
    };
  }

  factory Address.fromJson(Map<String, dynamic> map) {
    return Address(
      value: map['value'] ?? '',
      unrestrictedValue: map['unrestricted_value'] ?? '',
      country: map['data']['country'] ?? '',
      city: map['data']['city'] ?? '',
      geoLat: map['data']['geoLat'] ?? '',
      geoLon: map['data']['geoLon'] ?? '',
    );
  }
}
