import 'package:auto_master/app/ui/screens/order/pages/all_inprogress_orders_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:auto_master/app/app.dart';
import 'package:auto_master/app/domain/states/customer/orders_state.dart';
import 'package:auto_master/app/ui/routes/routes.dart';
import 'package:auto_master/app/ui/theme/app_colors.dart';
import 'package:auto_master/app/ui/theme/app_text_style.dart';

import 'package:auto_master/app/ui/widgets/widgets.dart';

import 'widgets/widgets.dart';

class OrderScreen extends StatefulWidget {
  const OrderScreen({
    super.key,
  });

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  @override
  void initState() {
    Future.microtask(() => context.read<CustomerOrdersState>().fetchOrders());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<CustomerOrdersState>();
    final read = context.read<CustomerOrdersState>();
    final activeOrders = state.activeOrders;
    final completedOrders = state.completeOrders;
    return SizedBox(
      width: double.infinity,
      child: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 28),
            Text(
              'Мои заказы',
              style: AppTextStyle.s15w700.copyWith(color: AppColors.main),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: state.isLoading
                  ? const Loading()
                  : RefreshIndicator(
                      onRefresh: () => read.fetchOrders(),
                      color: AppColors.main,
                      child: ListView(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 32),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Текущие',
                                  style: AppTextStyle.s12w700.copyWith(
                                    color: AppColors.black,
                                  ),
                                ),
                                CupertinoButton(
                                  padding: EdgeInsets.zero,
                                  onPressed: () => Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          const AllInprogressOrdersPage(),
                                    ),
                                  ),
                                  child: Text(
                                    'Посмотреть все',
                                    style: AppTextStyle.s12w400.copyWith(
                                      color: AppColors.main,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 15),
                          SizedBox(
                            height: NowOrderCard.height,
                            child: activeOrders.isEmpty
                                ? Center(
                                    child: Text(
                                      'У вас нет активных заказов',
                                      style: AppTextStyle.s15w400
                                          .copyWith(color: AppColors.main),
                                    ),
                                  )
                                : ListView.separated(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 32,
                                      vertical: 5,
                                    ),
                                    scrollDirection: Axis.horizontal,
                                    itemCount: activeOrders.length,
                                    separatorBuilder: (context, index) =>
                                        const SizedBox(width: 15),
                                    itemBuilder: (context, index) =>
                                        NowOrderCard(
                                      model: activeOrders[index],
                                    ),
                                  ),
                          ),
                          const SizedBox(height: 15),
                          Column(
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 32),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'История заказов',
                                      style: AppTextStyle.s12w700.copyWith(
                                        color: AppColors.black,
                                      ),
                                    ),
                                    CupertinoButton(
                                      padding: EdgeInsets.zero,
                                      onPressed: () => routemaster
                                          .push(AppRoutes.clientHistoryOrders),
                                      child: Text(
                                        'Посмотреть все',
                                        style: AppTextStyle.s12w400.copyWith(
                                          color: AppColors.main,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 15),
                              SizedBox(
                                height: 295,
                                child: state.completeOrders.isEmpty
                                    ? Center(
                                        child: Text(
                                          'У Вас нет завершённых заказов',
                                          style: AppTextStyle.s15w400
                                              .copyWith(color: AppColors.main),
                                        ),
                                      )
                                    : ListView.separated(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 32,
                                          vertical: 5,
                                        ),
                                        scrollDirection: Axis.horizontal,
                                        separatorBuilder: (context, index) =>
                                            const SizedBox(width: 15),
                                        itemCount: completedOrders.length,
                                        itemBuilder: (context, index) =>
                                            HistoryOrderCard(
                                                model: completedOrders[index]),
                                      ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 40),
                        ],
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
