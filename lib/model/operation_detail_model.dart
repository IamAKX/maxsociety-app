import 'dart:convert';

class OperationDetailModel {
  String? flatNo;
  bool? allowEdit;
  OperationDetailModel({
    this.flatNo,
    this.allowEdit,
  });

  OperationDetailModel copyWith({
    String? flatNo,
    bool? allowEdit,
  }) {
    return OperationDetailModel(
      flatNo: flatNo ?? this.flatNo,
      allowEdit: allowEdit ?? this.allowEdit,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'flatNo': flatNo,
      'allowEdit': allowEdit,
    };
  }

  factory OperationDetailModel.fromMap(Map<String, dynamic> map) {
    return OperationDetailModel(
      flatNo: map['flatNo'],
      allowEdit: map['allowEdit'],
    );
  }

  String toJson() => json.encode(toMap());

  factory OperationDetailModel.fromJson(String source) => OperationDetailModel.fromMap(json.decode(source));

  @override
  String toString() => 'OperationDetailModel(flatNo: $flatNo, allowEdit: $allowEdit)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is OperationDetailModel &&
      other.flatNo == flatNo &&
      other.allowEdit == allowEdit;
  }

  @override
  int get hashCode => flatNo.hashCode ^ allowEdit.hashCode;
}
