import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:auto_master/app/app.dart';
import 'package:auto_master/app/domain/service/customer_service.dart';
import 'package:auto_master/app/domain/service/is_payment_allowed.dart';
import 'package:auto_master/app/domain/states/customer/orders_state.dart';
import 'package:auto_master/app/ui/screens/webview_payment.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:auto_master/app/domain/service/customer_order_service.dart';

import 'package:auto_master/app/ui/theme/theme.dart';
import 'package:auto_master/app/ui/widgets/widgets.dart';
// import 'package:flutter_inapp_purchase/flutter_inapp_purchase.dart';
import 'package:fluttertoast/fluttertoast.dart';
// import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:provider/provider.dart';

import 'your_request_page.dart';

class PaymentPage extends StatefulWidget {
  const PaymentPage({
    Key? key,
    required this.orderId,
  }) : super(key: key);

  final int orderId;

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

// final res =  FlutterInappPurchase.instance.initialize();

class _PaymentPageState extends State<PaymentPage> {
  bool isLoading = false;
  Map<String, dynamic> info = {};

  StreamSubscription? _purchaseUpdatedSubscription;
  StreamSubscription? _purchaseErrorSubscription;
  StreamSubscription? _conectionSubscription;

  @override
  void initState() {
    super.initState();
    Future.microtask(loadPaymentInfo);
    if (Platform.isIOS) {
      // asyncInitState(); // async is not allowed on initState() directly
    }
  }

  // void asyncInitState() async {
  //   final bool available = await InAppPurchase.instance.isAvailable();
  //   print('is store available: $available');
  //   // final ProductDetailsResponse response =
  //   //     await InAppPurchase.instance.queryProductDetails({'order'});
  //   // print(
  //   //     'Product details response error: ${response.error} length = ${response.productDetails.length}');

  //   final Stream purchaseUpdated = InAppPurchase.instance.purchaseStream;
  //   _purchaseUpdatedSubscription =
  //       purchaseUpdated.listen((purchaseDetailsList) {
  //     // _listenToPurchaseUpdated(purchaseDetailsList);
  //     print('Updated');
  //   }, onDone: () {
  //     print('DOne');
  //     // _subscription.cancel();
  //   }, onError: (error) {
  //     // handle error here.
  //   });

  //   // final res = await FlutterInappPurchase.instance.initialize();
  //   // print('init flutter inapp: $res');

  //   // _conectionSubscription =
  //   //     FlutterInappPurchase.connectionUpdated.listen((connected) {
  //   //   print('connected: $connected');
  //   // });

  //   // _purchaseUpdatedSubscription =
  //   //     FlutterInappPurchase.purchaseUpdated.listen((productItem) {
  //   //   print('purchase-updated: $productItem');

  //   //   // final receipt = productItem?.transactionReceipt;
  //   //   // if (receipt != null) {
  //   //   //   validateReceipt(receipt);
  //   //   // }

  //   //   CustomerService.iosPayment(context, widget.orderId);
  //   //   Navigator.of(context).pop();
  //   //   onPaymentSuccess(context, widget.orderId);
  //   // });

  //   // _purchaseErrorSubscription =
  //   //     FlutterInappPurchase.purchaseError.listen((purchaseError) {
  //   //   print('purchase-error: $purchaseError');
  //   //   Fluttertoast.showToast(msg: 'Ошибка при оплате товара. $purchaseError');
  //   // });

  //   // final d1 = await FlutterInappPurchase.instance.getProducts([]);
  //   // print('LOADED ITEMS 1 getProducts([])=${d1.length}');

  //   // final d2 =
  //   //     await FlutterInappPurchase.instance.getAppStoreInitiatedProducts();
  //   // print('LOADED ITEMS 2 getAppStoreInitiatedProducts=${d2.length}');

  //   // List<IAPItem> items =
  //   //     await FlutterInappPurchase.instance.getProducts(['order']);
  //   // print('LOADED ITEMS 3 ${items.length}');
  //   // items.forEach((element) {
  //   //   print(element.description);
  //   //   print(element.localizedPrice);
  //   // });
  // }

  // Future<bool> validateReceipt(final String transactionReceipt) async {
  //   var receiptBody = {
  //     'receipt-data': transactionReceipt,
  //     'password': '******'
  //   };
  //   final result = await FlutterInappPurchase.instance
  //       .validateReceiptIos(receiptBody: receiptBody, isTest: kDebugMode);

  //   log(result.body);
  //   return true;
  // }

  @override
  void dispose() {
    // if (Platform.isIOS) {
    _conectionSubscription?.cancel();
    _purchaseUpdatedSubscription?.cancel();
    _purchaseErrorSubscription?.cancel();
    // FlutterInappPurchase.instance.finalize();
    // }
    super.dispose();
  }

  Future<void> loadPaymentInfo() async {
    isLoading = true;
    if (mounted) setState(() {});

    info = await CustomerOrderService.getCostAndBalance(context) ?? {};
    isLoading = false;
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    print('Build payment ${widget.orderId}');
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            CustomAppBar(
              title: 'Оплата контактов',
              onBack: () => Navigator.of(context).pop(),
            ),
            Expanded(
              child: isLoading
                  ? const Loading()
                  : Column(
                      children: [
                        Text(
                          'Для получения контактов,\nоплатите их.',
                          style: AppTextStyle.s14w400.copyWith(
                            color: AppColors.black,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const Spacer(),
                        Text(
                          '${info['cost']} руб.',
                          textAlign: TextAlign.center,
                          style: AppTextStyle.s35w700.copyWith(fontSize: 48.0),
                        ),
                        const Spacer(),
                        CustomButton(
                          width: 234,
                          height: 47,
                          text: 'Оплатить',
                          onPressed: () async {
                            try {
                              // if (openPayment) {
                              final url = await context
                                  .read<CustomerOrdersState>()
                                  .getPaymentLink(widget.orderId);

                              //     .activeOrders
                              //     .where(
                              //         (element) => element.id == widget.orderId)
                              //     .first
                              //     .paymentStatus = 'paid';

                              webViewParams = WebViewParams(
                                url: url,
                                orderId: widget.orderId,
                              );
                              routemaster.push(WebViewPayment.routeName);
                              // } else {
                              //   // FlutterInappPurchase.instance
                              //   //     .requestPurchase('order');
                              // }
                            } catch (e) {
                              Fluttertoast.showToast(msg: 'Ошибка $e');
                            }
                          },
                        ),
                        const SizedBox(height: 50),
                      ],
                    ),
            )
          ],
        ),
      ),
    );
  }
}
