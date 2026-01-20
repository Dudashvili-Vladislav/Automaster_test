// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'dart:io';

import 'package:auto_master/app/app.dart';
import 'package:auto_master/app/constatns.dart';
import 'package:auto_master/app/domain/models/master.dart';
import 'package:auto_master/app/domain/models/spec.dart';
import 'package:auto_master/app/domain/service/auth_service.dart';
import 'package:auto_master/app/domain/service/customer_service.dart';
import 'package:auto_master/app/domain/service/master_service.dart';
import 'package:auto_master/app/domain/states/chat/chat_bloc.dart';
import 'package:auto_master/app/ui/routes/routes.dart';
import 'package:auto_master/app/ui/screens/edit_master_info/edit_type_master.dart';
import 'package:auto_master/app/ui/utils/pick_image.dart';
import 'package:auto_master/app/ui/utils/show_message.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class MasterProfileState extends ChangeNotifier {
  bool _isLoading = false;
  MasterEntity? _profile;
  PickImageState? _image;

  final _phoneController = TextEditingController();
  final _nameController = TextEditingController();

  final _phoneNode = FocusNode();
  final _nameNode = FocusNode();

  bool _phoneHasFocus = false;
  bool _nameHasFocus = false;
  bool _allMarksSelected = false;

  List<Spec> _specs = [];
  final List<String> _selectedCarBrands = [];
  // int _selectedPage = 0;

  Spec? _selectedSpec;
  String? _selectedSubCategory;
  String? _selectedCarType;
  String? _selectedExperience;
  String? _selectedAddress;
  String? _serviceName;
  String? _serviceDesc;
  PickImageState? _selectedImage;

  // Getters
  TextEditingController get phoneController => _phoneController;
  TextEditingController get nameController => _nameController;

  FocusNode get phoneNode => _phoneNode;
  FocusNode get nameNode => _nameNode;

  bool get phoneHasFocus => _phoneHasFocus;
  bool get nameHasFocus => _nameHasFocus;
  bool get allMarksSelected => _allMarksSelected;

  bool get isLoading => _isLoading;
  MasterEntity? get profile => _profile;
  PickImageState? get imagePath => _image;

  List<Spec> get specs => _specs;
  List<String> get selectedCarBrands => _selectedCarBrands;
  Spec? get selectedSpec => _selectedSpec;
  String? get selectedSubCategory => _selectedSubCategory;
  String? get selectedCarType => _selectedCarType;
  String? get selectedExperience => _selectedExperience;
  String? get selectedAddress => _selectedAddress;
  String? get serviceName => _serviceName;
  String? get serviceDesc => _serviceDesc;
  PickImageState? get selectedImage => _selectedImage;
  // int get selectedPage => _selectedPage;

  BuildContext context;
  final ChatBloc chatBloc;
  MasterProfileState(this.context, {required this.chatBloc}) {
    print('Init MasterProfileState');
    Future.microtask(() async {
      await getSpecs();
      fetchProfile();
    });
  }

  // void onChangePage(int index) {
  //   Fluttertoast.showToast(msg: 'selectedPage=$_selectedPage index=$index');
  //   if (_selectedPage == index) return;

  //   _selectedPage = index;
  //   notifyListeners();
  // }

  Future<void> fetchProfile() async {
    _isLoading = true;
    notifyListeners();

    _profile = await MasterService.getMaster(context);

    if (profile != null) {
      chatBloc.init(context).then((value) async {
        chatBloc.add(SetMasterName(profile!.name));
        chatBloc.add(
          SetChatName(
            _profile!.specialization,
            _profile!.extraSpecialization ?? '',
          ),
        );
        // await chatBloc.getMessages();
      });
    }

    if (_profile != null) {
      _nameController.text = _profile!.name;
      _phoneController.text =
          phoneFormatter.maskText(_profile!.phone).replaceAll('+7', '');
      _selectedAddress = _profile?.workAddress;
      _selectedExperience = _profile?.experience;
      _selectedCarType = _profile?.countryCar;
      try {
        _selectedSpec = _specs
            .firstWhere((e) => e.nameOfCategory == _profile?.specialization);
        _selectedSubCategory = _profile?.extraSpecialization;
      } catch (_) {}

      _serviceName = _profile?.stoName;
      _serviceDesc = _profile?.workDescription;

      if (_profile?.specialization == null ||
          _profile?.specialization == 'NO_DATA') {
        Navigator.of(context, rootNavigator: true).push(
          MaterialPageRoute(
            builder: (_) => ChangeNotifierProvider.value(
              value: this,
              child: const EditTypeMaster(backExist: false),
            ),
          ),
        );
      }
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> updateProfile(BuildContext context,
      {PickImageState? image, bool changePhone = false}) async {
    _isLoading = true;
    notifyListeners();

    final model = profile?.copyWith(
      countryCar: _selectedCarType,
      specialization: _selectedSpec?.nameOfCategory,
      stoName: _serviceName,
      workAddress: _selectedAddress,
      workDescription: _serviceDesc,
    );

    final data = {
      'phone': changePhone
          ? '+7${_phoneController.text.trim().replaceAll(' ', '')}'
          : model?.phone,
      'specialization': model?.specialization,
      'stoName': model?.stoName,
      'workAddress': model?.workAddress,
      'workDescription': model?.workDescription,
      'countryCar': model?.countryCar,
      'experience': _selectedExperience,
      'name': _nameController.text,
      'extraSpecialization': _selectedSubCategory
    };

    if (allMarksSelected) {
      data.addAll({'carBrandJsonList': "ALL"});
    } else if (_selectedCarBrands.isNotEmpty) {
      final brands = jsonEncode(_selectedCarBrands).toString();
      data.addAll({'carBrandJsonList': brands});
    }

    final res = await MasterService.editMasterData(context, data);

    await updateImage(image: image);
    await fetchProfile();
    _selectedImage = null;
    routemaster.history.back();
    if (res) {
      showMessage('Ваши данные успешно изменены', isError: false);
    } else {
      showMessage('Произошла ошибка при изменении профиля', isError: true);
    }
    _isLoading = false;
    notifyListeners();
  }

  Future<void> updateImage({PickImageState? image}) async {
    if (image != null) {
      await MasterService.setMasterAvatar(context, image);
    }
  }

  Future<void> deleteAvatar() async {
    _isLoading = true;
    notifyListeners();
    await MasterService.deleteMasterAvatar(context);
    await fetchProfile();
    _isLoading = false;
    notifyListeners();
  }

  Future<void> deleteProfile() async {
    _isLoading = true;
    notifyListeners();

    final result = await MasterService.deleteMaster(context);

    if (result) {
      context.read<AppState>().onLogOut();
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<bool> checkPhone({bool showMsg = true}) async {
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
      if (showMsg) {
        showMessage(
          'Номер в системе зарегистрирован',
        );
      }
      _isLoading = false;
      notifyListeners();
      return false;
    }
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

  Future<void> changeRole() async {
    _isLoading = true;
    notifyListeners();

    final token = await MasterService.changeRoleToCustomer(context);
    if (token != null) {
      await Hive.box('settings').put('token', token);
      await Hive.box('settings').put('isClient', true);
      context.read<AppState>().onChangeRoute(loggedInClientMap);
    }
    _isLoading = false;
    notifyListeners();
  }

  void onImagePicked(PickImageState? image) {
    _image = image;
    notifyListeners();
  }

  void onSelectImagePicked(PickImageState image) {
    _selectedImage = image;
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

  void selectSpec(Spec? item) {
    if (_selectedSpec != item) {
      _selectedSubCategory = null;
    }
    _selectedSpec = item;
    notifyListeners();
  }

  void selectSubCategory(String? item) {
    _selectedSubCategory = item;
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

  Future<void> getSpecs() async {
    _isLoading = true;
    notifyListeners();

    _specs = await AuthService.getSpecs(context) ?? [];

    _isLoading = false;
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
