import 'dart:convert';

class CircularImageModel {
  int? id;
  String? imageUrl;
  int? circular;
  CircularImageModel({
    this.id,
    this.imageUrl,
    this.circular,
  });

  CircularImageModel copyWith({
    int? id,
    String? imageUrl,
    int? circular,
  }) {
    return CircularImageModel(
      id: id ?? this.id,
      imageUrl: imageUrl ?? this.imageUrl,
      circular: circular ?? this.circular,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'imageUrl': imageUrl,
      'circular': circular,
    };
  }

  factory CircularImageModel.fromMap(Map<String, dynamic> map) {
    return CircularImageModel(
      id: map['id']?.toInt(),
      imageUrl: map['imageUrl'],
      circular: map['circular']?.toInt(),
    );
  }

  String toJson() => json.encode(toMap());

  factory CircularImageModel.fromJson(String source) => CircularImageModel.fromMap(json.decode(source));

  @override
  String toString() => 'CircularImageModel(id: $id, imageUrl: $imageUrl, circular: $circular)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is CircularImageModel &&
      other.id == id &&
      other.imageUrl == imageUrl &&
      other.circular == circular;
  }

  @override
  int get hashCode => id.hashCode ^ imageUrl.hashCode ^ circular.hashCode;
}
