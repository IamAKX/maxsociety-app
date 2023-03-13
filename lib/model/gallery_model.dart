import 'dart:convert';

class GalleryModel {
  int? galleryItemId;
  String? galleryItemName;
  String? createdOn;
  String? updatedOn;
  String? galleryItemType;
  String? galleryItemPath;
  int? society;
  GalleryModel({
    this.galleryItemId,
    this.galleryItemName,
    this.createdOn,
    this.updatedOn,
    this.galleryItemType,
    this.galleryItemPath,
    this.society,
  });

  GalleryModel copyWith({
    int? galleryItemId,
    String? galleryItemName,
    String? createdOn,
    String? updatedOn,
    String? galleryItemType,
    String? galleryItemPath,
    int? society,
  }) {
    return GalleryModel(
      galleryItemId: galleryItemId ?? this.galleryItemId,
      galleryItemName: galleryItemName ?? this.galleryItemName,
      createdOn: createdOn ?? this.createdOn,
      updatedOn: updatedOn ?? this.updatedOn,
      galleryItemType: galleryItemType ?? this.galleryItemType,
      galleryItemPath: galleryItemPath ?? this.galleryItemPath,
      society: society ?? this.society,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'galleryItemId': galleryItemId,
      'galleryItemName': galleryItemName,
      'createdOn': createdOn,
      'updatedOn': updatedOn,
      'galleryItemType': galleryItemType,
      'galleryItemPath': galleryItemPath,
      'society': society,
    };
  }

  factory GalleryModel.fromMap(Map<String, dynamic> map) {
    return GalleryModel(
      galleryItemId: map['galleryItemId']?.toInt(),
      galleryItemName: map['galleryItemName'],
      createdOn: map['createdOn'],
      updatedOn: map['updatedOn'],
      galleryItemType: map['galleryItemType'],
      galleryItemPath: map['galleryItemPath'],
      society: map['society']?.toInt(),
    );
  }

  String toJson() => json.encode(toMap());

  factory GalleryModel.fromJson(String source) => GalleryModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'GalleryModel(galleryItemId: $galleryItemId, galleryItemName: $galleryItemName, createdOn: $createdOn, updatedOn: $updatedOn, galleryItemType: $galleryItemType, galleryItemPath: $galleryItemPath, society: $society)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is GalleryModel &&
      other.galleryItemId == galleryItemId &&
      other.galleryItemName == galleryItemName &&
      other.createdOn == createdOn &&
      other.updatedOn == updatedOn &&
      other.galleryItemType == galleryItemType &&
      other.galleryItemPath == galleryItemPath &&
      other.society == society;
  }

  @override
  int get hashCode {
    return galleryItemId.hashCode ^
      galleryItemName.hashCode ^
      createdOn.hashCode ^
      updatedOn.hashCode ^
      galleryItemType.hashCode ^
      galleryItemPath.hashCode ^
      society.hashCode;
  }
}
