import 'dart:convert';

import 'package:flutter/material.dart';

class SocietyMenuModel {
  String? title;
  IconData? icon;
  String? navigatorRoute;
  SocietyMenuModel({
    this.title,
    this.icon,
    this.navigatorRoute,
  });

  SocietyMenuModel copyWith({
    String? title,
    IconData? icon,
    String? navigatorRoute,
  }) {
    return SocietyMenuModel(
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

  factory SocietyMenuModel.fromMap(Map<String, dynamic> map) {
    return SocietyMenuModel(
      title: map['title'],
      icon: map['icon'] != null ? IconData(map['icon'], fontFamily: 'MaterialIcons') : null,
      navigatorRoute: map['navigatorRoute'],
    );
  }

  String toJson() => json.encode(toMap());

  factory SocietyMenuModel.fromJson(String source) => SocietyMenuModel.fromMap(json.decode(source));

  @override
  String toString() => 'SocietyMenuModel(title: $title, icon: $icon, navigatorRoute: $navigatorRoute)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is SocietyMenuModel &&
      other.title == title &&
      other.icon == icon &&
      other.navigatorRoute == navigatorRoute;
  }

  @override
  int get hashCode => title.hashCode ^ icon.hashCode ^ navigatorRoute.hashCode;
}
