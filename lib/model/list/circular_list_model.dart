import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'package:maxsociety/model/circular_model.dart';

class CircularListModel {
  List<CircularModel>? data;
  CircularListModel({
    this.data,
  });

  CircularListModel copyWith({
    List<CircularModel>? data,
  }) {
    return CircularListModel(
      data: data ?? this.data,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'data': data?.map((x) => x.toMap()).toList(),
    };
  }

  factory CircularListModel.fromMap(Map<String, dynamic> map) {
    return CircularListModel(
      data: map['data'] != null
          ? List<CircularModel>.from(
              map['data']?.map((x) => CircularModel.fromMap(x)))
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory CircularListModel.fromJson(String source) =>
      CircularListModel.fromMap(json.decode(source));

  @override
  String toString() => 'CircularListModel(data: $data)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is CircularListModel && listEquals(other.data, data);
  }

  @override
  int get hashCode => data.hashCode;
}
