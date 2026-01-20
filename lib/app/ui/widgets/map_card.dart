import 'dart:async';

import 'package:flutter/cupertino.dart';

import 'package:yandex_mapkit/yandex_mapkit.dart';

class MapCard extends StatefulWidget {
  final Point destinationPoint;

  const MapCard({
    required this.destinationPoint,
    super.key,
  });

  @override
  State<MapCard> createState() => _MapCardState();
}

class _MapCardState extends State<MapCard> {
  final mapControllerCompleter = Completer<YandexMapController>();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 131,
      width: double.infinity,
      child: YandexMap(
        onMapCreated: (controller) {
          mapControllerCompleter.complete(controller);
          controller.moveCamera(
            CameraUpdate.newCameraPosition(
              CameraPosition(target: widget.destinationPoint),
            ),
          );
        },
        logoAlignment: const MapAlignment(
          horizontal: HorizontalAlignment.left,
          vertical: VerticalAlignment.bottom,
        ),
        zoomGesturesEnabled: false,
        fastTapEnabled: false,
        scrollGesturesEnabled: false,
        tiltGesturesEnabled: false,
        rotateGesturesEnabled: false,
      ),
    );
  }
}
