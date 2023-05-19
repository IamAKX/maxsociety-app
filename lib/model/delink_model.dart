import 'dart:convert';

import 'package:maxsociety/model/user_profile_model.dart';

class DelinkModel {
  int? id;
  UserProfile? user;
  String? status;
  String? createdOn;
  String? updatedOn;
  String? createdBy;
  String? updatedBy;
  DelinkModel({
    this.id,
    this.user,
    this.status,
    this.createdOn,
    this.updatedOn,
    this.createdBy,
    this.updatedBy,
  });

  DelinkModel copyWith({
    int? id,
    UserProfile? user,
    String? status,
    String? createdOn,
    String? updatedOn,
    String? createdBy,
    String? updatedBy,
  }) {
    return DelinkModel(
      id: id ?? this.id,
      user: user ?? this.user,
      status: status ?? this.status,
      createdOn: createdOn ?? this.createdOn,
      updatedOn: updatedOn ?? this.updatedOn,
      createdBy: createdBy ?? this.createdBy,
      updatedBy: updatedBy ?? this.updatedBy,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'user': user?.toMap(),
      'status': status,
      'createdOn': createdOn,
      'updatedOn': updatedOn,
      'createdBy': createdBy,
      'updatedBy': updatedBy,
    };
  }

  factory DelinkModel.fromMap(Map<String, dynamic> map) {
    return DelinkModel(
      id: map['id']?.toInt(),
      user: map['user'] != null ? UserProfile.fromMap(map['user']) : null,
      status: map['status'],
      createdOn: map['createdOn'],
      updatedOn: map['updatedOn'],
      createdBy: map['createdBy'],
      updatedBy: map['updatedBy'],
    );
  }

  String toJson() => json.encode(toMap());

  factory DelinkModel.fromJson(String source) => DelinkModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'DelinkModel(id: $id, user: $user, status: $status, createdOn: $createdOn, updatedOn: $updatedOn, createdBy: $createdBy, updatedBy: $updatedBy)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is DelinkModel &&
      other.id == id &&
      other.user == user &&
      other.status == status &&
      other.createdOn == createdOn &&
      other.updatedOn == updatedOn &&
      other.createdBy == createdBy &&
      other.updatedBy == updatedBy;
  }

  @override
  int get hashCode {
    return id.hashCode ^
      user.hashCode ^
      status.hashCode ^
      createdOn.hashCode ^
      updatedOn.hashCode ^
      createdBy.hashCode ^
      updatedBy.hashCode;
  }
}
