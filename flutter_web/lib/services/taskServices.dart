import 'dart:convert';

import 'package:flutter_web/data/bcfl.dart';
import 'package:flutter_web/data/user_register.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_web/utils/http_utils.dart';

class TaskApi {
  final http.Client _httpClient = http.Client();
  final String baseUrl;

  TaskApi({this.baseUrl = BASE_URL});


  Future<List<BCFL>> getTaskList(Map<String, dynamic> data) async{
    final url = Uri.parse('$baseUrl/task/');
    final response = await _httpClient.get(
      url.replace(queryParameters: data),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> responseData = jsonDecode(response.body);
      BCFLResponse bcflResponse = BCFLResponse.fromJson(responseData);
      if(BCFLResult.fromJson(responseData['result']).code == SUCCESS){
        return bcflResponse.data;
      }else {
        return [];
      }
    } else {
      throw Exception('Failed to register user');
    }
  }

  Future<UserRegister> postParticipateTask(Map<String, dynamic> data) async{
    final url = Uri.parse('$baseUrl/task/participate/');
    final response = await _httpClient.post(
      url,
      body: jsonEncode(data),
      headers: {'Content-Type': 'application/json'},
    );
    if (response.statusCode == 200) {
      Map<String, dynamic> responseData = jsonDecode(response.body);
      return UserRegister.fromJson(responseData);
    } else {
      throw Exception('Failed to register user');
    }
  }

  Future<UserRegister> postRegisterTask(Map<String, dynamic> data) async{
    final url = Uri.parse('$baseUrl/task');
    final response = await _httpClient.post(
      url,
      body: jsonEncode(data),
      headers: {'Content-Type': 'application/json'},
    );
    if (response.statusCode == 200) {
      Map<String, dynamic> responseData = jsonDecode(response.body);
      return UserRegister.fromJson(responseData);
    } else {
      throw Exception('Failed to register user');
    }
  }

}