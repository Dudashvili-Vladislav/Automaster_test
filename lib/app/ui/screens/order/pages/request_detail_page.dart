// ignore_for_file: use_build_context_synchronously

import 'dart:ui';

import 'package:auto_master/app/domain/models/adress_location.dart';
import 'package:auto_master/app/domain/states/customer/map_state.dart';
import 'package:auto_master/app/domain/states/customer/orders_state.dart';
import 'package:auto_master/app/ui/routes/routes.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import 'package:auto_master/app/app.dart';
import 'package:auto_master/app/data/api_client.dart';
import 'package:auto_master/app/domain/models/order_response_entity.dart';
import 'package:auto_master/app/domain/service/customer_service.dart';
import 'package:auto_master/app/ui/theme/theme.dart';
import 'package:auto_master/app/ui/widgets/map_card.dart';
import 'package:auto_master/app/ui/widgets/widgets.dart';
import 'package:auto_master/resources/resources.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:yandex_mapkit/yandex_mapkit.dart';

import 'map_screen.dart';

class RequestDetailPage extends StatefulWidget {
  const RequestDetailPage({
    Key? key,
    required this.masterModel,
    required this.position,
  }) : super(key: key);

  final OrderResponseEntity masterModel;
  final Position? position;

  @override
  State<RequestDetailPage> createState() => _RequestDetailPageState();
}

class _RequestDetailPageState extends State<RequestDetailPage> {
  bool isLoading = false;

  Future<void> selectMaster() async {
    isLoading = true;
    if (mounted) setState(() {});

    await CustomerService.selectMaster(context, widget.masterModel.id);
    context.read<CustomerOrdersState>().fetchOrders();
    isLoading = false;
    if (mounted) setState(() {});

    routemaster
        .popUntil((routeData) => routeData.path == AppRoutes.clientTabbar);

    // if (widget.masterModel.latitude != null) {
    //   Navigator.of(context, rootNavigator: true).push(
    //     CupertinoDialogRoute(
    //       builder: (context) => ChangeNotifierProvider(
    //         create: (context) => MapState(
    //           context,
    //           AddressLocation.fromPoint(
    //             Point(
    //               latitude: widget.masterModel.latitude!,
    //               longitude: widget.masterModel.longitude!,
    //             ),
    //           ),
    //         ),
    //         child: MapScreen(
    //           address: widget.masterModel.address,
    //           masterAvatar: widget.masterModel.avatarOfMaster ?? '',
    //           masterName: widget.masterModel.nameOfMaster,
    //           masterId: widget.masterModel.id,
    //           orderId: widget.masterModel.orderId,
    //           departure: AddressLocation.fromPoint(
    //             Point(
    //               latitude: widget.masterModel.latitude!,
    //               longitude: widget.masterModel.longitude!,
    //             ),
    //           ),
    //           stoName: widget.masterModel.stoName,
    //         ),
    //       ),
    //       context: context,
    //     ),
    //   );
    // }
  }

  Future<void> _dialNumber(String number) async {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: number,
    );
    await launchUrl(launchUri);
  }

  @override
  Widget build(BuildContext context) {
    final ToAddress toAddress = ToAddress(widget.masterModel.address);
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32.0).copyWith(
                top: 30.0,
                bottom: 20.0,
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  const CustomIconButton(),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(100),
                    child: CachedNetworkImage(
                      imageUrl:
                          '${ApiClient.baseImageUrl}${widget.masterModel.avatarOfMaster}',
                      width: 117,
                      height: 117,
                      fit: BoxFit.cover,
                      errorWidget: (context, url, error) => Container(
                        width: 117,
                        height: 117,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: SvgPicture.asset(
                            Svgs.profile,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 40.0),
                ],
              ),
            ),
            const SizedBox(height: 13),
            Expanded(
              child: ListView(
                children: [
                  // Column(
                  //   mainAxisSize: MainAxisSize.min,
                  //   children: [
                  Align(
                    child: Text(
                      widget.masterModel.nameOfMaster,
                      style: AppTextStyle.s15w700.copyWith(
                        color: AppColors.main,
                      ),
                    ),
                  ),
                  const SizedBox(height: 15),
                  // GestureDetector(
                  //   onTap: () {
                  //     _dialNumber(widget.masterModel.masterPhone);
                  //   },
                  //   child: Text(
                  //     widget.masterModel.masterPhone
                  //         .replaceAll(')', ') ')
                  //         .replaceAll('(', ' ('),
                  //     style: AppTextStyle.s15w700.copyWith(
                  //       color: AppColors.grey,
                  //     ),
                  //   ),
                  // ),
                  // const SizedBox(height: 15),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Flexible(
                          child: Text(
                            widget.masterModel.address,
                            textAlign: TextAlign.center,
                            style: AppTextStyle.s13w400.copyWith(
                              color: AppColors.grey,
                            ),
                          ),
                        ),
                        const SizedBox(height: 33),
                        Text(
                          'от ${widget.masterModel.priceFromMaster} руб.',
                          textAlign: TextAlign.center,
                          style: AppTextStyle.s25w700.copyWith(
                            color: AppColors.main,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 25),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 36),
                    child: Column(
                      children: [
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 25,
                          ).copyWith(bottom: 40),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(25),
                            boxShadow: [
                              BoxShadow(
                                blurRadius: 4,
                                color: Colors.black.withOpacity(.25),
                              ),
                            ],
                          ),
                          child: Text(
                            widget.masterModel.masterDescription,
                            style: AppTextStyle.s15w400
                                .copyWith(color: AppColors.grey, height: 2),
                          ),
                        ),
                        const SizedBox(height: 30),
                        GestureDetector(
                          onTap: () {
                            if (widget.masterModel.latitude != null) {
                              Navigator.push(
                                context,
                                CupertinoDialogRoute(
                                  builder: (context) => ChangeNotifierProvider(
                                    create: (context) => MapState(
                                      context,
                                      toAddress,
                                    ),
                                    child: MapScreen(
                                      toAddress: toAddress,
                                      stoName: widget.masterModel.stoName,
                                      masterAvatar:
                                          widget.masterModel.avatarOfMaster ??
                                              '',
                                      masterName:
                                          widget.masterModel.nameOfMaster,
                                      address: widget.masterModel.address,
                                      orderId: widget.masterModel.orderId,
                                      masterId: widget.masterModel.id,
                                    ),
                                  ),
                                  context: context,
                                ),
                              );
                            }
                          },
                          child: Container(
                            clipBehavior: Clip.antiAlias,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Stack(
                              children: [
                                widget.masterModel.latitude != null
                                    ? MapCard(
                                        destinationPoint: Point(
                                          latitude:
                                              widget.masterModel.latitude!,
                                          longitude:
                                              widget.masterModel.longitude!,
                                        ),
                                      )
                                    : Image.asset(Images.adress),
                                if (widget.masterModel.latitude == null)
                                  Positioned.fill(
                                    child: BackdropFilter(
                                      filter: ImageFilter.blur(
                                        sigmaX: 8.0,
                                        sigmaY: 8.0,
                                      ),
                                      child: Center(
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                              bottom: 20.0),
                                          child: Text(
                                            "Не доступно".toUpperCase(),
                                            style:
                                                AppTextStyle.s18w700.copyWith(
                                              color: AppColors.main,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                Positioned(
                                  top: 28,
                                  left: 47,
                                  child: Column(
                                    children: [
                                      widget.masterModel.latitude != null
                                          ? SvgPicture.asset(Svgs.location)
                                          : const SizedBox(
                                              height: 38.0,
                                            ),
                                      const SizedBox(height: 17),
                                      Container(
                                        height: 42,
                                        width: SizerUtil.width * .6,
                                        decoration: BoxDecoration(
                                          color: Colors.white.withOpacity(.80),
                                          borderRadius:
                                              BorderRadius.circular(16),
                                          boxShadow: [
                                            BoxShadow(
                                              blurRadius: 4,
                                              color:
                                                  Colors.black.withOpacity(.10),
                                            ),
                                          ],
                                        ),
                                        child: Column(
                                          children: [
                                            Text(
                                              widget.masterModel.stoName,
                                              style:
                                                  AppTextStyle.s14w700.copyWith(
                                                color: Colors.black,
                                              ),
                                            ),
                                            const SizedBox(height: 2),
                                            Text(
                                              '${widget.masterModel.km} км',
                                              style:
                                                  AppTextStyle.s10w400.copyWith(
                                                color: Colors.black
                                                    .withOpacity(.50),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 30),
                        CustomButton(
                          isLoading: isLoading,
                          text: 'Принять заявку',
                          onPressed: selectMaster,
                        ),
                        const SizedBox(height: 30),
                      ],
                    ),
                  ),
                ],
                // ),
                // ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
