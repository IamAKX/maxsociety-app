import 'dart:convert';

class AppMetadataModel {
  String? contactNo;
  String? playStoreLink;
  String? policyLink;
  String? termLink;
  AppMetadataModel({
    this.contactNo,
    this.playStoreLink,
    this.policyLink,
    this.termLink,
  });

  AppMetadataModel copyWith({
    String? contactNo,
    String? playStoreLink,
    String? policyLink,
    String? termLink,
  }) {
    return AppMetadataModel(
      contactNo: contactNo ?? this.contactNo,
      playStoreLink: playStoreLink ?? this.playStoreLink,
      policyLink: policyLink ?? this.policyLink,
      termLink: termLink ?? this.termLink,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'contactNo': contactNo,
      'playStoreLink': playStoreLink,
      'policyLink': policyLink,
      'termLink': termLink,
    };
  }

  factory AppMetadataModel.fromMap(Map<String, dynamic> map) {
    return AppMetadataModel(
      contactNo: map['contactNo'],
      playStoreLink: map['playStoreLink'],
      policyLink: map['policyLink'],
      termLink: map['termLink'],
    );
  }

  String toJson() => json.encode(toMap());

  factory AppMetadataModel.fromJson(String source) =>
      AppMetadataModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'AppMetadataModel(contactNo: $contactNo, playStoreLink: $playStoreLink, policyLink: $policyLink, termLink: $termLink)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is AppMetadataModel &&
        other.contactNo == contactNo &&
        other.playStoreLink == playStoreLink &&
        other.policyLink == policyLink &&
        other.termLink == termLink;
  }

  @override
  int get hashCode {
    return contactNo.hashCode ^
        playStoreLink.hashCode ^
        policyLink.hashCode ^
        termLink.hashCode;
  }
}
