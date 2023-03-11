import 'dart:convert';

class UserRole {
  String name;
  int id;
  UserRole({
    required this.name,
    required this.id,
  });

  UserRole copyWith({
    String? name,
    int? id,
  }) {
    return UserRole(
      name: name ?? this.name,
      id: id ?? this.id,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'id': id,
    };
  }

  factory UserRole.fromMap(Map<String, dynamic> map) {
    return UserRole(
      name: map['name'] ?? '',
      id: map['id']?.toInt() ?? 0,
    );
  }

  String toJson() => json.encode(toMap());

  factory UserRole.fromJson(String source) =>
      UserRole.fromMap(json.decode(source));

  @override
  String toString() => 'UserRole(name: $name, id: $id)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is UserRole && other.name == name && other.id == id;
  }

  @override
  int get hashCode => name.hashCode ^ id.hashCode;
}
