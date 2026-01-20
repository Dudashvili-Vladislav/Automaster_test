import 'dart:async';
import 'dart:developer';

import 'package:auto_master/app/app.dart';
import 'package:auto_master/app/ui/routes/routes.dart';
import 'package:auto_master/app/ui/screens/order/pages/your_request_page.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewParams {
  final String url;
  final int orderId;

  const WebViewParams({
    required this.url,
    required this.orderId,
  });
}

WebViewParams? webViewParams;

Future<void> onPaymentSuccess(BuildContext context, int orderId) async {
  await routemaster.popUntil((routeData) => routeData.path == AppRoutes.home);
  Navigator.push(context, MaterialPageRoute(builder: (_) {
    return YourRequestPage(orderId: orderId);
  }));
}

class WebViewPayment extends StatelessWidget {
  const WebViewPayment({required this.params, super.key});

  final WebViewParams params;

  static const String routeName = '/webview_payment';

  @override
  Widget build(BuildContext context) {
    print('WEBVIEW ORDER ID ${params.orderId} PAYMENT ${params.url}');

    bool isFirst = true;

    final controller = WebViewController();
    controller
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      // ..setBackgroundColor(const Color(0x00000000))
      // ..setOnConsoleMessage((message) {
      //   log(message.message);
      // })
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            // Update loading bar.
          },
          onPageStarted: (String url) {
            log('FIRST FINISHED URL $url');
          },
          onPageFinished: (String url) async {
            if (isFirst) {
              log('FIRST FINISHED URL $url');
              isFirst = false;
            } else {
              log('NOT FIRST FINISHED $url');
              if (await readJS(controller)) {
                // context
                //     .read<CustomerOrdersState>()
                //     .activeOrders
                //     .where((element) => element.id == params.orderId)
                //     .first
                //     .paymentStatus = 'paid';

                // unawaited(context.read<CustomerOrdersState>().fetchOrders());
                log('SUCCESS PAYMENT');
                onPaymentSuccess(context, params.orderId);
              } else {
                log('NOT SUCCESS PAYMENT');
              }
            }
          },
          onHttpError: (HttpResponseError error) {},
          onWebResourceError: (WebResourceError error) {},
          // onNavigationRequest: (NavigationRequest request) {
          //   if (request.url.startsWith('https://www.youtube.com/')) {
          //     return NavigationDecision.prevent;
          //   }
          //   return NavigationDecision.navigate;
          // },
        ),
      )
      ..loadRequest(Uri.parse(params.url));
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // const CustomAppBar(
            //   title: 'Оплата контактов',
            // ),
            Expanded(
              child: WebViewWidget(controller: controller),
            ),
          ],
        ),
      ),
    );
  }

  static Future<bool> readJS(WebViewController controller) async {
    print('readJS');
    String result = await controller.runJavaScriptReturningResult(
        "window.document.getElementsByTagName('html')[0].outerHTML;") as String;
    final pattern = "Successful payment for Auto Master";
    // print(result.runtimeType);
    // log(result);
    log('$pattern count:');
    log(pattern.allMatches(result).length.toString());
    log('contains:${result.contains(pattern)}');
    if (result.contains(pattern)) {
      return true;
    } else {
      return false;
      // throw Exception('Count not read payment result');
    }
  }
}
