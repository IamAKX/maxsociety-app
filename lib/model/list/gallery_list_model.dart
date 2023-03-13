import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'package:maxsociety/model/gallery_model.dart';

class GalleryListModel {
  List<GalleryModel>? data;
  GalleryListModel({
    this.data,
  });

  GalleryListModel copyWith({
    List<GalleryModel>? data,
  }) {
    return GalleryListModel(
      data: data ?? this.data,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'data': data?.map((x) => x?.toMap())?.toList(),
    };
  }

  factory GalleryListModel.fromMap(Map<String, dynamic> map) {
    return GalleryListModel(
      data: map['data'] != null
          ? List<GalleryModel>.from(
              map['data']?.map((x) => GalleryModel.fromMap(x)))
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory GalleryListModel.fromJson(String source) =>
      GalleryListModel.fromMap(json.decode(source));

  @override
  String toString() => 'GalleryListModel(data: $data)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is GalleryListModel && listEquals(other.data, data);
  }

  @override
  int get hashCode => data.hashCode;
}
