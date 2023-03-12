import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'package:maxsociety/model/vehicle_model.dart';

class VehicleModelList {
  List<VehicleModel>? data;
  VehicleModelList({
    this.data,
  });

  VehicleModelList copyWith({
    List<VehicleModel>? data,
  }) {
    return VehicleModelList(
      data: data ?? this.data,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'data': data?.map((x) => x?.toMap())?.toList(),
    };
  }

  factory VehicleModelList.fromMap(Map<String, dynamic> map) {
    return VehicleModelList(
      data: map['data'] != null ? List<VehicleModel>.from(map['data']?.map((x) => VehicleModel.fromMap(x))) : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory VehicleModelList.fromJson(String source) => VehicleModelList.fromMap(json.decode(source));

  @override
  String toString() => 'VehicleModelList(data: $data)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is VehicleModelList &&
      listEquals(other.data, data);
  }

  @override
  int get hashCode => data.hashCode;
}
