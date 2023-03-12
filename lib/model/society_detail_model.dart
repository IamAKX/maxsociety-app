import 'dart:convert';

class SocietyDetailModel {
  String? societyName;
  String? reraRegNo;
  String? societyRegNo;
  String? wardNo;
  String? imagePath;
  SocietyDetailModel({
    this.societyName,
    this.reraRegNo,
    this.societyRegNo,
    this.wardNo,
    this.imagePath,
  });

  SocietyDetailModel copyWith({
    String? societyName,
    String? reraRegNo,
    String? societyRegNo,
    String? wardNo,
    String? imagePath,
  }) {
    return SocietyDetailModel(
      societyName: societyName ?? this.societyName,
      reraRegNo: reraRegNo ?? this.reraRegNo,
      societyRegNo: societyRegNo ?? this.societyRegNo,
      wardNo: wardNo ?? this.wardNo,
      imagePath: imagePath ?? this.imagePath,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'societyName': societyName,
      'reraRegNo': reraRegNo,
      'societyRegNo': societyRegNo,
      'wardNo': wardNo,
      'imagePath': imagePath,
    };
  }

  factory SocietyDetailModel.fromMap(Map<String, dynamic> map) {
    return SocietyDetailModel(
      societyName: map['societyName'],
      reraRegNo: map['reraRegNo'],
      societyRegNo: map['societyRegNo'],
      wardNo: map['wardNo'],
      imagePath: map['imagePath'],
    );
  }

  String toJson() => json.encode(toMap());

  factory SocietyDetailModel.fromJson(String source) => SocietyDetailModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'SocietyDetailModel(societyName: $societyName, reraRegNo: $reraRegNo, societyRegNo: $societyRegNo, wardNo: $wardNo, imagePath: $imagePath)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is SocietyDetailModel &&
      other.societyName == societyName &&
      other.reraRegNo == reraRegNo &&
      other.societyRegNo == societyRegNo &&
      other.wardNo == wardNo &&
      other.imagePath == imagePath;
  }

  @override
  int get hashCode {
    return societyName.hashCode ^
      reraRegNo.hashCode ^
      societyRegNo.hashCode ^
      wardNo.hashCode ^
      imagePath.hashCode;
  }
  }
