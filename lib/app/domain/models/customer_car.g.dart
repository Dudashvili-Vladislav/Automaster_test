// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'customer_car.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$CustomerCarEntityCWProxy {
  CustomerCarEntity bodyType(String? bodyType);

  CustomerCarEntity brand(String brand);

  CustomerCarEntity carNationality(String carNationality);

  CustomerCarEntity carNumber(String carNumber);

  CustomerCarEntity enginePower(String enginePower);

  CustomerCarEntity engineType(String engineType);

  CustomerCarEntity generation(String? generation);

  CustomerCarEntity icon(String icon);

  CustomerCarEntity id(int id);

  CustomerCarEntity model(String model);

  CustomerCarEntity ownerId(int ownerId);

  CustomerCarEntity typeOfDrive(String typeOfDrive);

  CustomerCarEntity vinNumber(String vinNumber);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `CustomerCarEntity(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// CustomerCarEntity(...).copyWith(id: 12, name: "My name")
  /// ````
  CustomerCarEntity call({
    String? bodyType,
    String? brand,
    String? carNationality,
    String? carNumber,
    String? enginePower,
    String? engineType,
    String? generation,
    String? icon,
    int? id,
    String? model,
    int? ownerId,
    String? typeOfDrive,
    String? vinNumber,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfCustomerCarEntity.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfCustomerCarEntity.copyWith.fieldName(...)`
class _$CustomerCarEntityCWProxyImpl implements _$CustomerCarEntityCWProxy {
  final CustomerCarEntity _value;

  const _$CustomerCarEntityCWProxyImpl(this._value);

  @override
  CustomerCarEntity bodyType(String? bodyType) => this(bodyType: bodyType);

  @override
  CustomerCarEntity brand(String brand) => this(brand: brand);

  @override
  CustomerCarEntity carNationality(String carNationality) =>
      this(carNationality: carNationality);

  @override
  CustomerCarEntity carNumber(String carNumber) => this(carNumber: carNumber);

  @override
  CustomerCarEntity enginePower(String enginePower) =>
      this(enginePower: enginePower);

  @override
  CustomerCarEntity engineType(String engineType) =>
      this(engineType: engineType);

  @override
  CustomerCarEntity generation(String? generation) =>
      this(generation: generation);

  @override
  CustomerCarEntity icon(String icon) => this(icon: icon);

  @override
  CustomerCarEntity id(int id) => this(id: id);

  @override
  CustomerCarEntity model(String model) => this(model: model);

  @override
  CustomerCarEntity ownerId(int ownerId) => this(ownerId: ownerId);

  @override
  CustomerCarEntity typeOfDrive(String typeOfDrive) =>
      this(typeOfDrive: typeOfDrive);

  @override
  CustomerCarEntity vinNumber(String vinNumber) => this(vinNumber: vinNumber);

  @override

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `CustomerCarEntity(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// CustomerCarEntity(...).copyWith(id: 12, name: "My name")
  /// ````
  CustomerCarEntity call({
    Object? bodyType = const $CopyWithPlaceholder(),
    Object? brand = const $CopyWithPlaceholder(),
    Object? carNationality = const $CopyWithPlaceholder(),
    Object? carNumber = const $CopyWithPlaceholder(),
    Object? enginePower = const $CopyWithPlaceholder(),
    Object? engineType = const $CopyWithPlaceholder(),
    Object? generation = const $CopyWithPlaceholder(),
    Object? icon = const $CopyWithPlaceholder(),
    Object? id = const $CopyWithPlaceholder(),
    Object? model = const $CopyWithPlaceholder(),
    Object? ownerId = const $CopyWithPlaceholder(),
    Object? typeOfDrive = const $CopyWithPlaceholder(),
    Object? vinNumber = const $CopyWithPlaceholder(),
  }) {
    return CustomerCarEntity(
      bodyType: bodyType == const $CopyWithPlaceholder()
          ? _value.bodyType
          // ignore: cast_nullable_to_non_nullable
          : bodyType as String?,
      brand: brand == const $CopyWithPlaceholder() || brand == null
          ? _value.brand
          // ignore: cast_nullable_to_non_nullable
          : brand as String,
      carNationality: carNationality == const $CopyWithPlaceholder() ||
              carNationality == null
          ? _value.carNationality
          // ignore: cast_nullable_to_non_nullable
          : carNationality as String,
      carNumber: carNumber == const $CopyWithPlaceholder() || carNumber == null
          ? _value.carNumber
          // ignore: cast_nullable_to_non_nullable
          : carNumber as String,
      enginePower:
          enginePower == const $CopyWithPlaceholder() || enginePower == null
              ? _value.enginePower
              // ignore: cast_nullable_to_non_nullable
              : enginePower as String,
      engineType:
          engineType == const $CopyWithPlaceholder() || engineType == null
              ? _value.engineType
              // ignore: cast_nullable_to_non_nullable
              : engineType as String,
      generation: generation == const $CopyWithPlaceholder()
          ? _value.generation
          // ignore: cast_nullable_to_non_nullable
          : generation as String?,
      icon: icon == const $CopyWithPlaceholder() || icon == null
          ? _value.icon
          // ignore: cast_nullable_to_non_nullable
          : icon as String,
      id: id == const $CopyWithPlaceholder() || id == null
          ? _value.id
          // ignore: cast_nullable_to_non_nullable
          : id as int,
      model: model == const $CopyWithPlaceholder() || model == null
          ? _value.model
          // ignore: cast_nullable_to_non_nullable
          : model as String,
      ownerId: ownerId == const $CopyWithPlaceholder() || ownerId == null
          ? _value.ownerId
          // ignore: cast_nullable_to_non_nullable
          : ownerId as int,
      typeOfDrive:
          typeOfDrive == const $CopyWithPlaceholder() || typeOfDrive == null
              ? _value.typeOfDrive
              // ignore: cast_nullable_to_non_nullable
              : typeOfDrive as String,
      vinNumber: vinNumber == const $CopyWithPlaceholder() || vinNumber == null
          ? _value.vinNumber
          // ignore: cast_nullable_to_non_nullable
          : vinNumber as String,
    );
  }
}

extension $CustomerCarEntityCopyWith on CustomerCarEntity {
  /// Returns a callable class that can be used as follows: `instanceOfCustomerCarEntity.copyWith(...)` or like so:`instanceOfCustomerCarEntity.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$CustomerCarEntityCWProxy get copyWith =>
      _$CustomerCarEntityCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CustomerCarEntity _$CustomerCarEntityFromJson(Map<String, dynamic> json) =>
    CustomerCarEntity(
      id: json['id'] as int,
      ownerId: json['ownerId'] as int,
      typeOfDrive: json['typeOfDrive'] as String,
      vinNumber: json['vinNumber'] as String,
      bodyType: json['bodyType'] as String?,
      brand: json['brand'] as String,
      carNationality: json['carNationality'] as String,
      carNumber: json['carNumber'] as String,
      enginePower: json['enginePower'] as String,
      engineType: json['engineType'] as String,
      model: json['model'] as String,
      icon: json['icon'] as String,
      generation: json['generation'] as String?,
    );

Map<String, dynamic> _$CustomerCarEntityToJson(CustomerCarEntity instance) =>
    <String, dynamic>{
      'typeOfDrive': instance.typeOfDrive,
      'vinNumber': instance.vinNumber,
      'bodyType': instance.bodyType,
      'brand': instance.brand,
      'carNationality': instance.carNationality,
      'carNumber': instance.carNumber,
      'enginePower': instance.enginePower,
      'engineType': instance.engineType,
      'model': instance.model,
      'icon': instance.icon,
      'generation': instance.generation,
    };
