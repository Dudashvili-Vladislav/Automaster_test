// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:auto_master/app/app.dart';
import 'package:auto_master/app/constatns.dart';
import 'package:auto_master/app/domain/models/customer.dart';
import 'package:auto_master/app/domain/models/customer_car.dart';
import 'package:auto_master/app/domain/service/auth_service.dart';
import 'package:auto_master/app/domain/service/customer_service.dart';
import 'package:auto_master/app/domain/states/chat/chat_bloc.dart';
import 'package:auto_master/app/domain/states/master/master_profile_state.dart';
import 'package:auto_master/app/ui/routes/routes.dart';
import 'package:auto_master/app/ui/utils/pick_image.dart';
import 'package:auto_master/app/ui/utils/show_message.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class CustomerProfileState extends ChangeNotifier {
  bool _isLoading = false;
  bool _deleteCarLoading = false;
  CustomerEntity? _profile;
  List<CustomerCarEntity> _cars = [];
  PickImageState? _image;
  CustomerCarEntity? _selectedCar;

  final _phoneController = TextEditingController();
  final _nameController = TextEditingController();

  final _phoneNode = FocusNode();
  final _nameNode = FocusNode();

  bool _phoneHasFocus = false;
  bool _nameHasFocus = false;

  // Getters
  TextEditingController get phoneController => _phoneController;
  TextEditingController get nameController => _nameController;

  FocusNode get phoneNode => _phoneNode;
  FocusNode get nameNode => _nameNode;

  bool get phoneHasFocus => _phoneHasFocus;
  bool get nameHasFocus => _nameHasFocus;

  bool get isLoaing => _isLoading;
  bool get deleteCarLoading => _deleteCarLoading;
  CustomerEntity? get profile => _profile;
  List<CustomerCarEntity> get cars => _cars;
  PickImageState? get imagePath => _image;
  CustomerCarEntity? get selectedCar => _selectedCar;

  BuildContext context;
  CustomerProfileState(this.context) {
    Future.microtask(() {
      fetchProfile();
      fetchCars();
    });
  }

  Future<void> fetchProfile() async {
    _isLoading = true;
    notifyListeners();

    _profile = await CustomerService.getCustomer(context);

    if (_profile != null) {
      _nameController.text = _profile!.name;
      _phoneController.text =
          phoneFormatter.maskText(_profile!.phone).replaceAll('+7', '');
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> fetchCars() async {
    _isLoading = true;
    notifyListeners();

    _cars = await CustomerService.getCarsList(context) ?? [];

    if (_cars.isNotEmpty) {
      _selectedCar = _cars.first;
    }

    if (cars.isEmpty) {
      _selectedCar = null;
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> deleteCar(int carId) async {
    _deleteCarLoading = true;
    notifyListeners();

    await CustomerService.deleteCustomerCar(context, carId);
    if (_selectedCar?.id == carId) {
      _selectedCar = null;
    }
    await fetchCars();

    _deleteCarLoading = false;
    notifyListeners();
  }

  Future<void> deleteAvatar() async {
    _isLoading = true;
    notifyListeners();

    await CustomerService.deleteCustomerAvatar(context);
    await fetchProfile();
    _isLoading = false;
    notifyListeners();
  }

  Future<void> changeRole() async {
    _isLoading = true;
    notifyListeners();

    final token = await CustomerService.changeRoleToMaster(context);
    if (token != null) {
      await Hive.box('settings').put('token', token);
      await Hive.box('settings').put('isClient', false);
      context.read<AppState>().onChangeRoute(loggedInMasterMap);
      final ChatBloc chatBloc = context.read<ChatBloc>();
      chatBloc.restartTimer();
      context.read<MasterProfileState>().fetchProfile();
    }
    _isLoading = false;
    notifyListeners();
  }

  Future<void> deleteProfile() async {
    _isLoading = true;
    notifyListeners();

    final result = await CustomerService.deleteCustomer(context);

    if (result) {
      context.read<AppState>().onLogOut();
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<String?> getCode() async {
    _isLoading = true;
    notifyListeners();
    final phone = '+7${_phoneController.text.trim().replaceAll(' ', '')}';

    final code = await AuthService.getCode(context, phone);
    // if (code != null) showMessage(code.toString(), isError: false);
    _isLoading = false;
    notifyListeners();
    return code;
  }

  Future<bool> checkCode(String code) async {
    _isLoading = true;
    notifyListeners();
    final phone = '+7${_phoneController.text.trim().replaceAll(' ', '')}';

    final result = await AuthService.checkCode(context, phone, code);

    if (result != '200') {
      showMessage('Введен неправильный код');
      _isLoading = false;
      notifyListeners();
      return false;
    } else {
      _isLoading = false;
      notifyListeners();
      return true;
    }
  }

  Future<bool> checkPhone() async {
    _isLoading = true;
    notifyListeners();
    final phone = '+7${_phoneController.text.trim().replaceAll(' ', '')}';

    final result = await AuthService.checkPhone(context, phone);

    if (result != '200' && result != null) {
      getCode();
      _isLoading = false;
      notifyListeners();
      return true;
    } else {
      showMessage(
        'Номер в системе зарегистрирован',
      );
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<void> updateProfile() async {
    _isLoading = true;
    notifyListeners();

    final name = _nameController.text.trim();
    final phone = '+7${_phoneController.text.trim().replaceAll(' ', '')}';

    if (name != profile!.name || phone != profile!.phone) {
      final model = profile?.copyWith(name: name, phone: phone);
      final result = await CustomerService.editCustomer(context, model!);

      if (result != null) {
        _profile = result;
      }
    }

    if (_image != null) {
      await CustomerService.setCustomerAvatar(context, _image!);
    }

    await fetchProfile();

    routemaster.pop();
    _isLoading = false;
    notifyListeners();
  }

  void onImagePicked(PickImageState image) {
    _image = image;
    notifyListeners();
  }

  void selectCar(CustomerCarEntity car) {
    _selectedCar = car;
    notifyListeners();
  }

  void changeFocus(String type, bool value) {
    if (type == 'phone') {
      _phoneHasFocus = value;
    } else {
      _nameHasFocus = value;
    }

    notifyListeners();
  }

  void init() {
    _phoneNode.addListener(() => changeFocus('phone', _phoneNode.hasFocus));
    _nameNode.addListener(() => changeFocus('name', _nameNode.hasFocus));
  }

  @override
  void dispose() {
    _phoneController.dispose();
    _nameController.dispose();
    _phoneNode.removeListener(() => changeFocus('phone', _phoneNode.hasFocus));
    _nameNode.removeListener(() => changeFocus('name', _nameNode.hasFocus));

    super.dispose();
  }
}
