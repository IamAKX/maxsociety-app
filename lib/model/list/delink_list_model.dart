import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'package:maxsociety/model/delink_model.dart';

class DelinkListModel {
  List<DelinkModel>? data;
  DelinkListModel({
    this.data,
  });

  DelinkListModel copyWith({
    List<DelinkModel>? data,
  }) {
    return DelinkListModel(
      data: data ?? this.data,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'data': data?.map((x) => x?.toMap())?.toList(),
    };
  }

  factory DelinkListModel.fromMap(Map<String, dynamic> map) {
    return DelinkListModel(
      data: map['data'] != null
          ? List<DelinkModel>.from(
              map['data']?.map((x) => DelinkModel.fromMap(x)))
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory DelinkListModel.fromJson(String source) =>
      DelinkListModel.fromMap(json.decode(source));

  @override
  String toString() => 'DelinkListModel(data: $data)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is DelinkListModel && listEquals(other.data, data);
  }

  @override
  int get hashCode => data.hashCode;
}
