import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'package:maxsociety/model/flat_model.dart';

class FlatListModel {
  List<FlatModel>? data;
  FlatListModel({
    this.data,
  });

  FlatListModel copyWith({
    List<FlatModel>? data,
  }) {
    return FlatListModel(
      data: data ?? this.data,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'data': data?.map((x) => x?.toMap())?.toList(),
    };
  }

  factory FlatListModel.fromMap(Map<String, dynamic> map) {
    return FlatListModel(
      data: map['data'] != null ? List<FlatModel>.from(map['data']?.map((x) => FlatModel.fromMap(x))) : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory FlatListModel.fromJson(String source) => FlatListModel.fromMap(json.decode(source));

  @override
  String toString() => 'FlatListModel(data: $data)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is FlatListModel &&
      listEquals(other.data, data);
  }

  @override
  int get hashCode => data.hashCode;
}
