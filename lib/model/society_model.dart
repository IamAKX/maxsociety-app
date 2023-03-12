import 'dart:convert';

import 'package:maxsociety/model/society_address_model.dart';

class SocietyModel {
  int? societyCode;
  SocietyModel? societyDetails;
  SocietyAddressModel? address;
  String? phoneNo;
  SocietyModel({
    this.societyCode,
    this.address,
    this.phoneNo,
  });

  SocietyModel copyWith({
    int? societyCode,
    SocietyAddressModel? address,
    String? phoneNo,
  }) {
    return SocietyModel(
      societyCode: societyCode ?? this.societyCode,
      address: address ?? this.address,
      phoneNo: phoneNo ?? this.phoneNo,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'societyCode': societyCode,
      'address': address?.toMap(),
      'phoneNo': phoneNo,
    };
  }

  factory SocietyModel.fromMap(Map<String, dynamic> map) {
    return SocietyModel(
      societyCode: map['societyCode']?.toInt(),
      address: map['address'] != null
          ? SocietyAddressModel.fromMap(map['address'])
          : null,
      phoneNo: map['phoneNo'],
    );
  }

  String toJson() => json.encode(toMap());

  factory SocietyModel.fromJson(String source) =>
      SocietyModel.fromMap(json.decode(source));

  @override
  String toString() =>
      'SocietyModel(societyCode: $societyCode, address: $address, phoneNo: $phoneNo)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is SocietyModel &&
        other.societyCode == societyCode &&
        other.address == address &&
        other.phoneNo == phoneNo;
  }

  @override
  int get hashCode =>
      societyCode.hashCode ^ address.hashCode ^ phoneNo.hashCode;
}
