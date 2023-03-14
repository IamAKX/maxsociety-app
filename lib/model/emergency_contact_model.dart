import 'dart:convert';

import 'package:flutter/foundation.dart';

class EmergencyContactModel {
  int? id;
  String? category;
  List<String>? phoneNumbers;
  EmergencyContactModel({
    this.id,
    this.category,
    this.phoneNumbers,
  });

  EmergencyContactModel copyWith({
    int? id,
    String? category,
    List<String>? phoneNumbers,
  }) {
    return EmergencyContactModel(
      id: id ?? this.id,
      category: category ?? this.category,
      phoneNumbers: phoneNumbers ?? this.phoneNumbers,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'category': category,
      'phoneNumbers': phoneNumbers,
    };
  }

  factory EmergencyContactModel.fromMap(Map<String, dynamic> map) {
    return EmergencyContactModel(
      id: map['id']?.toInt(),
      category: map['category'],
      phoneNumbers: List<String>.from(map['phoneNumbers']),
    );
  }

  String toJson() => json.encode(toMap());

  factory EmergencyContactModel.fromJson(String source) =>
      EmergencyContactModel.fromMap(json.decode(source));

  @override
  String toString() =>
      'EmergencyContactModel(id: $id, category: $category, phoneNumbers: $phoneNumbers)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is EmergencyContactModel &&
        other.id == id &&
        other.category == category &&
        listEquals(other.phoneNumbers, phoneNumbers);
  }

  @override
  int get hashCode => id.hashCode ^ category.hashCode ^ phoneNumbers.hashCode;
}
