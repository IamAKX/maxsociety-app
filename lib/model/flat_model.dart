import 'dart:convert';

class FlatModel {
  String? id;
  int? floor;
  String? wing;
  String? tower;
  String? buitlUpArea;
  String? carpetArea;
  String? flatNo;
  FlatModel({
    this.id,
    this.floor,
    this.wing,
    this.tower,
    this.buitlUpArea,
    this.carpetArea,
    this.flatNo,
  });

  FlatModel copyWith({
    String? id,
    int? floor,
    String? wing,
    String? tower,
    String? buitlUpArea,
    String? carpetArea,
    String? flatNo,
  }) {
    return FlatModel(
      id: id ?? this.id,
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
      'id': id,
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
      id: map['id'],
      floor: map['floor']?.toInt(),
      wing: map['wing'],
      tower: map['tower'],
      buitlUpArea: map['buitlUpArea'],
      carpetArea: map['carpetArea'],
      flatNo: map['flatNo'],
    );
  }

  String toJson() => json.encode(toMap());

  factory FlatModel.fromJson(String source) =>
      FlatModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'FLatModel(id: $id, floor: $floor, wing: $wing, tower: $tower, buitlUpArea: $buitlUpArea, carpetArea: $carpetArea, flatNo: $flatNo)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is FlatModel &&
        other.id == id &&
        other.floor == floor &&
        other.wing == wing &&
        other.tower == tower &&
        other.buitlUpArea == buitlUpArea &&
        other.carpetArea == carpetArea &&
        other.flatNo == flatNo;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        floor.hashCode ^
        wing.hashCode ^
        tower.hashCode ^
        buitlUpArea.hashCode ^
        carpetArea.hashCode ^
        flatNo.hashCode;
  }
}
