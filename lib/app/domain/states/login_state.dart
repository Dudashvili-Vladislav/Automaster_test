// ignore_for_file: use_build_context_synchronously

import 'dart:developer';

import 'package:auto_master/app/app.dart';
import 'package:auto_master/app/constatns.dart';
import 'package:auto_master/app/domain/models/customer_auth_entity.dart';
import 'package:auto_master/app/domain/service/auth_service.dart';
import 'package:auto_master/app/ui/routes/routes.dart';
import 'package:auto_master/app/ui/utils/show_message.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';

class LoginState extends ChangeNotifier {
  final _phoneController = TextEditingController();
  final _codeController = TextEditingController(); // Added for code input

  final _phoneNode = FocusNode();
  final _codeNode = FocusNode(); // Added for code input

  bool _phoneHasFocus = false;
  bool _codeHasFocus = false; // Added for code input

  bool _isLoading = false;
  bool _isCodeValid = false; // Added for code validation

  // Getters
  TextEditingController get phoneController => _phoneController;
  TextEditingController get codeController => _codeController; // Added

  FocusNode get phoneNode => _phoneNode;
  FocusNode get codeNode => _codeNode; // Added

  bool get phoneHasFocus => _phoneHasFocus;
  bool get codeHasFocus => _codeHasFocus; // Added

  bool get isLoading => _isLoading;
  bool get isCodeValid => _isCodeValid; // Added

  String get getFullPhone => phoneFormatter
      .maskText(_phoneController.text.trim())
      .replaceAll(' ', '');

  final BuildContext context;

  LoginState(this.context) {
    init();
  }

  void changeFocus(String type, bool value) {
    if (type == 'phone') {
      _phoneHasFocus = value;
    } else if (type == 'code') {
      _codeHasFocus = value;
    }
    notifyListeners();
  }

  void validateCode() {
    final code = _codeController.text.trim();
    _isCodeValid = code.length == 4; // Assuming code is 4 digits
    notifyListeners();
  }

  Future<bool> checkPhone() async {
    if (_phoneController.text.trim().isEmpty) {
      showMessage('Введите ваш номер телефона');
      return false;
    }

    _isLoading = true;
    notifyListeners();

    final result = await AuthService.checkPhone(context, getFullPhone);

    if (result != '200' && result != null) {
      showMessage(
        'Номер в системе не зарегистрирован',
        isError: false,
      );
      _isLoading = false;
      notifyListeners();
      return false;
    } else {
      _isLoading = false;
      notifyListeners();
      return true;
    }
  }

  Future<void> sendCode() async {
    if (_phoneController.text.trim().isEmpty) {
      showMessage('Введите ваш номер телефона');
      return;
    }

    _isLoading = true;
    notifyListeners();

    try {
      final result = await AuthService.getCode(context, getFullPhone);
      if (result != null) {
        showMessage('Код отправлен на ваш номер');
      } else {
        showMessage('Ошибка при отправке кода');
      }
    } catch (e) {
      log('ERROR in sendCode: $e');
      showMessage('Ошибка при отправке кода');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> resendCode() async {
    // This method calls sendCode to resend the code
    await sendCode();
  }

  Future<void> apiLogin() async {
    if (!_isCodeValid) {
      showMessage('Введите корректный код');
      return;
    }

    _isLoading = true;
    notifyListeners();

    final phone = getFullPhone;
    final code = _codeController.text.trim();

    try {
      final result = await AuthService.verifyCode(
        context,
        phone: phone,
        code: code,
      );

      if (result != null) {
        await Hive.box('settings').put('token', result.bearerToken);
        final isCustomer = await AuthService.getRole(context, phone);
        await Hive.box('settings').put('isClient', isCustomer);
        context.read<AppState>().onChangeRoute(
            isCustomer ? loggedInClientMap : loggedInMasterMap);
      } else {
        showMessage('Неверный код');
      }
    } catch (e) {
      log('ERROR in apiLogin: $e');
      showMessage('Ошибка авторизации');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void init() {
    _phoneNode.addListener(() => changeFocus('phone', _phoneNode.hasFocus));
    _codeNode.addListener(() => changeFocus('code', _codeNode.hasFocus));
  }

  @override
  void dispose() {
    _phoneController.dispose();
    _codeController.dispose();
    _phoneNode.removeListener(() => changeFocus('phone', _phoneNode.hasFocus));
    _codeNode.removeListener(() => changeFocus('code', _codeNode.hasFocus));
    _phoneNode.dispose();
    _codeNode.dispose();
    super.dispose();
  }
}
