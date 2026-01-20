// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:yandex_mapkit/yandex_mapkit.dart';

class AddressLocation {
  double latitude;
  double longitude;
  // String? placeName;
  // String? placeId;
  // String? placeFormattedName;

  AddressLocation({
    required this.latitude,
    required this.longitude,
    // this.placeName,
    // this.placeId,
    // this.placeFormattedName,
  });

  // Map<String, dynamic> toMap() {
  //   return <String, dynamic>{
  //     'latitude': latitude,
  //     'longitude': longitude,
  //     'placeName': placeName,
  //     'placeId': placeId,
  //     'placeFormattedName': placeFormattedName,
  //   };
  // }

  Point get toPoint => Point(latitude: latitude, longitude: longitude);

  static AddressLocation fromPoint(Point point) =>
      AddressLocation(latitude: point.latitude, longitude: point.longitude);

  @override
  String toString() {
    return 'AddressLocation(latitude: $latitude, longitude: $longitude)'; //placeName: $placeName, placeId: $placeId, placeFormattedName: $placeFormattedName
  }
}

class ToAddress {
  final String query;

  const ToAddress(this.query);
}
