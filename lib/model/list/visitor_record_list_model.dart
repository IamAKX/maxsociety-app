import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'package:maxsociety/model/visitors_record_model.dart';

class VisitorRecordListModel {
  List<VisiorsRecordModel>? gateKeepRequests;
  VisitorRecordListModel({
    this.gateKeepRequests,
  });

  VisitorRecordListModel copyWith({
    List<VisiorsRecordModel>? gateKeepRequests,
  }) {
    return VisitorRecordListModel(
      gateKeepRequests: gateKeepRequests ?? this.gateKeepRequests,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'gateKeepRequests': gateKeepRequests?.map((x) => x?.toMap())?.toList(),
    };
  }

  factory VisitorRecordListModel.fromMap(Map<String, dynamic> map) {
    return VisitorRecordListModel(
      gateKeepRequests: map['gateKeepRequests'] != null
          ? List<VisiorsRecordModel>.from(map['gateKeepRequests']
              ?.map((x) => VisiorsRecordModel.fromMap(x)))
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory VisitorRecordListModel.fromJson(String source) =>
      VisitorRecordListModel.fromMap(json.decode(source));

  @override
  String toString() =>
      'VisitorRecordListModel(gateKeepRequests: $gateKeepRequests)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is VisitorRecordListModel &&
        listEquals(other.gateKeepRequests, gateKeepRequests);
  }

  @override
  int get hashCode => gateKeepRequests.hashCode;
}
