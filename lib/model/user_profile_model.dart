import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'package:maxsociety/model/flat_model.dart';
import 'package:maxsociety/model/user_role.dart';

class UserProfile {
  String? userId;
  String? userName;
  String? relationship;
  String? mobileNo;
  String? gender;
  String? dob;
  String? email;
  String? imagePath;
  FlatModel? flats;
  List<UserRole>? roles;
  String? designation;
  String? category;
  UserProfile({
    this.userId,
    this.userName,
    this.relationship,
    this.mobileNo,
    this.gender,
    this.dob,
    this.email,
    this.imagePath,
    this.flats,
    this.roles,
    this.designation,
    this.category,
  });

  UserProfile copyWith({
    String? userId,
    String? userName,
    String? relationship,
    String? mobileNo,
    String? gender,
    String? dob,
    String? email,
    String? imagePath,
    FlatModel? flats,
    List<UserRole>? roles,
    String? designation,
    String? category,
  }) {
    return UserProfile(
      userId: userId ?? this.userId,
      userName: userName ?? this.userName,
      relationship: relationship ?? this.relationship,
      mobileNo: mobileNo ?? this.mobileNo,
      gender: gender ?? this.gender,
      dob: dob ?? this.dob,
      email: email ?? this.email,
      imagePath: imagePath ?? this.imagePath,
      flats: flats ?? this.flats,
      roles: roles ?? this.roles,
      designation: designation ?? this.designation,
      category: category ?? this.category,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'userName': userName,
      'relationship': relationship,
      'mobileNo': mobileNo,
      'gender': gender,
      'dob': dob,
      'email': email,
      'imagePath': imagePath,
      'flats': flats?.toMap(),
      'roles': roles?.map((x) => x?.toMap())?.toList(),
      'designation': designation,
      'category': category,
    };
  }

  factory UserProfile.fromMap(Map<String, dynamic> map) {
    return UserProfile(
      userId: map['userId'],
      userName: map['userName'],
      relationship: map['relationship'],
      mobileNo: map['mobileNo'],
      gender: map['gender'],
      dob: map['dob'],
      email: map['email'],
      imagePath: map['imagePath'],
      flats: map['flats'] != null ? FlatModel.fromMap(map['flats']) : null,
      roles: map['roles'] != null
          ? List<UserRole>.from(map['roles']?.map((x) => UserRole.fromMap(x)))
          : null,
      designation: map['designation'],
      category: map['category'],
    );
  }

  String toJson() => json.encode(toMap());

  factory UserProfile.fromJson(String source) =>
      UserProfile.fromMap(json.decode(source));

  @override
  String toString() {
    return 'UserProfile(userId: $userId, userName: $userName, relationship: $relationship, mobileNo: $mobileNo, gender: $gender, dob: $dob, email: $email, imagePath: $imagePath, flats: $flats, roles: $roles, designation: $designation, category: $category)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is UserProfile &&
        other.userId == userId &&
        other.userName == userName &&
        other.relationship == relationship &&
        other.mobileNo == mobileNo &&
        other.gender == gender &&
        other.dob == dob &&
        other.email == email &&
        other.imagePath == imagePath &&
        other.flats == flats &&
        listEquals(other.roles, roles) &&
        other.designation == designation &&
        other.category == category;
  }

  @override
  int get hashCode {
    return userId.hashCode ^
        userName.hashCode ^
        relationship.hashCode ^
        mobileNo.hashCode ^
        gender.hashCode ^
        dob.hashCode ^
        email.hashCode ^
        imagePath.hashCode ^
        flats.hashCode ^
        roles.hashCode ^
        designation.hashCode ^
        category.hashCode;
  }
}
