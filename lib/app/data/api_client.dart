import 'package:auto_master/app/data/error_handler.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import 'app_interceptor.dart';

class ApiClient {
  static const baseUrl = 'https://auto-master.pro';

  static const baseImageUrl = 'https://auto-master.pro/uploadsImg/';
  static const dadataApiKey = 'dd24fba5c683c187231b9481f5e3485bcd7b07f5';

  Dio dio(BuildContext context) => createDio(context);

  static Dio createDio(BuildContext context) {
    var dio = Dio(
      BaseOptions(baseUrl: baseUrl),
    );

    dio.interceptors.addAll({
      DioErrorHandler(context, dio),
      AppInterceptors(dio),
    });

    return dio;
  }

  ApiClient._internal();

  static final _singleton = ApiClient._internal();

  factory ApiClient() => _singleton;
}
