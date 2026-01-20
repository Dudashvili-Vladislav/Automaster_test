import 'package:auto_master/app/data/api_client.dart';
import 'package:auto_master/app/domain/models/body_type.dart';
import 'package:auto_master/app/domain/service/customer_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:auto_master/app/domain/states/customer/profile_state.dart';
import 'package:auto_master/app/ui/theme/theme.dart';
import 'package:auto_master/app/ui/widgets/widgets.dart';

class AllAutoPage extends StatefulWidget {
  const AllAutoPage({
    Key? key,
    this.isChoose = true,
  }) : super(key: key);

  final bool isChoose;

  @override
  State<AllAutoPage> createState() => _AllAutoPageState();
}

class _AllAutoPageState extends State<AllAutoPage> {
  List<BodyTypes> bodyTypes = [];

  getBodyList(BuildContext context) async {
    var result = await CustomerService.getBodyList(context);

    if (result != null) {
      setState(() {
        bodyTypes = result;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    getBodyList(context);
    context.read<CustomerProfileState>().fetchCars();
    Future.microtask(context.read<CustomerProfileState>().fetchCars);
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<CustomerProfileState>();
    final cars = state.cars;
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const CustomAppBar(
              title: 'Все авто',
            ),
            Expanded(
              child: cars.isEmpty
                  ? const Center(
                      child: Text(
                        'Вы не добавили авто',
                        style: AppTextStyle.s14w700,
                      ),
                    )
                  : RefreshIndicator(
                      onRefresh: context.read<CustomerProfileState>().fetchCars,
                      color: AppColors.main,
                      child: ListView.separated(
                        padding: const EdgeInsets.symmetric(horizontal: 32)
                            .copyWith(bottom: 48, top: 5),
                        separatorBuilder: (BuildContext context, int index) =>
                            const SizedBox(height: 20),
                        itemCount: cars.length,
                        itemBuilder: (context, index) {
                          return AutoCard.fromModel(
                            cars[index],
                            isChoose: widget.isChoose,
                            bodyTypes.isEmpty
                                ? null
                                : '${ApiClient.baseImageUrl}${cars[index].icon}',
                            // ApiClient.baseImageUrl +
                            //     bodyTypes
                            //         .firstWhere((element) =>
                            //             element.bodyType ==
                            //             cars[index].bodyType)
                            //         .icon,
                          );
                        },
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
