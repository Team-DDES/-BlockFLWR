import 'package:json_annotation/json_annotation.dart';

part 'user_register.g.dart';

@JsonSerializable()
class UserRegister {
  final RegisterData data;
  final RegisterResult result;

  UserRegister({
    required this.data,
    required this.result,
  });

  factory UserRegister.fromJson(Map<String, dynamic> json) => _$UserRegisterFromJson(json);
  Map<String, dynamic> toJson() => _$UserRegisterToJson(this);
}

@JsonSerializable()
class RegisterData {
  final int fieldCount;
  final int affectedRows;
  final int insertId;
  final int serverStatus;
  final int warningCount;
  final String message;
  final bool protocol41;
  final int changedRows;

  RegisterData({
    required this.fieldCount,
    required this.affectedRows,
    required this.insertId,
    required this.serverStatus,
    required this.warningCount,
    required this.message,
    required this.protocol41,
    required this.changedRows,
  });

  factory RegisterData.fromJson(Map<String, dynamic> json) => _$RegisterDataFromJson(json);
  Map<String, dynamic> toJson() => _$RegisterDataToJson(this);
}

@JsonSerializable()
class RegisterResult {
  final String message;
  final int code;

  RegisterResult({
    required this.message,
    required this.code,
  });

  factory RegisterResult.fromJson(Map<String, dynamic> json) => _$RegisterResultFromJson(json);
  Map<String, dynamic> toJson() => _$RegisterResultToJson(this);
}

RegisterData blankRegisterData = RegisterData(
  fieldCount: 0,
  affectedRows: 0,
  insertId: 0,
  serverStatus: 0,
  warningCount: 0,
  message: '',
  protocol41: false,
  changedRows: 0,
);

UserRegister duplicateRegisterData = UserRegister(
    data: blankRegisterData,
    result: RegisterResult(message: "user insert fail", code: 404)
);