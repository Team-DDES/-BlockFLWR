import 'package:json_annotation/json_annotation.dart';

part 'market.g.dart';

//TODO : DB이름형식이 기존 룰과 다름 ㅋㅋㅋ ㅜㅜ
@JsonSerializable()
class Market{
  final String model_uri;
  final String owner;
  final String owner_address;
  final String description;
  final String task_name;
  final String task_contract_address;
  final String task_framework;
  final String task_data_type;
  final int task_max_trainer;

  Market({
    required this.model_uri,
    required this.owner,
    required this.owner_address,
    required this.description,
    required this.task_name,
    required this.task_contract_address,
    required this.task_framework,
    required this.task_data_type,
    required this.task_max_trainer,
  });

  bool containKeyword(String keyword) {
    return task_name.contains(keyword) ||
        owner.contains(keyword) ||
        description.contains(keyword) ||
        task_data_type.contains(keyword) ||
        task_framework.contains(keyword);
  }

  factory Market.fromJson(Map<String, dynamic> json) => _$MarketFromJson(json);
  Map<String, dynamic> toJson() => _$MarketToJson(this);
}