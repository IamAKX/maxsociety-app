import 'dart:convert';

import 'package:flutter/material.dart';

class ProfileMenuModel {
  String? title;
  IconData? icon;
  String? navigatorRoute;
  ProfileMenuModel({
    this.title,
    this.icon,
    this.navigatorRoute,
  });

  ProfileMenuModel copyWith({
    String? title,
    IconData? icon,
    String? navigatorRoute,
  }) {
    return ProfileMenuModel(
      title: title ?? this.title,
      icon: icon ?? this.icon,
      navigatorRoute: navigatorRoute ?? this.navigatorRoute,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'icon': icon?.codePoint,
      'navigatorRoute': navigatorRoute,
    };
  }

  factory ProfileMenuModel.fromMap(Map<String, dynamic> map) {
    return ProfileMenuModel(
      title: map['title'],
      icon: map['icon'] != null ? IconData(map['icon'], fontFamily: 'MaterialIcons') : null,
      navigatorRoute: map['navigatorRoute'],
    );
  }

  String toJson() => json.encode(toMap());

  factory ProfileMenuModel.fromJson(String source) => ProfileMenuModel.fromMap(json.decode(source));

  @override
  String toString() => 'SocietyMenuModel(title: $title, icon: $icon, navigatorRoute: $navigatorRoute)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is ProfileMenuModel &&
      other.title == title &&
      other.icon == icon &&
      other.navigatorRoute == navigatorRoute;
  }

  @override
  int get hashCode => title.hashCode ^ icon.hashCode ^ navigatorRoute.hashCode;
}
