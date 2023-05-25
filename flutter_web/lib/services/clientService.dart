import 'dart:async';
import 'dart:convert';

import 'package:flutter_web/controllers/user_controller.dart';
import 'package:flutter_web/data/user.dart';
import 'package:flutter_web/data/user_register.dart';
import 'package:flutter_web/utils/http_utils.dart';
import 'package:http/http.dart' as http;

class UserService {
  final http.Client _httpClient = http.Client();
  final String baseUrl;

  UserService({this.baseUrl = BASE_URL});

  Future<UserRegister> registerUser(Map<String, dynamic> data) async {
    final url = Uri.parse('$baseUrl/user/join/');
    final response = await _httpClient.post(
      url,
      body: jsonEncode(data),
      headers: {'Content-Type': 'application/json'},
    );
    if (response.statusCode == 200) {
      Map<String, dynamic> responseData = jsonDecode(response.body);
      if(RegisterResult.fromJson(responseData['result']).code != SUCCESS){
        try{
          if(response.body.contains("Duplicate")){
            Map<String, dynamic> wrapAddress = {'userAddress': userController.address.value};
            await isUser(wrapAddress).then((value) {
              globalUser = value;
              return duplicateRegisterData;
            });
          }
        }catch(e){
          Map<String, dynamic> wrapAddress = {'userAddress': userController.address.value};
          await isUser(wrapAddress).then((value) {
            globalUser = value;
            return duplicateRegisterData;
          });
        }
        Map<String, dynamic> wrapAddress = {'userAddress': userController.address.value};
        await isUser(wrapAddress).then((value) {
          globalUser = value;
          return duplicateRegisterData;
        });
      }
      await isUser({'userAddress': userController.address.value}).then((value) {
        globalUser = value;
      });
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
      final responseData = jsonDecode(response.body);
      if(Result.fromJson(responseData['result']).code != SUCCESS){
        return UserResponse(
          data: User(userId: -1,
              createDate: "",
              userType: '',
              userName: '',
              userAddress: '',
              userEmail: '',
              userPhone: ''),
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