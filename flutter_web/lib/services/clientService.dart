import 'dart:async';
import 'dart:convert';

import 'package:flutter_web/data/user.dart';
import 'package:flutter_web/data/user_register.dart';
import 'package:get/get.dart';
import 'package:retrofit/retrofit.dart';
import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;
//part 'clientService.g.dart';
// UserApi에서 에러나면 터미널에 다음 명령 하나 쳐주세요
// flutter packages pub run build_runner build

// @RestApi(baseUrl: "tvstorm-ai.asuscomm.com:12300/flower/")
// abstract class UserApi {
//   factory UserApi(Dio dio, {String baseUrl}) = _UserApi;
//
//   @POST("user/join/")
//   Future<UserRegister> registerUser(@Body() Map<String, dynamic> data);
//   @GET("user/")
//   Future<UserResponse> isUser(@Body() Map<String, dynamic> data);
// }

class UserApi {
  final http.Client _httpClient = http.Client();
  final String baseUrl;

  UserApi({this.baseUrl = 'http://tvstorm-ai.asuscomm.com:12300/flower'});

  Future<UserRegister> registerUser(Map<String, dynamic> data) async {
    final url = Uri.parse('$baseUrl/user/join/');
    final response = await _httpClient.post(
      url,
      body: jsonEncode(data),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      return UserRegister.fromJson(responseData);
    } else {
      throw Exception('Failed to register user');
    }
  }

  Future<UserResponse> isUser(Map<String, dynamic> data) async {
    final url = Uri.parse('$baseUrl/user/');
    final response = await _httpClient.get(
      url.replace(queryParameters: data),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = jsonDecode(response.body);
      if(Result.fromJson(responseData['result']).code != 200){
        return UserResponse(
          data: User(userId: -1, userData: blankPostUser, createDate: ""),
          result: Result.fromJson(responseData['result'])
        );
      }else{
        return UserResponse.fromJson(responseData);
      }

    } else {
      throw Exception('Failed to check user');
    }
  }
}