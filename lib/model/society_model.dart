import 'dart:convert';

import 'package:maxsociety/model/society_address_model.dart';
import 'package:maxsociety/model/society_detail_model.dart';

class SocietyModel {
  int? societyCode;
  SocietyDetailModel? societyDetails;
  SocietyAddressModel? address;
  String? phoneNo;
  SocietyModel({
    this.societyCode,
    this.societyDetails,
    this.address,
    this.phoneNo,
  });

  SocietyModel copyWith({
    int? societyCode,
    SocietyDetailModel? societyDetails,
    SocietyAddressModel? address,
    String? phoneNo,
  }) {
    return SocietyModel(
      societyCode: societyCode ?? this.societyCode,
      societyDetails: societyDetails ?? this.societyDetails,
      address: address ?? this.address,
      phoneNo: phoneNo ?? this.phoneNo,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'societyCode': societyCode,
      'societyDetails': societyDetails?.toMap(),
      'address': address?.toMap(),
      'phoneNo': phoneNo,
    };
  }

  factory SocietyModel.fromMap(Map<String, dynamic> map) {
    return SocietyModel(
      societyCode: map['societyCode']?.toInt(),
      societyDetails: map['societyDetails'] != null
          ? SocietyDetailModel.fromMap(map['societyDetails'])
          : null,
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
  String toString() {
    return 'SocietyModel(societyCode: $societyCode, societyDetails: $societyDetails, address: $address, phoneNo: $phoneNo)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is SocietyModel &&
        other.societyCode == societyCode &&
        other.societyDetails == societyDetails &&
        other.address == address &&
        other.phoneNo == phoneNo;
  }

  @override
  int get hashCode {
    return societyCode.hashCode ^
        societyDetails.hashCode ^
        address.hashCode ^
        phoneNo.hashCode;
  }
}
