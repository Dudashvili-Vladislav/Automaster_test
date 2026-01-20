// ignore_for_file: body_might_complete_normally_catch_error

import 'dart:async';
import 'dart:developer';

import 'package:auto_master/app/constatns.dart';
import 'package:auto_master/app/data/api_client.dart';
import 'package:auto_master/app/domain/models/adress_location.dart';
import 'package:auto_master/app/domain/models/direction_details.dart';
import 'package:auto_master/app/ui/utils/show_message.dart';
import 'package:auto_master/resources/resources.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';

import 'package:yandex_mapkit/yandex_mapkit.dart';

class MapState extends ChangeNotifier {
  BuildContext context;
  MapState(this.context, this.toAddress);

  static const frequencyUpdateSeconds = 2;

  bool isLoading = false;
  bool isLocationLoading = false;
  String distance = '';
  late ToAddress toAddress;
  late AddressLocation currentLocation;
  // late StreamSubscription<Position> positionStream;
  final mapControllerCompleter = Completer<YandexMapController>();
  late final List<MapObject> mapObjects = [];
  DirectionDetails? directionDetails;
  YandexMapController? controller;
  double height = 0;
  double width = 0;
  Timer? timer = null;
  // DrivingSessionResult? drivingSessionResult;

  // Overrides -----------------------------------------------------------------

  @override
  void dispose() {
    timer?.cancel();
    // positionStream.cancel();
    super.dispose();
  }

  // Methods -------------------------------------------------------------------

  Future<void> initController(YandexMapController mapController) async {
    controller = mapController;
    await turnOnLocation();
    notifyListeners();
  }

  Future<void> initPermission() async {
    isLocationLoading = true;
    notifyListeners();

    if (!await _checkPermission()) {
      final permissionResult = await _requestPermission();
      if (!permissionResult) {
        showMessage(
            "Без доступа к геолокации точность маршрутизации не доступна");
        return;
      }
    }

    _listenCurrentLocation();

    await _fetchCurrentLocation();
    // if (result) fetchPolyline();

    isLocationLoading = false;
    notifyListeners();
  }

  Future<void> turnOnLocation() async {
    controller?.addListener(() {
      print('listener');
      // controller?.moveCamera(cameraUpdate);
    });
    await controller?.toggleUserLayer(
      visible: true,
      autoZoomEnabled: false,
      headingEnabled: false,
      // anchor: UserLocationAnchor(
      //   course: Offset(0.5 * width, 0.5 * height),
      //   normal: Offset(0.5 * width, 0.5 * height),
      // ),
    );

    await controller?.getUserCameraPosition();
  }

  // Services ------------------------------------------------------------------

  Future<bool> _checkPermission() {
    return Geolocator.checkPermission()
        .then((value) =>
            value == LocationPermission.always ||
            value == LocationPermission.whileInUse)
        .catchError((e) {
      debugPrint("LocationService.requestPermission() Error: $e");
      return false;
    });
  }

  Future<bool> _requestPermission() {
    return Geolocator.requestPermission()
        .then((value) =>
            value == LocationPermission.always ||
            value == LocationPermission.whileInUse)
        .catchError((e) {
      debugPrint("LocationService.requestPermission() Error: $e");
      return false;
    });
  }

  static Future<AddressLocation> getCurrentLocation() async {
    return Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
        .then((value) {
      log('Current location: ${value.latitude} ${value.longitude} ');
      return AddressLocation(
          latitude: value.latitude, longitude: value.longitude);
    }).catchError((e) {
      debugPrint("LocationService.getCurrentLocation() Error: $e");
    });
  }

  void _listenCurrentLocation() async {
    Geolocator.getPositionStream().listen((value) {
      controller?.moveCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: Point(latitude: value.latitude, longitude: value.longitude),
            zoom: 16,
          ),
        ),
        animation: const MapAnimation(),
      );

      // currentLocation =
      //     AddressLocation(latitude: value.latitude, longitude: value.longitude);
      // _addCurrentLocationToMapObjects(
      //   currentLocation,
      //   direction: value.headingAccuracy,
      // );
    });

    // positionStream.onError((e) {
    //   showMessage("LocationService.listenCurrentLocation() Error: $e");
    // });
  }

  void _addToMapObjects({
    required String objectId,
    required Point point,
    required String icon, // not svg
    double scale = 1.5,
    double opacity = 1.0,
    double direction = 0,
  }) {
    mapObjects.add(
      PlacemarkMapObject(
        mapId: MapObjectId(objectId),
        point: point,
        direction: direction,
        icon: PlacemarkIcon.single(
          PlacemarkIconStyle(
            scale: scale,
            image: BitmapDescriptor.fromAssetImage(icon),
          ),
        ),
        opacity: opacity,
      ),
    );

    notifyListeners();
  }

  // void _addCurrentLocationToMapObjects(AddressLocation location,
  //         {double direction = 0}) =>
  //     _addToMapObjects(
  //       objectId: 'current_location',
  //       point: location.toPoint,
  //       icon: Images.navigation,
  //       scale: .12,
  //       direction: direction,
  //     );

  /// from location = current location
  // void _addFromLocationToMapObjects(AddressLocation location) =>
  //     _addToMapObjects(
  //       objectId: 'from_location',
  //       point: location.toPoint,
  //       icon: Images.location,
  //       opacity: 0.5,
  //     );

  void addToLocationToMapObject(AddressLocation location) => _addToMapObjects(
        objectId: 'to_location',
        point: location.toPoint,
        icon: Images.location,
      );

  static Future<Point?> getPointByText(ToAddress toAddress) async {
    final searchSession = YandexSearch.searchByText(
      searchText: toAddress.query,
      geometry: Geometry.fromBoundingBox(
        const BoundingBox(
          northEast: Point(latitude: 63.430757, longitude: 10.394414),
          southWest: Point(
            latitude: 43.064088,
            longitude: 141.347201,
          ),
        ),
      ),
      searchOptions: const SearchOptions(),
    );

    final searchResult = await searchSession.result;

    searchResult.items?.forEach((elREs) {
      elREs.geometry.forEach((elGeo) {
        print('Result ${elREs.name} geo name ${elGeo.point}');
      });
    });

    if ((searchResult.items?.isNotEmpty ?? false) &&
        (searchResult.items?.first.geometry.isNotEmpty ?? false)) {
      final point = searchResult.items!.first.geometry.first.point;
      print(point);
      return point;
    } else {
      return Future.value(null);
    }
  }

  Future<DrivingSessionResult?> getPolyline(ToAddress toAddress) async {
    // try {
    // state.isPolyline = true;
    // final fromIcon = PlacemarkIcon.single(
    //     PlacemarkIconStyle(
    //       scale: scale,
    //       image: BitmapDescriptor.fromAssetImage(icon),
    //     ),
    //   ),
    // final toIcon = BitmapDescriptor.fromBytes(
    //     await getBytesFromAsset(Images.marker, 150));

    // final additionalIcon = BitmapDescriptor.fromBytes(
    //     await getBytesFromAsset(Images.ellipsePng, 64));

    // List<RequestPoint> additionalPoints = [];

    final location = await getCurrentLocation();
    AddressLocation? destination;

    final point = await getPointByText(toAddress);
    if (point != null) {
      destination = AddressLocation(
        latitude: point!.latitude,
        longitude: point!.longitude,
      );
    } else {
      Fluttertoast.showToast(msg: 'Не удалось найти местоположение мастера');
      return Future.value();
    }

    // YandexMap

    addToLocationToMapObject(destination!);

    DrivingResultWithSession? requestRoutes = YandexDriving.requestRoutes(
      points: [
        RequestPoint(
          point: Point(
            latitude: location.latitude,
            longitude: location.longitude,
          ),
          requestPointType: RequestPointType.wayPoint,
        ),
        RequestPoint(
          point: Point(
            latitude: destination.latitude,
            longitude: destination.longitude,
          ),
          requestPointType: RequestPointType.wayPoint,
        ),
      ],
      drivingOptions: const DrivingOptions(
        initialAzimuth: 0,
        routesCount: 1,
        avoidTolls: true,
      ),
    );

    DrivingSessionResult? drivingSessionResult = await requestRoutes.result;

    // drivingSessionResult = drivingSessionResult;
    MapObjectId mapObjectId = const MapObjectId('polyline');
    final mapObject = PolylineMapObject(
      mapId: mapObjectId,
      polyline: Polyline(
        points: drivingSessionResult.routes!.first.geometry
            .map(
              (e) => Point(
                latitude: e.latitude,
                longitude: e.longitude,
              ),
            )
            .toList(),
      ),
      strokeColor: Colors.red,
      strokeWidth: 2,
      outlineColor: Colors.white,
      outlineWidth: 1,
      turnRadius: 15.0,
      arcApproximationStep: 1.0,
      gradientLength: 1.0,
      isInnerOutlineEnabled: true,
    );
    mapObjects.add(mapObject);
    // if (drivingSessionResult != null) {

    //   List<PlacemarkMapObject> additionalMarkers = [];

    //   state.markers = [
    //     PlacemarkMapObject(
    //       mapId: const MapObjectId('placemark_start'),
    //       point: Point(
    //         latitude:
    //             drivingSessionResult.routes!.first.geometry.first.latitude,
    //         longitude:
    //             drivingSessionResult.routes!.first.geometry.first.longitude,
    //       ),
    //       opacity: 1,
    //       icon: PlacemarkIcon.single(PlacemarkIconStyle(image: fromIcon)),
    //     ),
    //     ...additionalMarkers,
    //     PlacemarkMapObject(
    //       mapId: const MapObjectId('placemark_end'),
    //       point: Point(
    //         latitude:
    //             drivingSessionResult.routes!.first.geometry.last.latitude,
    //         longitude:
    //             drivingSessionResult.routes!.first.geometry.last.longitude,
    //       ),
    //       opacity: 1,
    //       icon: PlacemarkIcon.single(
    //         PlacemarkIconStyle(image: toIcon),
    //       ),
    //     ),
    //   ];
    // } else {
    //   state.isPolyline = false;
    // }

    // emit(state.copyWith(
    //   isPolyline: state.isPolyline,
    //   totalDistance: state.totalDistance,
    //   routeTime: state.routeTime,
    //   routeTimeString: state.routeTimeString,
    // ));
    // } catch (e) {
    //   inspect(e);
    // }
    log('Driving: $drivingSessionResult');
    return drivingSessionResult;
  }

  Future<void> drawPolyline({bool needZoom = true}) async {
    DrivingSessionResult? drivingSessionResult = await getPolyline(toAddress);

    log(drivingSessionResult.toString());

    if (drivingSessionResult != null) {
      distance =
          '${(drivingSessionResult.routes!.first.metadata.weight.distance.value! / 1000).toStringAsFixed(2)} км';
      controller?.moveCamera(
        CameraUpdate.newBounds(
          BoundingBox(
            northEast: Point(
              latitude:
                  drivingSessionResult.routes!.first.geometry.first.latitude,
              longitude:
                  drivingSessionResult.routes!.first.geometry.first.longitude,
            ),
            southWest: Point(
              latitude:
                  drivingSessionResult.routes!.first.geometry.last.latitude,
              longitude:
                  drivingSessionResult.routes!.first.geometry.last.longitude,
            ),
          ),
        ),
      );
      notifyListeners();
    }

    // if (needZoom) {
    //   await controller?.moveCamera(CameraUpdate.zoomOut(),
    //       animation: const MapAnimation());
    // }
  }

  // void _zoomCameraToFitPolylineOnScreen(
  //     List<Point> points, double distanceInMeters) async {
  //   if (points.length < 2) {
  //     return;
  //   }

  //   // Calculate the bounding box of the polyline
  //   // approximately 0.000001 per kilometer.
  //   late double bboxMargin;
  //   if (distanceInMeters <= 1000) {
  //     bboxMargin = 0.001;
  //   } else {
  //     bboxMargin = distanceInMeters > 50000
  //         ? distanceInMeters * 0.000001
  //         : distanceInMeters * 0.0000015;
  //   }

  //   final lats = points.map((p) => p.latitude);
  //   final lons = points.map((p) => p.longitude);

  //   final northEast = Point(
  //       latitude: lats.reduce(max) + bboxMargin,
  //       longitude: lons.reduce(max) + bboxMargin);
  //   final southWest = Point(
  //       latitude: lats.reduce(min) - bboxMargin,
  //       longitude: lons.reduce(min) - bboxMargin);

  //   final bbox = BoundingBox(northEast: northEast, southWest: southWest);

  //   var mapController = await mapControllerCompleter.future;

  //   // Calculate the zoom level required to fit the polyline on the screen
  //   mapController.moveCamera(
  //     animation: const MapAnimation(type: MapAnimationType.smooth, duration: 1),
  //     CameraUpdate.newCameraPosition(
  //       CameraPosition(
  //         target: Point(
  //           latitude: (bbox.northEast.latitude + bbox.southWest.latitude) / 2,
  //           longitude:
  //               (bbox.northEast.longitude + bbox.southWest.longitude) / 2,
  //         ),
  //         // zoom: 15,
  //       ),
  //     ),
  //   );

  //   // Set bounding box
  //   mapController.moveCamera(
  //     animation: const MapAnimation(type: MapAnimationType.smooth, duration: 1),
  //     CameraUpdate.newBounds(bbox),
  //   );
  // }

  // APIs ----------------------------------------------------------------------

  Future<bool> _fetchCurrentLocation() async {
    try {
      // controller.get
      final location = await getCurrentLocation();
      currentLocation = location;
      // _addCurrentLocationToMapObjects(location);
      timer = Timer.periodic(const Duration(seconds: frequencyUpdateSeconds),
          (timer) {
        print('Update current location');
        Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
      });
      // Future.delayed(const Duration(seconds: frequencyUpdateSeconds)).then((_) {
      //   print('Update current location');
      //   // if (context.mounted) _addCurrentLocationToMapObjects(location);
      // });
      return true;
    } catch (e) {
      log("_fetchCurrentLocation error: $e");
      return false;
    }
  }

  // Future<void> fetchPolyline() async {
  //   // #add points (direction) to map
  //   final List<Point> points = [];

  //   directionDetails =
  //       await _fetchDirectionDetails(currentLocation, departureLocation);
  //   if (directionDetails == null || directionDetails!.encodedPoints.isEmpty) {
  //     showMessage("Ошибка: Слишком большое расстояние");
  //     return;
  //   }

  //   for (var point
  //       in PolylinePoints().decodePolyline(directionDetails!.encodedPoints)) {
  //     points.add(Point(latitude: point.latitude, longitude: point.longitude));
  //   }

  //   final mapObject = PolylineMapObject(
  //     mapId: const MapObjectId('polyline'),
  //     polyline: Polyline(points: points),
  //     strokeColor: AppColors.grey,
  //   );

  //   mapObjects.add(mapObject);
  //   notifyListeners();

  //   _zoomCameraToFitPolylineOnScreen(
  //       points, directionDetails!.distanceInMeters);
  // }

  Future<DirectionDetails?> _fetchDirectionDetails(
      AddressLocation start, AddressLocation end) async {
    try {
      final response = await ApiClient().dio(context).get(
        directionDetailsAPI(start, end),
        queryParameters: {'geometries': 'polyline'},
      );

      final data = response.data;

      return DirectionDetails(
        encodedPoints: data['routes'][0]['geometry'],
        durationInSeconds:
            double.parse(data['routes'][0]['duration'].toString()),
        distanceInMeters:
            double.parse(data['routes'][0]['distance'].toString()),
      );
    } catch (e) {
      debugPrint("LocationService.getDirectionDetails() Error: $e");
      return null;
    }
  }
}
