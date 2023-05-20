import 'package:flutter_web/utils/http_utils.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user.g.dart';

@JsonSerializable()
class User {
  final int userId;
  final String userType;
  final String userName;
  final String userAddress;
  final String userEmail;
  final String userPhone;
  final String createDate;

  User({
    required this.userId,
    required this.createDate,
    required this.userType,
    required this.userName,
    required this.userAddress,
    required this.userEmail,
    required this.userPhone,
  });

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
  Map<String, dynamic> toJson() => _$UserToJson(this);
}

@JsonSerializable()
class PostUserRegisterData {
  final String userType;
  final String userName;
  final String userAddress;
  final String userEmail;
  final String userPhone;

  PostUserRegisterData(
      {
        required this.userType,
        required this.userName,
        required this.userAddress,
        required this.userEmail,
        required this.userPhone,
      });

  factory PostUserRegisterData.fromJson(Map<String, dynamic> json) => _$PostUserRegisterDataFromJson(json);
  Map<String, dynamic> toJson() => _$PostUserRegisterDataToJson(this);
}

@JsonSerializable()
class Result {
  final String message;
  final String code;

  Result({
    required this.message,
    required this.code,
  });

  factory Result.fromJson(Map<String, dynamic> json) => _$ResultFromJson(json);
  Map<String, dynamic> toJson() => _$ResultToJson(this);
}

@JsonSerializable()
class UserResponse {
  final User data;
  final Result result;

  UserResponse({
    required this.data,
    required this.result,
  });

  factory UserResponse.fromJson(Map<String, dynamic> json) => _$UserResponseFromJson(json);
  Map<String, dynamic> toJson() => _$UserResponseToJson(this);
}

PostUserRegisterData dummyRegister = PostUserRegisterData(
  userType: "T",
  userName: "Dummy User 1",
  userAddress: "0x123123123",
  userEmail: "dummy1@example.com",
  userPhone: "01012345678",
);

PostUserRegisterData dummyOrgRegister = PostUserRegisterData(
  userType: "E",
  userName: "Dummy User 2",
  userAddress: "0x456456456",
  userEmail: "dummy2@example.com",
  userPhone: "01087654321",
);

Result dummyResult = Result(
  message: "success",
  code: SUCCESS,
);


PostUserRegisterData blankPostUser = PostUserRegisterData(
  userType: '',
  userName: '',
  userAddress: '',
  userEmail: '',
  userPhone: '',
);

String typeOrganization = "E";
String typeParticipant = "T";

late UserResponse globalUser;