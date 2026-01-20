// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'dart:developer';

import 'package:auto_master/app/app.dart';
import 'package:auto_master/app/constatns.dart';
import 'package:auto_master/app/domain/models/address.dart';
import 'package:auto_master/app/domain/models/spec.dart';
import 'package:auto_master/app/domain/service/auth_service.dart';
import 'package:auto_master/app/domain/service/master_service.dart';
import 'package:auto_master/app/domain/states/master/master_profile_state.dart';
import 'package:auto_master/app/ui/routes/routes.dart';
import 'package:auto_master/app/ui/screens/screens.dart';
import 'package:auto_master/app/ui/utils/get_position.dart';
import 'package:auto_master/app/ui/utils/pick_image.dart';
import 'package:auto_master/app/ui/utils/show_message.dart';
import 'package:auto_master/main.dart';
import 'package:flutter/cupertino.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';

class RegisterState extends ChangeNotifier {
  BuildContext context;

  RegisterState(this.context) {
    init();
  }

  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _nameNode = FocusNode();
  final _phoneNode = FocusNode();

  String _pass = '';

  bool _nameHasFocus = false;
  bool _phoneHasFocus = false;

  bool _nameAndPhoneValidated = false;

  bool _isPhoneCheckLoading = false;
  bool _isCheckCodeLoading = false;
  bool _isRegisterLoading = false;

  bool _isLoading = false;
  bool _allMarksSelected = false;

  List<Spec> _specs = [];
  List<Address> _address = [];
  final List<String> _selectedCarBrands = [];

  Spec? _selectedSpec;
  String? _selectedSubCategory;
  String? _selectedCarType;
  String? _selectedExperience;
  String? _selectedAddress;
  String? _serviceName;
  String? _serviceDesc;
  PickImageState? _image;

  // Getters
  bool get nameHasFocus => _nameHasFocus;
  bool get phoneHasFocus => _phoneHasFocus;
  bool get nameAndPhoneValidated => _nameAndPhoneValidated;
  bool get isPhoneCheckLoading => _isPhoneCheckLoading;
  bool get isCheckCodeLoading => _isCheckCodeLoading;
  bool get isRegisterLoading => _isRegisterLoading;
  bool get isLoading => _isLoading;
  bool get allMarksSelected => _allMarksSelected;
  PickImageState? get chosenImage => _image;

  FocusNode get nameNode => _nameNode;
  FocusNode get phoneNode => _phoneNode;

  TextEditingController get nameController => _nameController;
  TextEditingController get phoneController => _phoneController;

  List<Spec> get specs => _specs;

  List<String> get selectedCarBrands => _selectedCarBrands;
  Spec? get selectedSpec => _selectedSpec;
  String? get selectedSubCategory => _selectedSubCategory;
  String? get selectedCarType => _selectedCarType;
  String? get selectedExperience => _selectedExperience;
  String? get selectedAddress => _selectedAddress;
  String? get serviceName => _serviceName;
  String? get serviceDesc => _serviceDesc;

  List<Address> get address => _address;

  String get getFullPhone =>
      phoneFormatter.maskText(_phoneController.text.trim()).replaceAll(' ', '');

  Future<void> checkPhone() async {
    _isPhoneCheckLoading = true;
    notifyListeners();

    final result = await AuthService.checkPhone(context, getFullPhone);

    if (result != '200' && result != null) {
      getCode(getFullPhone);
    } else {
      showMessage(
        'Номер в системе зарегистрирован',
      );
    }

    _isPhoneCheckLoading = false;
    notifyListeners();
  }

  void clear() {
    _nameController.clear();
    _phoneController.clear();
    // _nameNode.unfocus();
    // _phoneNode.unfocus();
    // _nameHasFocus = false;
    // _phoneHasFocus = false;
    // _nameAndPhoneValidated = false;
    _specs = [];
    _address = [];
    _selectedCarBrands.clear();

    _selectedSpec = null;
    _selectedSubCategory = null;
    _selectedCarType = null;
    _selectedExperience = null;
    _selectedAddress = null;
    _serviceName = null;
    _serviceDesc = null;
    _image = null;
  }

  Future<void> getCode(String phone) async {
    _isPhoneCheckLoading = true;
    notifyListeners();

    final code = await AuthService.getCode(context, phone);
    // if (code != '200') {
    //   showMessage('Не удалось начать звонок по указанному номеру');
    // }
    // routemaster.push(AppRoutes.registerVerify);

    routemaster.push(AppRoutes.registerVerify);
    // Navigator.push(
    //   context,
    //   CupertinoPageRoute(
    //     builder: (context) => ChangeNotifierProvider.value(
    //       value: this,
    //       child: const AuthCodeVerifyScreen(),
    //     ),
    //   ),
    // );
    // showMessage(code ?? '', isError: false);

    _isPhoneCheckLoading = false;
    notifyListeners();
  }

  Future<void> checkCode(String code, String pass) async {
    _isCheckCodeLoading = true;
    notifyListeners();

    final result = await AuthService.checkCode(context, getFullPhone, code);

    if (result != '200') {
      showMessage('Введен неправильный код');
    } else {
      _pass = pass;
      routemaster.push(AppRoutes.registerChoose);
      // Navigator.push(
      //   context,
      //   CupertinoPageRoute(
      //     builder: (context) => ChangeNotifierProvider.value(
      //       value: this,
      //       child: const AuthTypeChooseSceen(),
      //     ),
      //   ),
      // );
    }

    _isCheckCodeLoading = false;
    notifyListeners();
  }

  Future<void> registerClient() async {
    _isRegisterLoading = true;
    notifyListeners();
    final pushToken = await notifyService.getUserTokenId();

    final result = await AuthService.registerCustomer(
      context,
      phone: getFullPhone,
      name: _nameController.text.trim(),
      password: _pass,
      pushToken: pushToken,
    );

    if (result != null) {
      await Hive.box('settings').put('token', result.bearerToken);
      await Hive.box('settings').put('isClient', true);
      await getAndSetPosition(result.bearerToken);
      context.read<AppState>().onChangeRoute(loggedInClientMap);
    }

    _isRegisterLoading = false;
    notifyListeners();
  }

  // Master
  void selectSpec(Spec? item) {
    _selectedSpec = item;
    notifyListeners();
  }

  void selectSubCategory(String? item) {
    _selectedSubCategory = item;
    print(item);
    notifyListeners();
  }

  void selectCarType(String? item) {
    _selectedCarType = item;
    notifyListeners();
  }

  void setExperience(String? item) {
    _selectedExperience = item;
    notifyListeners();
  }

  void setAddress(String? item) {
    _selectedAddress = item;
    notifyListeners();
  }

  void setServiceName(String? item) {
    _serviceName = item;
    notifyListeners();
  }

  void setServiceDesc(String? item) {
    _serviceDesc = item;
    notifyListeners();
  }

  void setImage(PickImageState image) {
    _image = image;
    notifyListeners();
  }

  void onSearch(String query) async {
    _address.clear();

    final cities = await MasterService.searchAdress(context, query);

    if (cities != null) {
      _address = cities;
    }

    notifyListeners();
  }

  Future<void> getSpecs() async {
    _isLoading = true;
    notifyListeners();

    _specs = await AuthService.getSpecs(context) ?? [];

    _isLoading = false;
    notifyListeners();
  }

  Future<void> getAndSetPosition(String token) async {
    try {
      final localPosition = await determinePosition();
      if (localPosition != null) {
        await AuthService.setPosition(
          context,
          token,
          localPosition.latitude.toString(),
          localPosition.longitude.toString(),
        );
      } else {
        final position = await AuthService.getPosition(context);

        if (position == null) return;
        await AuthService.setPosition(
          context,
          token,
          position['lat'].toString(),
          position['lon'].toString(),
        );
      }
    } catch (e) {
      log('ERROR in get and set position: $e');
    }
  }

  Future<void> registerMaster() async {
    _isLoading = true;
    notifyListeners();

    final pushToken = await notifyService.getUserTokenId();
    log('reg with pushToken $pushToken');

    final params = {
      'countryCar': _selectedCarType,
      'experience': _selectedExperience,
      'name': _nameController.text.trim(),
      'password': _pass,
      'phone': getFullPhone,
      'pushToken': pushToken ?? '',
      'specialization': _selectedSpec!.nameOfCategory,
      'stoName': _serviceName ?? '',
      'workAddress': _selectedAddress,
      'workDescription': _serviceDesc ?? '',
    };

    if (_selectedSubCategory != null && _selectedSubCategory!.isNotEmpty) {
      params['extraSpecialization'] = _selectedSubCategory;
    }

    if (allMarksSelected) {
      params.addAll({'carBrandJsonList': "ALL"});
    } else if (_selectedCarBrands.isNotEmpty) {
      final brands = jsonEncode(_selectedCarBrands).toString();
      params.addAll({'carBrandJsonList': brands});
    }

    final result = await AuthService.registerMaster(context, params);

    if (result != null) {
      await Hive.box('settings').put('token', result.bearerToken);
      await Hive.box('settings').put('isClient', false);
      await getAndSetPosition(result.bearerToken);
      if (_image != null) await updateImage(image: _image);
      context.read<AppState>().onChangeRoute(loggedInMasterMap);
      context.read<MasterProfileState>().fetchProfile();
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> updateImage({PickImageState? image}) async {
    if (image != null) {
      await MasterService.setMasterAvatar(context, image);
    }
  }

  void validateNameAndPhone() {
    final name = _nameController.text.trim();
    final phone = phoneFormatter.maskText(_phoneController.text.trim());

    _nameAndPhoneValidated = (name.length >= 3 && phone.length == 18);

    notifyListeners();
  }

  void changeFocus(String type, bool value) {
    if (type == 'name') {
      _nameHasFocus = value;
    } else {
      _phoneHasFocus = value;
    }

    notifyListeners();
  }

  void selectBrand(String item) {
    if (_selectedCarBrands.contains(item)) return;
    _selectedCarBrands.add(item);

    notifyListeners();
  }

  void deleteBrand(String item) {
    if (!_selectedCarBrands.contains(item)) return;
    _selectedCarBrands.remove(item);

    notifyListeners();
  }

  void toggleAllMarks() {
    _allMarksSelected = !_allMarksSelected;

    notifyListeners();
  }

  void init() {
    _nameNode.addListener(() => changeFocus('name', _nameNode.hasFocus));
    _phoneNode.addListener(() => changeFocus('phone', _phoneNode.hasFocus));
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _nameNode.removeListener(() => changeFocus('name', _nameNode.hasFocus));
    _phoneNode.removeListener(() => changeFocus('phone', _phoneNode.hasFocus));
    super.dispose();
  }
}
