//TODO BCFL 관련 서버 response interface
import 'package:json_annotation/json_annotation.dart';

part 'bcfl.g.dart';

@JsonSerializable()
class BCFLResponse {
  final List<BCFL> data;
  final BCFLResult result;

  BCFLResponse({
    required this.data,
    required this.result
  });

  factory BCFLResponse.fromJson(Map<String, dynamic> json) => _$BCFLResponseFromJson(json);
  Map<String, dynamic> toJson() => _$BCFLResponseToJson(this);
}

@JsonSerializable()
class BCFL {
  final String taskName;
  final String userName;
  final String taskMaxTrainer;
  String taskParticipants = "0";
  final String taskFramework;
  final String taskDataType;
  final String taskPurpose;
  final String taskContractAddress;
  final String userEmail;
  final String userPhone;
  final int taskId;
  final int taskStatusCode;
  final int organizationUserId;
  final int row_num;
  BCFL({
    required this.taskName,
    required this.userName,
    required this.taskMaxTrainer,
    required this.taskParticipants,
    required this.taskFramework,
    required this.taskDataType,
    required this.taskPurpose,
    required this.taskContractAddress,
    required this.userEmail,
    required this.userPhone,
    required this.taskId,
    required this.taskStatusCode,
    required this.organizationUserId,
    required this.row_num,
  });

  bool containKeyword(String keyword) {
    return taskName.contains(keyword) ||
        userName.contains(keyword);
  }

  factory BCFL.fromJson(Map<String, dynamic> json) => _$BCFLFromJson(json);
  Map<String, dynamic> toJson() => _$BCFLToJson(this);
}

@JsonSerializable()
class BCFLResult{
  final String message;
  final String code;

  BCFLResult({
    required this.message,
    required this.code,
  });

  factory BCFLResult.fromJson(Map<String, dynamic> json) => _$BCFLResultFromJson(json);
  Map<String, dynamic> toJson() => _$BCFLResultToJson(this);
}