import 'package:auto_master/app/domain/states/master/master_profile_state.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import 'package:auto_master/app/domain/models/master_order_entity.dart';
import 'package:auto_master/app/domain/states/master/master_orders_state.dart';
import 'package:auto_master/app/ui/screens/home_master/pages/new_orders_page.dart';
import 'package:auto_master/app/ui/theme/theme.dart';
import 'package:auto_master/app/ui/widgets/widgets.dart';
import 'package:auto_master/resources/resources.dart';

class HomeMasterScreen extends StatefulWidget {
  const HomeMasterScreen({Key? key}) : super(key: key);

  @override
  State<HomeMasterScreen> createState() => _HomeMasterScreenState();
}

class _HomeMasterScreenState extends State<HomeMasterScreen> {
  @override
  void initState() {
    Future.microtask(context.read<MasterOrdersState>().fetchOrders);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final profile = context.select((MasterProfileState vm) => vm.profile);
    final state = context.watch<MasterOrdersState>();
    final read = context.read<MasterOrdersState>();
    final activeOrders = state.activeOrders;
    final inProgressOrders = state.inProgressOrders;
    final completedOrders = state.completeOrders;
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 35.0)
                  .copyWith(top: 22.0, bottom: 15.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Expanded(
                    child: Text(
                      'Здравствуйте, ${profile == null ? '...' : '${profile.name}!'}',
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyle.s15w700.copyWith(
                        color: Colors.black,
                      ),
                    ),
                  ),
                  Image.asset(
                    Images.logo,
                    width: 65.0,
                    height: 57.0,
                  ),
                ],
              ),
            ),
            Expanded(
              child: state.isLoading
                  ? const Loading()
                  : RefreshIndicator(
                      color: AppColors.main,
                      onRefresh: read.fetchOrders,
                      child: CustomScrollView(
                        slivers: [
                          OrderTitle(
                            title: 'Новые заказы',
                            count: activeOrders.length,
                            onPressed: () => Navigator.push(
                              context,
                              CupertinoPageRoute(
                                builder: (context) =>
                                    ChangeNotifierProvider.value(
                                  value: read,
                                  child: NewOrdersPage(
                                    title: 'Новые заказы',
                                    emptyText: 'Нет новых заказов',
                                    orders: activeOrders,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          OrderList(
                            emptyText: 'Нет новых заказов',
                            orders: activeOrders,
                          ),
                          const SliverToBoxAdapter(
                              child: SizedBox(height: 10.0)),
                          OrderTitle(
                            title: 'Текущие заказы',
                            onPressed: () => Navigator.push(
                              context,
                              CupertinoPageRoute(
                                builder: (context) =>
                                    ChangeNotifierProvider.value(
                                  value: read,
                                  child: NewOrdersPage(
                                    title: 'Текущие заказы',
                                    emptyText: 'Нет текущих заказов',
                                    orders: inProgressOrders,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          OrderList(
                            emptyText: 'Нет текущих заказов',
                            orders: inProgressOrders,
                          ),
                          const SliverToBoxAdapter(
                            child: SizedBox(height: 10.0),
                          ),
                          OrderTitle(
                            title: 'История заказов',
                            onPressed: () => Navigator.push(
                              context,
                              CupertinoPageRoute(
                                builder: (context) =>
                                    ChangeNotifierProvider.value(
                                  value: read,
                                  child: NewOrdersPage(
                                    title: 'История заказов',
                                    emptyText: 'Нет история заказов',
                                    orders: completedOrders,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          OrderList(
                            isFinished: true,
                            emptyText: 'Нет история заказов',
                            orders: completedOrders,
                          ),
                          const SliverToBoxAdapter(
                            child: SizedBox(height: 50.0),
                          ),
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

class OrderList extends StatelessWidget {
  const OrderList({
    Key? key,
    this.isFinished = false,
    required this.emptyText,
    required this.orders,
  }) : super(key: key);

  final bool isFinished;
  final String emptyText;
  final List<MasterOrderEntity> orders;

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: SizedBox(
        height: OrderCard.height,
        child: orders.isEmpty
            ? Center(
                child: Text(
                  emptyText,
                  style: AppTextStyle.s14w500,
                ),
              )
            : ListView.separated(
                itemCount: orders.length,
                padding: const EdgeInsets.symmetric(
                  horizontal: 35.0,
                  vertical: 10.0,
                ),
                scrollDirection: Axis.horizontal,
                separatorBuilder: (context, index) =>
                    const SizedBox(width: 10.0),
                itemBuilder: (context, index) => OrderCard(
                  width: SizerUtil.width * .85,
                  isFinished: isFinished,
                  model: orders[index],
                ),
              ),
      ),
    );
  }
}

class OrderTitle extends StatelessWidget {
  const OrderTitle({
    Key? key,
    required this.title,
    this.count,
    required this.onPressed,
  }) : super(key: key);

  final String title;
  final int? count;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 35.0).copyWith(
          top: 10.0,
          bottom: 15.0,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text.rich(
              TextSpan(
                style: AppTextStyle.s12w700.copyWith(
                  color: Colors.black,
                ),
                children: [
                  TextSpan(text: title),
                  if (count != null && count != 0)
                    TextSpan(
                      text: ' (+$count)',
                      style: AppTextStyle.s12w700.copyWith(
                        color: AppColors.main,
                      ),
                    ),
                ],
              ),
            ),
            SizedBox(
              height: 20,
              child: CupertinoButton(
                onPressed: onPressed,
                padding: EdgeInsets.zero,
                child: Text(
                  'Посмотреть все',
                  style: AppTextStyle.s12w400.copyWith(
                    color: AppColors.main,
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
