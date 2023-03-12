import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'package:maxsociety/model/circular_image_model.dart';
import 'package:maxsociety/model/user_profile_model.dart';

class CircularModel {
  int? circularId;
  String? circularNo;
  String? subject;
  String? circularText;
  String? fileType;
  UserProfile? createdBy;
  String? createdOn;
  UserProfile? updatedBy;
  String? updatedOn;
  String? circularType;
  String? circularStatus;
  String? circularCategory;
  int? society;
  List<CircularImageModel>? circularImages;
  String? eventDate;
  bool? showEventDate;
  CircularModel({
    this.circularId,
    this.circularNo,
    this.subject,
    this.circularText,
    this.fileType,
    this.createdBy,
    this.createdOn,
    this.updatedBy,
    this.updatedOn,
    this.circularType,
    this.circularStatus,
    this.circularCategory,
    this.society,
    this.circularImages,
    this.eventDate,
    this.showEventDate,
  });

  CircularModel copyWith({
    int? circularId,
    String? circularNo,
    String? subject,
    String? circularText,
    String? fileType,
    UserProfile? createdBy,
    String? createdOn,
    UserProfile? updatedBy,
    String? updatedOn,
    String? circularType,
    String? circularStatus,
    String? circularCategory,
    int? society,
    List<CircularImageModel>? circularImages,
    String? eventDate,
    bool? showEventDate,
  }) {
    return CircularModel(
      circularId: circularId ?? this.circularId,
      circularNo: circularNo ?? this.circularNo,
      subject: subject ?? this.subject,
      circularText: circularText ?? this.circularText,
      fileType: fileType ?? this.fileType,
      createdBy: createdBy ?? this.createdBy,
      createdOn: createdOn ?? this.createdOn,
      updatedBy: updatedBy ?? this.updatedBy,
      updatedOn: updatedOn ?? this.updatedOn,
      circularType: circularType ?? this.circularType,
      circularStatus: circularStatus ?? this.circularStatus,
      circularCategory: circularCategory ?? this.circularCategory,
      society: society ?? this.society,
      circularImages: circularImages ?? this.circularImages,
      eventDate: eventDate ?? this.eventDate,
      showEventDate: showEventDate ?? this.showEventDate,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'circularId': circularId,
      'circularNo': circularNo,
      'subject': subject,
      'circularText': circularText,
      'fileType': fileType,
      'createdBy': createdBy?.toMap(),
      'createdOn': createdOn,
      'updatedBy': updatedBy?.toMap(),
      'updatedOn': updatedOn,
      'circularType': circularType,
      'circularStatus': circularStatus,
      'circularCategory': circularCategory,
      'society': society,
      'circularImages': circularImages?.map((x) => x?.toMap())?.toList(),
      'eventDate': eventDate,
      'showEventDate': showEventDate,
    };
  }

  factory CircularModel.fromMap(Map<String, dynamic> map) {
    return CircularModel(
      circularId: map['circularId']?.toInt(),
      circularNo: map['circularNo'],
      subject: map['subject'],
      circularText: map['circularText'],
      fileType: map['fileType'],
      createdBy: map['createdBy'] != null
          ? UserProfile.fromMap(map['createdBy'])
          : null,
      createdOn: map['createdOn'],
      updatedBy: map['updatedBy'] != null
          ? UserProfile.fromMap(map['updatedBy'])
          : null,
      updatedOn: map['updatedOn'],
      circularType: map['circularType'],
      circularStatus: map['circularStatus'],
      circularCategory: map['circularCategory'],
      society: map['society']?.toInt(),
      circularImages: map['circularImages'] != null
          ? List<CircularImageModel>.from(
              map['circularImages']?.map((x) => CircularImageModel.fromMap(x)))
          : null,
      eventDate: map['eventDate'],
      showEventDate: map['showEventDate'],
    );
  }

  String toJson() => json.encode(toMap());

  factory CircularModel.fromJson(String source) =>
      CircularModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'CircularModel(circularId: $circularId, circularNo: $circularNo, subject: $subject, circularText: $circularText, fileType: $fileType, createdBy: $createdBy, createdOn: $createdOn, updatedBy: $updatedBy, updatedOn: $updatedOn, circularType: $circularType, circularStatus: $circularStatus, circularCategory: $circularCategory, society: $society, circularImages: $circularImages, eventDate: $eventDate, showEventDate: $showEventDate)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is CircularModel &&
        other.circularId == circularId &&
        other.circularNo == circularNo &&
        other.subject == subject &&
        other.circularText == circularText &&
        other.fileType == fileType &&
        other.createdBy == createdBy &&
        other.createdOn == createdOn &&
        other.updatedBy == updatedBy &&
        other.updatedOn == updatedOn &&
        other.circularType == circularType &&
        other.circularStatus == circularStatus &&
        other.circularCategory == circularCategory &&
        other.society == society &&
        listEquals(other.circularImages, circularImages) &&
        other.eventDate == eventDate &&
        other.showEventDate == showEventDate;
  }

  @override
  int get hashCode {
    return circularId.hashCode ^
        circularNo.hashCode ^
        subject.hashCode ^
        circularText.hashCode ^
        fileType.hashCode ^
        createdBy.hashCode ^
        createdOn.hashCode ^
        updatedBy.hashCode ^
        updatedOn.hashCode ^
        circularType.hashCode ^
        circularStatus.hashCode ^
        circularCategory.hashCode ^
        society.hashCode ^
        circularImages.hashCode ^
        eventDate.hashCode ^
        showEventDate.hashCode;
  }
}
