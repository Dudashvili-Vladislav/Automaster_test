import 'dart:io';

import 'package:dio/dio.dart';

Future<bool> isPaymentAllowed() async {
  try {
    final String defaultLocale = Platform.localeName.substring(0, 2);
    // final
    print('defaultLocale: $defaultLocale');
    final isLocaleRu = defaultLocale == 'ru';

    if (!isLocaleRu) {
      return false;
    }

    // https://ip-api.com/docs/api:json
    final res = await Dio().get('http://ip-api.com/json/?fields=countryCode');
    final ipCountry = res.data['countryCode'].toString().toLowerCase();
    print('ipCountry: $ipCountry');
    final isIpCountry = ipCountry == 'ru';

    return isLocaleRu && isIpCountry;
  } catch (e) {
    print(e);
    return false;
  }
}
