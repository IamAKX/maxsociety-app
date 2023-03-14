import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'package:maxsociety/model/emergency_contact_model.dart';

class EmergencyContactListModel {
  List<EmergencyContactModel>? data;
  EmergencyContactListModel({
    this.data,
  });

  EmergencyContactListModel copyWith({
    List<EmergencyContactModel>? data,
  }) {
    return EmergencyContactListModel(
      data: data ?? this.data,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'data': data?.map((x) => x?.toMap())?.toList(),
    };
  }

  factory EmergencyContactListModel.fromMap(Map<String, dynamic> map) {
    return EmergencyContactListModel(
      data: map['data'] != null ? List<EmergencyContactModel>.from(map['data']?.map((x) => EmergencyContactModel.fromMap(x))) : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory EmergencyContactListModel.fromJson(String source) => EmergencyContactListModel.fromMap(json.decode(source));

  @override
  String toString() => 'EmergencyContactListModel(data: $data)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is EmergencyContactListModel &&
      listEquals(other.data, data);
  }

  @override
  int get hashCode => data.hashCode;
}
