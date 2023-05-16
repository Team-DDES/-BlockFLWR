import 'package:json_annotation/json_annotation.dart';

part 'user.g.dart';

@JsonSerializable()
class User {

  var userName = "@ID";
  var userType = "part";
  var isConnect = true;

  User(
      {required this.userName,
      required this.userType,
      required this.isConnect});

  factory User.fromJson(Map<String, dynamic> json) => _$UserToJson(json);
  Map<String, dynamic> toJson() => _$UserToJson(this);

}

String typeParticipant = "part";
String typeOrganization = "org";

User dummyUser = User(
  userName: "@ID",
  userType: "part",
  isConnect: true,
);

User dummyOrgUser = User(
  userName: "@ID",
  userType: "org",
  isConnect: true,
);
