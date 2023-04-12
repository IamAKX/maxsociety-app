import 'dart:convert';

class VisiorsRecordModel {
  int? id;
  String? guardId;
  String? flatNo;
  String? visitorName;
  String? visitPurpose;
  String? gkReqInitTime;
  String? guardName;
  String? status;
  String? gkReqActionTime;
  String? title;
  String? body;
  String? path;
  VisiorsRecordModel({
    this.id,
    this.guardId,
    this.flatNo,
    this.visitorName,
    this.visitPurpose,
    this.gkReqInitTime,
    this.guardName,
    this.status,
    this.gkReqActionTime,
    this.title,
    this.body,
    this.path,
  });

  VisiorsRecordModel copyWith({
    int? id,
    String? guardId,
    String? flatNo,
    String? visitorName,
    String? visitPurpose,
    String? gkReqInitTime,
    String? guardName,
    String? status,
    String? gkReqActionTime,
    String? title,
    String? body,
    String? path,
  }) {
    return VisiorsRecordModel(
      id: id ?? this.id,
      guardId: guardId ?? this.guardId,
      flatNo: flatNo ?? this.flatNo,
      visitorName: visitorName ?? this.visitorName,
      visitPurpose: visitPurpose ?? this.visitPurpose,
      gkReqInitTime: gkReqInitTime ?? this.gkReqInitTime,
      guardName: guardName ?? this.guardName,
      status: status ?? this.status,
      gkReqActionTime: gkReqActionTime ?? this.gkReqActionTime,
      title: title ?? this.title,
      body: body ?? this.body,
      path: path ?? this.path,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'guardId': guardId,
      'flatNo': flatNo,
      'visitorName': visitorName,
      'visitPurpose': visitPurpose,
      'gkReqInitTime': gkReqInitTime,
      'guardName': guardName,
      'status': status,
      'gkReqActionTime': gkReqActionTime,
      'title': title,
      'body': body,
      'path': path,
    };
  }

  factory VisiorsRecordModel.fromMap(Map<String, dynamic> map) {
    return VisiorsRecordModel(
      id: map['id']?.toInt(),
      guardId: map['guardId'],
      flatNo: map['flatNo'],
      visitorName: map['visitorName'],
      visitPurpose: map['visitPurpose'],
      gkReqInitTime: map['gkReqInitTime'],
      guardName: map['guardName'],
      status: map['status'],
      gkReqActionTime: map['gkReqActionTime'],
      title: map['title'],
      body: map['body'],
      path: map['path'],
    );
  }

  String toJson() => json.encode(toMap());

  factory VisiorsRecordModel.fromJson(String source) =>
      VisiorsRecordModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'VisiorsRecordModel(id: $id, guardId: $guardId, flatNo: $flatNo, visitorName: $visitorName, visitPurpose: $visitPurpose, gkReqInitTime: $gkReqInitTime, guardName: $guardName, status: $status, gkReqActionTime: $gkReqActionTime, title: $title, body: $body, path: $path)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is VisiorsRecordModel &&
        other.id == id &&
        other.guardId == guardId &&
        other.flatNo == flatNo &&
        other.visitorName == visitorName &&
        other.visitPurpose == visitPurpose &&
        other.gkReqInitTime == gkReqInitTime &&
        other.guardName == guardName &&
        other.status == status &&
        other.gkReqActionTime == gkReqActionTime &&
        other.title == title &&
        other.body == body &&
        other.path == path;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        guardId.hashCode ^
        flatNo.hashCode ^
        visitorName.hashCode ^
        visitPurpose.hashCode ^
        gkReqInitTime.hashCode ^
        guardName.hashCode ^
        status.hashCode ^
        gkReqActionTime.hashCode ^
        title.hashCode ^
        body.hashCode ^
        path.hashCode;
  }
}
