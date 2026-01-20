import 'package:auto_master/app/domain/states/customer/orders_state.dart';
import 'package:auto_master/app/ui/screens/order/widgets/history_order_card.dart';
import 'package:auto_master/app/ui/theme/theme.dart';
import 'package:auto_master/app/ui/widgets/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AllHistoryOrdersPage extends StatelessWidget {
  const AllHistoryOrdersPage({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<CustomerOrdersState>();
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const CustomAppBar(
              title: 'История заказов',
            ),
            Expanded(
              child: state.completeOrders.isEmpty
                  ? Center(
                      child: Text(
                        'У Вас нет завершённых заказов',
                        style: AppTextStyle.s15w400
                            .copyWith(color: AppColors.main),
                      ),
                    )
                  : RefreshIndicator(
                      onRefresh: () =>
                          context.read<CustomerOrdersState>().fetchOrders(),
                      color: AppColors.main,
                      child: ListView.separated(
                        padding: const EdgeInsets.symmetric(horizontal: 32)
                            .copyWith(bottom: 48, top: 5),
                        separatorBuilder: (BuildContext context, int index) =>
                            const SizedBox(height: 20),
                        itemCount: state.completeOrders.length,
                        itemBuilder: (context, index) => HistoryOrderCard(
                            model: state.completeOrders[index]),
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
