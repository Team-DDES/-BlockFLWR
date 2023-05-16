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

  User(
      { required this.userId,
        required this.userType,
        required this.userName,
        required this.userAddress,
        required this.userEmail,
        required this.userPhone,
        required this.createDate,
      });

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
  Map<String, dynamic> toJson() => _$UserToJson(this);
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
  final List<User> data;
  final Result result;

  UserResponse({
    required this.data,
    required this.result,
  });

  factory UserResponse.fromJson(Map<String, dynamic> json) => _$UserResponseFromJson(json);
  Map<String, dynamic> toJson() => _$UserResponseToJson(this);
}

User dummyUser = User(
  userId: 1,
  userType: "T",
  userName: "Dummy User 1",
  userAddress: "0x123123123",
  userEmail: "dummy1@example.com",
  userPhone: "01012345678",
  createDate: "2023-05-16T00:00:00.000Z",
);

User dummyOrgUser = User(
  userId: 2,
  userType: "E",
  userName: "Dummy User 2",
  userAddress: "0x456456456",
  userEmail: "dummy2@example.com",
  userPhone: "01087654321",
  createDate: "2023-05-16T00:00:00.000Z",
);

Result dummyResult = Result(
  message: "success",
  code: "200",
);

UserResponse dummyUser1 = UserResponse(
  data: [dummyUser],
  result: dummyResult,
);

UserResponse dummyUser2 = UserResponse(
  data: [dummyOrgUser],
  result: dummyResult,
);

String typeOrganization = "E";
String typeParticipant = "T";
