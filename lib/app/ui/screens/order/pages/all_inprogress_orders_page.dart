import 'package:auto_master/app/domain/states/customer/orders_state.dart';

import 'package:auto_master/app/ui/screens/order/widgets/widgets.dart';
import 'package:auto_master/app/ui/theme/theme.dart';
import 'package:auto_master/app/ui/widgets/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AllInprogressOrdersPage extends StatelessWidget {
  const AllInprogressOrdersPage({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<CustomerOrdersState>();
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const CustomAppBar(
              title: 'Текущие заказы',
            ),
            Expanded(
              child: state.activeOrders.isEmpty
                  ? Center(
                      child: Text(
                        'У вас нет текущих заказов',
                        style: AppTextStyle.s15w400
                            .copyWith(color: AppColors.main),
                      ),
                    )
                  : RefreshIndicator(
                      onRefresh: () =>
                          context.read<CustomerOrdersState>().fetchOrders(),
                      color: AppColors.main,
                      child: ListView.separated(
                        shrinkWrap: true,
                        padding: const EdgeInsets.symmetric(horizontal: 32)
                            .copyWith(bottom: 48, top: 5),
                        separatorBuilder: (BuildContext context, int index) =>
                            const SizedBox(height: 20),
                        itemCount: state.activeOrders.length,
                        itemBuilder: (context, index) => NowOrderCard(
                          model: state.activeOrders[index],
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
