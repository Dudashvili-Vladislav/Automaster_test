// ignore_for_file: public_member_api_docs, sort_constructors_first
// ignore_for_file: use_build_context_synchronously, deprecated_member_use

import 'package:auto_master/app/domain/service/master_service.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import 'package:auto_master/app/app.dart';
import 'package:auto_master/app/data/api_client.dart';
import 'package:auto_master/app/domain/models/master_order_entity.dart';
import 'package:auto_master/app/domain/states/master/master_orders_state.dart';
import 'package:auto_master/app/ui/theme/theme.dart';
import 'package:auto_master/app/ui/utils/show_message.dart';
import 'package:auto_master/app/ui/widgets/widgets.dart';
import 'package:auto_master/resources/resources.dart';

class OrderDetailPage extends StatefulWidget {
  const OrderDetailPage({
    Key? key,
    required this.model,
  }) : super(key: key);

  final MasterOrderEntity model;

  @override
  State<OrderDetailPage> createState() => _OrderDetailPageState();
}

class _OrderDetailPageState extends State<OrderDetailPage> {
  int? price;

  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    final f = DateFormat('dd.MM.yyyy', 'ru_RU');
    final dateFrom = DateTime.tryParse(widget.model.dateFrom ?? '');
    final dateTo = DateTime.tryParse(widget.model.dateTo ?? '');
    final time = widget.model.time?.substring(0, 5);

    String res = '';
    if (dateFrom != null) {
      res += f.format(dateFrom);
    }
    if (dateTo != null && dateFrom != null) {
      res += ' - ';
    }
    if (dateTo != null) {
      res += f.format(dateTo);
    }
    if (time != null) {
      res += ', $time';
    }
    final mos = context.read<MasterOrdersState>();
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 15.0)
              .copyWith(bottom: 32.0, top: 36.0),
          physics: const RangeMaintainingScrollPhysics(),
          children: [
            Column(
              children: <Widget>[
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const CustomIconButton(),
                    if (widget.model.customerAvatar != null &&
                        widget.model.customerAvatar != 'null')
                      Container(
                        width: 117.0,
                        height: 117.0,
                        clipBehavior: Clip.hardEdge,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              blurRadius: 10.0,
                              color: Colors.black.withOpacity(.3),
                            ),
                          ],
                        ),
                        child: CachedNetworkImage(
                          imageUrl:
                              '${ApiClient.baseImageUrl}${widget.model.customerAvatar}',
                          width: 45,
                          height: 32,
                          fit: BoxFit.cover,
                          errorWidget: (context, url, error) => const Icon(
                            Icons.error,
                            color: AppColors.main,
                          ),
                        ),
                      )
                    else
                      SvgPicture.asset(
                        Svgs.profile,
                        width: 135.0,
                        height: 135.0,
                        color: AppColors.greyLight,
                      ),
                    const SizedBox(width: 40.0),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 21.0),
                  child: Column(
                    children: <Widget>[
                      const SizedBox(height: 13.0),
                      Text(
                        widget.model.customerName ?? '',
                        style: AppTextStyle.s15w700.copyWith(
                          color: AppColors.main,
                        ),
                      ),
                      const SizedBox(height: 23.0),
                      CustomButton(
                        width: 211.0,
                        height: 44.0,
                        text: price == null ? 'Ваша цена' : price.toString(),
                        onPressed: () async {
                          final result = await enterServicePriceDialog(context);

                          if (result != null) {
                            price = result;
                            setState(() {});
                          }
                        },
                      ),
                      const SizedBox(height: 35.0),
                      // InfoCard(text: widget.model.specialization, title: 'Специ',),
                      InfoCard(
                        text: widget.model.carBrand,
                        title: 'Модель',
                      ),
                      InfoCard(
                        text: widget.model.carModel,
                        title: 'Марка',
                      ),
                      if (widget.model.bodyType != null)
                        InfoCard(
                          text: widget.model.bodyType!,
                          title: 'Кузов',
                        ),

                      if (widget.model.engineType != null)
                        InfoCard(
                          text: widget.model.engineType!,
                          title: 'Тип топлива',
                        ),
                      if (widget.model.enginePower != null)
                        InfoCard(
                          text: widget.model.enginePower!,
                          title: 'Мощность ДВС',
                        ),
                      InfoCard(
                        text: widget.model.carNumber,
                        title: 'Гос. номер',
                      ),
                      if (widget.model.carNationality != null)
                        InfoCard(
                          text: widget.model.carNationality!,
                          title: 'Тип автомобиля',
                        ),
                      if (widget.model.vinNumber != null)
                        InfoCard(
                          text: widget.model.vinNumber!,
                          title: 'VIN номер',
                        ),
                      if (widget.model.typeOfDrive != null)
                        InfoCard(
                          text: widget.model.typeOfDrive!,
                          title: 'Привод',
                        ),
                      InfoCard(
                        text: res,
                        title: 'Дата',
                      ),
                      InfoTextAreaCard(
                        text: widget.model.orderDescription ?? '',
                      ),
                      const SizedBox(height: 12.0),
                      CustomButton(
                        width: 264.0,
                        height: 47.0,
                        text: 'Принять в работу',
                        isLoading: isLoading,
                        onPressed: () async {
                          if (price == null) {
                            showMessage('Введите вашу цену');
                            return;
                          } else {
                            isLoading = true;
                            if (mounted) setState(() {});
                            await context.read<MasterOrdersState>().setResponse(
                                  price!,
                                  widget.model.id.toString(),
                                );
                            isLoading = false;
                            if (mounted) setState(() {});
                            routemaster.pop();
                          }
                        },
                      ),
                      const SizedBox(height: 20.0),
                      BorderedButton(
                        onPressed: context.watch<MasterOrdersState>().isLoading
                            ? null
                            : () => cancelOrder(context, widget.model, mos),
                        width: 264.0,
                        height: 47.0,
                        text: 'Отказаться от заказа',
                      ),
                    ],
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<dynamic> enterServicePriceDialog(BuildContext context) {
    int? price;
    return showDialog(
      context: context,
      builder: (context) => Dialog(
        // backgroundColor: Colors.white,
        // surfaceTintColor: Colors.white,
        insetPadding: const EdgeInsets.symmetric(horizontal: 36.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(40.0),
        ),
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 24.0,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text(
                    'Укажите цену',
                    style: AppTextStyle.s15w700.copyWith(
                      color: AppColors.main,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    child: Text(
                      'Укажите цену выполнения\nза этот заказ',
                      textAlign: TextAlign.center,
                      style: AppTextStyle.s14w400.copyWith(
                        color: Colors.black,
                      ),
                    ),
                  ),
                  Image.asset(
                    Images.logo,
                    width: 117.0,
                    height: 100.0,
                  ),
                  const SizedBox(height: 16.0),
                  CustomInput(
                    hintText: 'Введите цену заказа',
                    keyboardType: TextInputType.number,
                    onChange: (v) {
                      price = int.tryParse(v);
                    },
                  ),
                  const SizedBox(height: 24.0),
                  CustomButton(
                    text: 'Готово',
                    onPressed: () => Navigator.pop(context, price),
                  ),
                ],
              ),
            ),
            const Positioned(
              right: 10,
              top: 10,
              child: CustomIconButton(
                icon: Svgs.close,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<dynamic> cancelOrder(BuildContext context,
      final MasterOrderEntity model, final MasterOrdersState mos) {
    final isLoading = ValueNotifier<bool>(false);
    return showDialog(
      context: context,
      builder: (context) => Dialog(
        insetPadding: const EdgeInsets.symmetric(horizontal: 36.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(40.0),
        ),
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 23.0,
                vertical: 40.0,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text(
                    'Отказаться',
                    style: AppTextStyle.s15w700.copyWith(
                      color: AppColors.main,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 28.0),
                    child: Text(
                      'Вы действительно хотите\nотказаться от заказа?',
                      textAlign: TextAlign.center,
                      style: AppTextStyle.s14w400.copyWith(
                        color: Colors.black,
                      ),
                    ),
                  ),
                  Image.asset(
                    Images.logo,
                    width: 117.0,
                    height: 102.0,
                  ),
                  const SizedBox(height: 50.0),
                  ValueListenableBuilder(
                    valueListenable: isLoading,
                    builder: (context, value, child) => CustomButton(
                      isLoading: isLoading.value,
                      text: 'Да',
                      onPressed: () async {
                        isLoading.value = true;
                        await MasterService.cancelOrder(
                          context,
                          model.id.toString(),
                        );
                        await mos.fetchOrders();
                        isLoading.value = false;
                        Navigator.pop(context);
                        routemaster.pop();
                      },
                    ),
                  ),
                  const SizedBox(height: 25.0),
                  ValueListenableBuilder(
                    valueListenable: isLoading,
                    builder: (context, value, child) => BorderedButton(
                      onPressed:
                          isLoading.value ? null : () => Navigator.pop(context),
                      width: double.infinity,
                      height: 47.0,
                      text: 'Нет',
                    ),
                  ),
                ],
              ),
            ),
            const Positioned(
              right: 10,
              top: 10,
              child: CustomIconButton(
                icon: Svgs.close,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class InfoCard extends StatelessWidget {
  const InfoCard({
    Key? key,
    this.text = '',
    this.title,
  }) : super(key: key);

  final String text;
  final String? title;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (title != null)
          Padding(
            padding: const EdgeInsets.only(
              bottom: 10.0,
              left: 20,
            ),
            child: Text(
              title!,
              style: AppTextStyle.s14w400,
            ),
          ),
        Container(
          width: double.infinity,
          margin: const EdgeInsets.only(bottom: 20.0),
          padding: const EdgeInsets.symmetric(
            vertical: 16.0,
            horizontal: 22.0,
          ),
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [AppTheme.shadowBlur4],
            borderRadius: BorderRadius.circular(60.0),
          ),
          child: Text(
            text,
            style: AppTextStyle.s14w400.copyWith(
              color: Colors.black,
            ),
          ),
        ),
      ],
    );
  }
}

class InfoTextAreaCard extends StatelessWidget {
  const InfoTextAreaCard({
    Key? key,
    this.text = '',
  }) : super(key: key);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 20.0),
      padding: const EdgeInsets.symmetric(
        vertical: 25.0,
        horizontal: 22.0,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [AppTheme.shadowBlur4],
        borderRadius: BorderRadius.circular(25.0),
      ),
      child: Text(
        text,
        style: AppTextStyle.s14w400.copyWith(
          color: Colors.black,
          height: 2,
        ),
      ),
    );
  }
}
