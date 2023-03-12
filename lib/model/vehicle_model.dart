import 'dart:convert';

import 'package:maxsociety/model/flat_model.dart';

class VehicleModel {
  String? vehicleNo;
  String? vehicleType;
  String? brand;
  String? model;
  String? image;
  String? flats;
  VehicleModel({
    this.vehicleNo,
    this.vehicleType,
    this.brand,
    this.model,
    this.image,
    this.flats,
  });

  VehicleModel copyWith({
    String? vehicleNo,
    String? vehicleType,
    String? brand,
    String? model,
    String? image,
    String? flats,
  }) {
    return VehicleModel(
      vehicleNo: vehicleNo ?? this.vehicleNo,
      vehicleType: vehicleType ?? this.vehicleType,
      brand: brand ?? this.brand,
      model: model ?? this.model,
      image: image ?? this.image,
      flats: flats ?? this.flats,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'vehicleNo': vehicleNo,
      'vehicleType': vehicleType,
      'brand': brand,
      'model': model,
      'image': image,
      'flats': flats,
    };
  }

  factory VehicleModel.fromMap(Map<String, dynamic> map) {
    return VehicleModel(
      vehicleNo: map['vehicleNo'],
      vehicleType: map['vehicleType'],
      brand: map['brand'],
      model: map['model'],
      image: map['image'],
      flats: map['flats'],
    );
  }

  String toJson() => json.encode(toMap());

  factory VehicleModel.fromJson(String source) =>
      VehicleModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'VehicleModel(vehicleNo: $vehicleNo, vehicleType: $vehicleType, brand: $brand, model: $model, image: $image, flats: $flats)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is VehicleModel &&
        other.vehicleNo == vehicleNo &&
        other.vehicleType == vehicleType &&
        other.brand == brand &&
        other.model == model &&
        other.image == image &&
        other.flats == flats;
  }

  @override
  int get hashCode {
    return vehicleNo.hashCode ^
        vehicleType.hashCode ^
        brand.hashCode ^
        model.hashCode ^
        image.hashCode ^
        flats.hashCode;
  }
}
