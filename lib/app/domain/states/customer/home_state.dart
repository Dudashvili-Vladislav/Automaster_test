// ignore_for_file: use_build_context_synchronously

import 'package:auto_master/app/app.dart';
import 'package:auto_master/app/constatns.dart';
import 'package:auto_master/app/domain/models/customer_car.dart';
import 'package:auto_master/app/domain/models/master.dart';
import 'package:auto_master/app/domain/models/spec.dart';
import 'package:auto_master/app/domain/service/auth_service.dart';
import 'package:auto_master/app/domain/service/customer_service.dart';
import 'package:auto_master/app/ui/routes/routes.dart';
import 'package:auto_master/app/ui/utils/get_position.dart';

import 'package:flutter/material.dart';

class HomeState extends ChangeNotifier {
  bool _isLoading = false;
  bool _isCreateLoading = false;
  List<Spec> _specs = [];
  List<MasterEntity> _mastersBySpec = [];
  Spec? _selectedSpec;
  String? _selectedSubactegory;
  CustomerCarEntity? _selectedCar;
  String _problem = '';
  DateTime? _dateFrom;
  // DateTime? _time;
  int? _radius;
  int? _hour;
  int? _minute;

  List<Spec> get specs => _specs;
  List<MasterEntity> get mastersBySpec => _mastersBySpec;
  Spec? get selectedSpec => _selectedSpec;
  String? get selectedSubCategory => _selectedSubactegory;
  CustomerCarEntity? get selectedCar => _selectedCar;
  bool get isLoading => _isLoading;
  bool get isCreateLoading => _isCreateLoading;
  int? get hour => _hour;
  int? get minute => _minute;
  DateTime? get date => _dateFrom;

  BuildContext context;
  HomeState(this.context) {
    Future.microtask(fetchSpecs);
  }

  Future<void> fetchSpecs() async {
    _isLoading = true;
    notifyListeners();

    _specs = await AuthService.getSpecs(context) ?? [];

    _isLoading = false;
    notifyListeners();
  }

  Future<void> fetchMasters() async {
    _isLoading = true;
    notifyListeners();

    print('SPEC');
    print(_selectedSpec!.nameOfCategory);
    print(_selectedSubactegory);

    _mastersBySpec = await CustomerService.getMastersBySpec(
            context,
            _selectedSubactegory?.isNotEmpty ?? false
                ? _selectedSubactegory!
                : _selectedSpec!.nameOfCategory) ??
        [];

    _isLoading = false;
    notifyListeners();
  }

  Future<void> createOrder() async {
    _isCreateLoading = true;
    notifyListeners();
    final dateFrom = dateFormatter.format(_dateFrom!);
    // final dateTo = _dateTo == null ? '' : dateFormatter.format(_dateTo!);
    final time =
        '${_dateFrom!.hour.toString().padLeft(2, '0')}:${_dateFrom!.minute.toString().padLeft(2, '0')}:00';
    final position = await getPosition();
    final lat = position?['lat'];
    final lon = position?['lon'];
    final params = {
      'carId': _selectedCar!.id.toString(),
      'specialization': _selectedSpec!.nameOfCategory,
      'radius': _radius,
      'orderDescription': _problem,
      'dateFrom': dateFrom,
      // 'dateTo': dateTo,
      'time': time,
      'latitude': lat == null ? '0' : lat.toString(),
      'longitude': lon == null ? '0' : lon.toString(),
    };

    if (selectedSubCategory?.isNotEmpty ?? false) {
      params['extraSpecialization'] = selectedSubCategory;
    }

    final result = await CustomerService.createOrder(context, params);

    if (result != null) {
      clear();
      routemaster.popUntil((routeData) => routeData.path == AppRoutes.home);
    }

    _isCreateLoading = false;
    notifyListeners();
  }

  Future<Map<String, dynamic>?> getPosition() async {
    final localPosition = await determinePosition();
    if (localPosition != null) {
      return {
        'lat': localPosition.latitude.toString(),
        'lon': localPosition.longitude.toString()
      };
    } else {
      final position = await AuthService.getPosition(context);

      if (position == null) return null;

      return position;
    }
  }

  void selectSpec(Spec? spec) {
    _selectedSpec = spec;
    notifyListeners();
  }

  void selectAuto(CustomerCarEntity? car) {
    _selectedCar = car;
    notifyListeners();
  }

  void setProblem(String? value) {
    _problem = value ?? '';
    notifyListeners();
  }

  void selectSubCetegory(String value) {
    _selectedSubactegory = value;
    notifyListeners();
  }

  void setDate({required DateTime dateFrom, DateTime? dateTo}) {
    _dateFrom = dateFrom;

    notifyListeners();
  }

  // void setTime(DateTime time) {
  //   _time = time;
  //   notifyListeners();
  // }

  void setHour(int hour) {
    _hour = hour;
    notifyListeners();
  }

  void setMinute(int minute) {
    _minute = minute;
    notifyListeners();
  }

  void setRadius(int radius) {
    _radius = radius;
    notifyListeners();
  }

  void clearTime() {
    _hour = null;
    _minute = null;
    notifyListeners();
  }

  void clear() {
    _selectedCar = null;
    _selectedSpec = null;
    _radius = null;
    _dateFrom = null;
    // _dateTo = null;
    // _time = null;
    _problem = '';
    _mastersBySpec.clear();
    clearTime();
    notifyListeners();
  }
}
