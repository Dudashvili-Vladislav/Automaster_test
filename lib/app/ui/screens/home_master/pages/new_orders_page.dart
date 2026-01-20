import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:auto_master/app/domain/models/master_order_entity.dart';
import 'package:auto_master/app/domain/states/master/master_orders_state.dart';
import 'package:auto_master/app/ui/theme/theme.dart';
import 'package:auto_master/app/ui/widgets/widgets.dart';

class NewOrdersPage extends StatelessWidget {
  const NewOrdersPage({
    Key? key,
    required this.title,
    required this.emptyText,
    required this.orders,
  }) : super(key: key);

  final String title;
  final String emptyText;
  final List<MasterOrderEntity> orders;

  @override
  Widget build(BuildContext context) {
    context.watch<MasterOrdersState>();
    final read = context.read<MasterOrdersState>();

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: <Widget>[
            CustomAppBar(title: title),
            Expanded(
              child: orders.isEmpty
                  ? Center(
                      child: Text(
                        emptyText,
                        style: AppTextStyle.s14w500,
                      ),
                    )
                  : RefreshIndicator(
                      color: AppColors.main,
                      onRefresh: read.fetchOrders,
                      child: ListView.separated(
                        itemCount: orders.length,
                        padding: const EdgeInsets.symmetric(horizontal: 32.0)
                            .copyWith(top: 12.0, bottom: 32.0),
                        separatorBuilder: (context, index) =>
                            const SizedBox(height: 20.0),
                        itemBuilder: (context, index) => OrderCard(
                          model: orders[index],
                          width: double.infinity,
                          isFinished: title == 'История заказов',
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
