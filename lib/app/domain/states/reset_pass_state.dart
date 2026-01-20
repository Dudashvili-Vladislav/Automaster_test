// ignore_for_file: use_build_context_synchronously

import 'package:auto_master/app/domain/service/auth_service.dart';

import 'package:auto_master/app/ui/screens/auth/pages/auth_user/auth_forgot_success_screen.dart';
import 'package:auto_master/app/ui/screens/auth/pages/auth_user/auth_new_password_screen.dart';
import 'package:auto_master/app/ui/utils/show_message.dart';
import 'package:flutter/cupertino.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'package:provider/provider.dart';

class ResetPassState extends ChangeNotifier {
  final _codeController = TextEditingController();
  final _passController = TextEditingController();
  final _passConfirmController = TextEditingController();

  final _codeNode = FocusNode();
  final _passNode = FocusNode();
  final _passConfirmNode = FocusNode();

  bool _codeHasFocus = false;
  bool _passHasFocus = false;
  bool _passConfirmHasFocus = false;

  bool _isLoading = false;
  bool _hasValid = false;

  // Getters
  TextEditingController get codeController => _codeController;
  TextEditingController get passController => _passController;
  TextEditingController get passConfirmController => _passConfirmController;

  FocusNode get codeNode => _codeNode;
  FocusNode get passNode => _passNode;
  FocusNode get passConfirmNode => _passConfirmNode;

  bool get codeHasFocus => _codeHasFocus;
  bool get passHasFocus => _passHasFocus;
  bool get passConfirmHasFocus => _passConfirmHasFocus;

  bool get isLoading => _isLoading;
  bool get hasValid => _hasValid;

  BuildContext context;
  String phone;

  ResetPassState(this.context, this.phone) {
    Future.microtask(getCode);
    init();
  }

  void validatePass() {
    final pass = passController.text.trim();
    final passConfirm = passConfirmController.text.trim();

    final passLengthExpression = pass.length >= 8 && passConfirm.length >= 8;

    final passRegex = RegExp('(?=.*[!@#\$%^&*])(?=.*[A-Z])');

    final passRegexExpression = passRegex.hasMatch(pass);

    if (passLengthExpression &&
        passRegexExpression &&
        pass == passConfirm &&
        passRegexExpression) {
      _hasValid = true;
      setState();
      return;
    }

    _hasValid = false;
    setState();
  }

  void changeFocus(String type, bool value) {
    if (type == 'code') {
      _codeHasFocus = value;
    } else if (type == 'pass') {
      _passHasFocus = value;
    } else {
      _passConfirmHasFocus = value;
    }

    notifyListeners();
  }

  Future<void> getCode() async {
    final code = await AuthService.getCode(context, phone);

    // showMessage(code ?? '', isError: false);
  }

  Future<void> checkCode() async {
    _isLoading = true;
    notifyListeners();

    final result = await AuthService.checkCode(
        context, phone, _codeController.text.trim());

    if (result != '200') {
      showMessage('Введен неправильный код');
    } else {
      Navigator.push(
        context,
        CupertinoPageRoute(
          builder: (context) => ChangeNotifierProvider.value(
            value: this,
            child: const AuthNewPasswordScreen(),
          ),
        ),
      );
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> apiResetPass() async {
    _isLoading = true;
    notifyListeners();

    final code = _codeController.text.trim();
    final pass = _passController.text.trim();

    final isCustomer = await AuthService.getRole(context, phone);

    final result = await AuthService.resetPass(
      context,
      code: code,
      phone: phone,
      password: pass,
    );

    if (result != null) {
      await Hive.box('settings').put('token', result.bearerToken);
      await Hive.box('settings').put('isClient', isCustomer);

      Navigator.push(
        context,
        CupertinoPageRoute(
          builder: (context) => AuthForgotSuccessScreen(
            isCustomer: isCustomer,
          ),
        ),
      );
    } else {
      showMessage('Произошла ошибка при изменении пароля');
    }

    _isLoading = false;
    notifyListeners();
  }

  void setState() {
    notifyListeners();
  }

  void init() {
    _codeNode.addListener(() => changeFocus('code', _codeNode.hasFocus));
    _passNode.addListener(() => changeFocus('pass', _passNode.hasFocus));
    _passConfirmNode
        .addListener(() => changeFocus('passConfirm', _passNode.hasFocus));
  }

  @override
  void dispose() {
    _codeController.dispose();
    _passController.dispose();
    _passConfirmController.dispose();
    _codeNode.removeListener(() => changeFocus('code', _codeNode.hasFocus));
    _passNode.removeListener(() => changeFocus('pass', _passNode.hasFocus));
    _passConfirmNode
        .removeListener(() => changeFocus('passConfirm', _passNode.hasFocus));
    super.dispose();
  }
}
