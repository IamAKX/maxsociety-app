import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'package:maxsociety/model/vehicle_model.dart';

class FlatModel {
  int? floor;
  String? wing;
  String? tower;
  String? buitlUpArea;
  String? carpetArea;
  String? flatNo;
  String? type;
  List<VehicleModel>? vehicles;
  FlatModel({
    this.floor,
    this.wing,
    this.tower,
    this.buitlUpArea,
    this.carpetArea,
    this.flatNo,
    this.type,
    this.vehicles,
  });

  FlatModel copyWith({
    int? floor,
    String? wing,
    String? tower,
    String? buitlUpArea,
    String? carpetArea,
    String? flatNo,
    String? type,
    List<VehicleModel>? vehicles,
  }) {
    return FlatModel(
      floor: floor ?? this.floor,
      wing: wing ?? this.wing,
      tower: tower ?? this.tower,
      buitlUpArea: buitlUpArea ?? this.buitlUpArea,
      carpetArea: carpetArea ?? this.carpetArea,
      flatNo: flatNo ?? this.flatNo,
      type: type ?? this.type,
      vehicles: vehicles ?? this.vehicles,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'floor': floor,
      'wing': wing,
      'tower': tower,
      'buitlUpArea': buitlUpArea,
      'carpetArea': carpetArea,
      'flatNo': flatNo,
      'type': type,
      'vehicles': vehicles?.map((x) => x?.toMap())?.toList(),
    };
  }

  factory FlatModel.fromMap(Map<String, dynamic> map) {
    return FlatModel(
      floor: map['floor']?.toInt(),
      wing: map['wing'],
      tower: map['tower'],
      buitlUpArea: map['buitlUpArea'],
      carpetArea: map['carpetArea'],
      flatNo: map['flatNo'],
      type: map['type'],
      vehicles: map['vehicles'] != null
          ? List<VehicleModel>.from(
              map['vehicles']?.map((x) => VehicleModel.fromMap(x)))
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory FlatModel.fromJson(String source) =>
      FlatModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'FlatModel(floor: $floor, wing: $wing, tower: $tower, buitlUpArea: $buitlUpArea, carpetArea: $carpetArea, flatNo: $flatNo, type: $type, vehicles: $vehicles)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is FlatModel &&
        other.floor == floor &&
        other.wing == wing &&
        other.tower == tower &&
        other.buitlUpArea == buitlUpArea &&
        other.carpetArea == carpetArea &&
        other.flatNo == flatNo &&
        other.type == type &&
        listEquals(other.vehicles, vehicles);
  }

  @override
  int get hashCode {
    return floor.hashCode ^
        wing.hashCode ^
        tower.hashCode ^
        buitlUpArea.hashCode ^
        carpetArea.hashCode ^
        flatNo.hashCode ^
        type.hashCode ^
        vehicles.hashCode;
  }
}
