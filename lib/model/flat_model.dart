import 'dart:convert';

class FlatModel {
  int? floor;
  String? wing;
  String? tower;
  String? buitlUpArea;
  String? carpetArea;
  String? flatNo;
  FlatModel({
    this.floor,
    this.wing,
    this.tower,
    this.buitlUpArea,
    this.carpetArea,
    this.flatNo,
  });

  FlatModel copyWith({
    int? floor,
    String? wing,
    String? tower,
    String? buitlUpArea,
    String? carpetArea,
    String? flatNo,
  }) {
    return FlatModel(
      floor: floor ?? this.floor,
      wing: wing ?? this.wing,
      tower: tower ?? this.tower,
      buitlUpArea: buitlUpArea ?? this.buitlUpArea,
      carpetArea: carpetArea ?? this.carpetArea,
      flatNo: flatNo ?? this.flatNo,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'floor': floor,
      'wing': wing,
      'tower': tower,
      'buitlUpArea': buitlUpArea,
      'carpetArea': carpetArea,
      'flatNo': flatNo,
    };
  }

  factory FlatModel.fromMap(Map<String, dynamic> map) {
    return FlatModel(
      floor: map['floor']?.toInt(),
      wing: map['wing'],
      tower: map['tower'],
      buitlUpArea: map['buitlUpArea'],
      carpetArea: map['carpetArea'],
      flatNo: map['flatNo'],
    );
  }

  String toJson() => json.encode(toMap());

  factory FlatModel.fromJson(String source) => FlatModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'FlatModel(floor: $floor, wing: $wing, tower: $tower, buitlUpArea: $buitlUpArea, carpetArea: $carpetArea, flatNo: $flatNo)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is FlatModel &&
      other.floor == floor &&
      other.wing == wing &&
      other.tower == tower &&
      other.buitlUpArea == buitlUpArea &&
      other.carpetArea == carpetArea &&
      other.flatNo == flatNo;
  }

  @override
  int get hashCode {
    return floor.hashCode ^
      wing.hashCode ^
      tower.hashCode ^
      buitlUpArea.hashCode ^
      carpetArea.hashCode ^
      flatNo.hashCode;
  }
}
