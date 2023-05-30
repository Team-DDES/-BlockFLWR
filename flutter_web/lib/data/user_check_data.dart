import 'package:json_annotation/json_annotation.dart';

part 'user_check_data.g.dart';

@JsonSerializable()
class UserRegisterData {
  final String userType;
  final String userName;
  final String userAddress;
  final String userEmail;
  final String userPhone;

  UserRegisterData(
      {
        required this.userType,
        required this.userName,
        required this.userAddress,
        required this.userEmail,
        required this.userPhone,
      });

  factory UserRegisterData.fromJson(Map<String, dynamic> json) => _$UserRegisterDataFromJson(json);
  Map<String, dynamic> toJson() => _$UserRegisterDataToJson(this);
}