import 'package:auto_master/app/data/api_client.dart';
import 'package:auto_master/app/data/app_interceptor.dart';
import 'package:auto_master/app/domain/service/auth_service.dart';
import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SupportData {
  final String phone;
  final String whatsApp;

  const SupportData({
    required this.phone,
    required this.whatsApp,
  });

  const SupportData.initial()
      : phone = "",
        whatsApp = "";

  String get clearPhone => phone.replaceAll(RegExp(r'[+() -]'), '');
}

class SupportDataCubit extends Cubit<SupportData> {
  SupportDataCubit() : super(const SupportData.initial()) {
    dio.interceptors.addAll([
      AppInterceptors(dio),
    ]);
  }

  final dio = Dio(
    BaseOptions(baseUrl: ApiClient.baseUrl),
  );

  Future<void> init() async {
    final response = await dio.get(
      '/mobil/get_support_data',
    );
    final json = response.data as Map<String, dynamic>;
    emit(
      SupportData(
        phone: json['phone'],
        whatsApp: json['whatsApp'],
      ),
    );
  }
}
