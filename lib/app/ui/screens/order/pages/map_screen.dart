import 'package:back_button_interceptor/back_button_interceptor.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:yandex_mapkit/yandex_mapkit.dart';

import 'package:auto_master/app/domain/models/adress_location.dart';
import 'package:auto_master/app/domain/states/customer/map_state.dart';
import 'package:auto_master/app/ui/theme/theme.dart';
import 'package:auto_master/app/ui/widgets/widgets.dart';
import 'package:auto_master/resources/resources.dart';

class MapScreen extends StatefulWidget {
  final ToAddress toAddress;
  final String stoName;
  final String masterAvatar;
  final String masterName;
  final String address;
  final String phone;
  final int orderId;
  final int masterId;
  const MapScreen({
    Key? key,
    required this.toAddress,
    required this.stoName,
    required this.masterAvatar,
    required this.masterName,
    required this.address,
    this.phone = '',
    required this.orderId,
    required this.masterId,
  }) : super(key: key);

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  late YandexMapController mapController;
  bool isNotifyExist = false;
  bool isMapLoaded = false;
  bool isUserLocationSet = false;

  GlobalKey mapKey = GlobalKey();

  @override
  void dispose() {
    BackButtonInterceptor.remove(myInterceptor);
    super.dispose();
  }

  bool myInterceptor(bool stopDefaultButtonEvent, RouteInfo info) {
    Navigator.pop(context);
    return true;
  }

  @override
  void initState() {
    super.initState();
    BackButtonInterceptor.add(myInterceptor);

    Future.microtask(() async {
      final read = context.read<MapState>();
      read.toAddress = widget.toAddress;
      // read.addToLocationToMapObject(widget.toAddress);
      read.initPermission();
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<MapState>();
    final read = context.read<MapState>();

    // #set disnace
    // String distance = '';
    // if (state.directionDetails != null) {
    //   final inMeters = read.directionDetails!.distanceInMeters < 1000;
    //   final distanceValue = inMeters
    //       ? read.directionDetails!.distanceInMeters
    //       : read.directionDetails!.distanceInKilometers;
    //   distance =
    //       '${distanceValue.toStringAsFixed(2)}${inMeters ? " м" : " км"}';
    // }
    return Scaffold(
      body: Stack(
        children: [
          YandexMap(
            key: mapKey,
            mapObjects: state.mapObjects,
            onMapCreated: (controller) async {
              mapController = controller;
              read.mapControllerCompleter.complete(controller);

              final mediaQuery = MediaQuery.of(context);
              final height = mapKey.currentContext!.size!.height *
                  mediaQuery.devicePixelRatio;
              final width = mapKey.currentContext!.size!.width *
                  mediaQuery.devicePixelRatio;
              read.height = height;
              read.width = width;
              await read.initController(controller);
              await read.drawPolyline();
              // controller.c
              setState(() {
                isMapLoaded = true;
              });
            },
            onUserLocationAdded: (view) async {
              // view.arrow.
              setState(() {
                isUserLocationSet = true;
              });

              // final cameraPos = await read.controller?.getUserCameraPosition();
              // read.controller?.moveCamera(
              //   CameraUpdate.newCameraPosition(
              //     cameraPos!.copyWith(zoom: 15),
              //   ),
              // );

              return view.copyWith(
                  pin: view.pin.copyWith(
                    isVisible: false,
                    opacity: 0,
                    // icon: PlacemarkIcon.single(
                    //   PlacemarkIconStyle(image: BitmapDescriptor.fromAssetImage('lib/assets/user.png'))
                    // )
                  ),
                  // pin: P
                  // accuracyCircle: null,
                  arrow: view.arrow.copyWith(
                    opacity: 1,
                    icon: PlacemarkIcon.single(
                      PlacemarkIconStyle(
                        image: BitmapDescriptor.fromAssetImage(
                          Images.navigation,
                        ),
                        // a
                        rotationType: RotationType.rotate,
                        scale: 0.18,
                      ),
                    ),
                  ),
                  accuracyCircle: view.accuracyCircle.copyWith(
                    isVisible: false,
                    // opacity: 0,
                    // fillColor: Colors.green.withOpacity(0.5)
                  ));
              // print('onUserLocationAdded');
            },
            onCameraPositionChanged: (cameraPosition, reason, finished) async {
              // final distance = calculateDistance(
              //   cameraPosition.target.latitude,
              //   cameraPosition.target.longitude,
              //   widget.departure.latitude,
              //   widget.departure.longitude,
              // ).round();
              // if (distance <= 1 && isNotifyExist) {
              //   final date = DateTime.now().add(const Duration(hours: 1));
              //   await localNotifyService.scheduleNotification(
              //     widget.masterName,
              //     widget.masterAvatar,
              //     widget.address,
              //     widget.phone,
              //     widget.orderId,
              //     widget.masterId,
              //     date,
              //   );
              //   isNotifyExist = true;
              //   if (mounted) setState(() {});
              // }
            },
            logoAlignment: const MapAlignment(
              horizontal: HorizontalAlignment.center,
              vertical: VerticalAlignment.top,
            ),
          ),
          if (!(isMapLoaded && isUserLocationSet))
            Container(
              width: double.infinity,
              height: double.infinity,
              color: Colors.white,
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const CircularProgressIndicator(
                      strokeWidth: 5,
                      valueColor: AlwaysStoppedAnimation(
                        AppColors.main,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Карта загружается',
                      textAlign: TextAlign.center,
                      style:
                          AppTextStyle.s18w400B.copyWith(color: AppColors.main),
                    ),
                  ],
                ),
              ),
            ),
          const SafeArea(
            child: Padding(
              padding: EdgeInsets.all(15.0),
              child: CustomIconButton(),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: SafeArea(
              child: BottomCard(
                stoName: widget.stoName,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class BottomCard extends StatefulWidget {
  final String stoName;

  const BottomCard({super.key, required this.stoName});

  @override
  State<StatefulWidget> createState() => _BottomCardState();
}

class _BottomCardState extends State<BottomCard> {
  // double currentHeight = 150.0;

  bool isBig = true;

  @override
  Widget build(BuildContext context) {
    return
        //  AnimatedContainer(
        //   duration: const Duration(milliseconds: 1000),
        //   child:
        SizedBox(
      height: 152,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: EdgeInsets.only(top: isBig ? 0 : 100),
        height: 152, // isBig ? 152.0 : 52, // currentHeight,
        width: double.infinity,
        padding: const EdgeInsets.only(
          top: 16.0,
          left: 35.0,
          right: 35.0,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.vertical(
            top: Radius.circular(40.0),
          ),
          boxShadow: [
            BoxShadow(blurRadius: 10, color: Colors.black.withAlpha(25)),
          ],
        ),
        child: isBig
            ? BottomFullBody(
                onPressed: () {
                  setState(() {
                    isBig = !isBig;
                  });
                },
                stoName: widget.stoName,
              )
            : BottomSmallBody(
                onPressed: () {
                  setState(() {
                    isBig = !isBig;
                  });
                },
              ),
      ),
      // ),
    );
  }
}

class BottomFullBody extends StatelessWidget {
  const BottomFullBody({super.key, this.onPressed, required this.stoName});

  final void Function()? onPressed;
  final String stoName;

  @override
  Widget build(BuildContext context) {
    final state = context.watch<MapState>();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        SizedBox(
          height: 32,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                stoName,
                style: AppTextStyle.s24w600.copyWith(
                  color: Colors.black,
                ),
              ),
              Align(
                alignment: Alignment.topRight,
                child: IconButton(
                  padding: EdgeInsets.zero,
                  constraints: BoxConstraints(),
                  onPressed: onPressed,
                  icon: SvgPicture.asset(
                    Svgs.close,
                    height: 12,
                    width: 12,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 14.0),
        Row(
          children: <Widget>[
            SvgPicture.asset(Svgs.gps),
            Text(
              ' Осталось ехать > ${state.distance}',
              style: AppTextStyle.s12w400.copyWith(
                color: AppColors.grey,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class BottomSmallBody extends StatelessWidget {
  const BottomSmallBody({super.key, this.onPressed});

  final void Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    final state = context.watch<MapState>();
    return GestureDetector(
      onTap: onPressed,
      child: SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SvgPicture.asset(Svgs.gps),
            Text(
              ' Осталось ехать > ${state.distance}',
              style: AppTextStyle.s12w400.copyWith(
                color: AppColors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Header extends StatelessWidget {
  const Header({
    Key? key,
    required this.title,
    this.children,
    required this.subtitle,
  }) : super(key: key);

  final String title;
  final List<Widget>? children;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        const CustomIconButton(),
        const SizedBox(height: 20.0),
        Text(
          title,
          textAlign: TextAlign.center,
          style: AppTextStyle.s32w600,
        ),
        if (children == null) const SizedBox(height: 35.0) else ...children!,
        Text(
          subtitle,
          textAlign: TextAlign.center,
          style: AppTextStyle.s14w400.copyWith(
            color: AppColors.black,
          ),
        ),
      ],
    );
  }
}
