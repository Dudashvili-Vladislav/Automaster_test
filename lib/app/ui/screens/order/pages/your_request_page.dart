import 'package:auto_master/app/domain/models/order_response_entity.dart';
import 'package:auto_master/app/domain/service/customer_service.dart';
import 'package:auto_master/app/ui/utils/get_distance.dart';
import 'package:auto_master/app/ui/utils/get_position.dart';
import 'package:flutter/material.dart';

import 'package:auto_master/app/ui/widgets/widgets.dart';
import 'package:geolocator/geolocator.dart';

import 'request_detail_page.dart';

class YourRequestPage extends StatefulWidget {
  const YourRequestPage({
    Key? key,
    required this.orderId,
  }) : super(key: key);

  final int orderId;

  @override
  State<YourRequestPage> createState() => _YourRequestPageState();
}

class _YourRequestPageState extends State<YourRequestPage> {
  bool isLoading = false;
  Position? position;

  List<OrderResponseEntity> _responses = [];

  Future<void> getResponses() async {
    isLoading = true;
    if (mounted) setState(() {});
    _responses =
        await CustomerService.getResponseList(context, widget.orderId) ?? [];

    position = await determinePosition();

    if (position != null) {
      final list = <OrderResponseEntity>[];

      for (var i in _responses) {
        if (i.latitude != null && i.longitude != null) {
          final distance = calculateDistance(
              position!.latitude, position!.longitude, i.latitude, i.longitude);
          final item = i.copyWith(km: distance.round());
          list.add(item);
        } else {
          list.add(i);
        }
      }
      _responses = list;
    }

    isLoading = false;
    if (mounted) setState(() {});
  }

  @override
  void initState() {
    Future.microtask(getResponses);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const CustomAppBar(
              title: 'Отлики на вашу задачу',
            ),
            Expanded(
              child: isLoading
                  ? const Loading()
                  : ListView.separated(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 32, vertical: 5),
                      itemCount: _responses.length,
                      separatorBuilder: (context, index) =>
                          const SizedBox(height: 30),
                      itemBuilder: (context, index) => RequestCard(
                        model: _responses[index],
                        onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => RequestDetailPage(
                              masterModel: _responses[index],
                              position: position,
                            ),
                          ),
                        ),
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
