import 'dart:convert';

class SocietyAddressModel {
  String? addressLine1;
  String? addressLine2;
  String? city;
  String? state;
  String? zipCode;
  SocietyAddressModel({
    this.addressLine1,
    this.addressLine2,
    this.city,
    this.state,
    this.zipCode,
  });

  SocietyAddressModel copyWith({
    String? addressLine1,
    String? addressLine2,
    String? city,
    String? state,
    String? zipCode,
  }) {
    return SocietyAddressModel(
      addressLine1: addressLine1 ?? this.addressLine1,
      addressLine2: addressLine2 ?? this.addressLine2,
      city: city ?? this.city,
      state: state ?? this.state,
      zipCode: zipCode ?? this.zipCode,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'addressLine1': addressLine1,
      'addressLine2': addressLine2,
      'city': city,
      'state': state,
      'zipCode': zipCode,
    };
  }

  factory SocietyAddressModel.fromMap(Map<String, dynamic> map) {
    return SocietyAddressModel(
      addressLine1: map['addressLine1'],
      addressLine2: map['addressLine2'],
      city: map['city'],
      state: map['state'],
      zipCode: map['zipCode'],
    );
  }

  String toJson() => json.encode(toMap());

  factory SocietyAddressModel.fromJson(String source) =>
      SocietyAddressModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'SocietyAddressModel(addressLine1: $addressLine1, addressLine2: $addressLine2, city: $city, state: $state, zipCode: $zipCode)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is SocietyAddressModel &&
        other.addressLine1 == addressLine1 &&
        other.addressLine2 == addressLine2 &&
        other.city == city &&
        other.state == state &&
        other.zipCode == zipCode;
  }

  @override
  int get hashCode {
    return addressLine1.hashCode ^
        addressLine2.hashCode ^
        city.hashCode ^
        state.hashCode ^
        zipCode.hashCode;
  }
}
