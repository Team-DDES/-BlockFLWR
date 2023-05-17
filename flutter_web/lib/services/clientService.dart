import 'package:flutter_web/data/user.dart';
import 'package:flutter_web/data/user_register.dart';
import 'package:retrofit/retrofit.dart';
import 'package:dio/dio.dart';

part 'clientService.g.dart';
// UserApi에서 에러나면 터미널에 다음 명령 하나 쳐주세요
// flutter packages pub run build_runner build

@RestApi(baseUrl: "tvstorm-ai.asuscomm.com:12300/flower/")
abstract class UserApi {
  factory UserApi(Dio dio, {String baseUrl}) = _UserApi;

  @POST("user/join/")
  Future<UserRegister> registerUser(@Body() Map<String, dynamic> data);
  @GET("user/")
  Future<UserResponse> isUser(@Body() Map<String, dynamic> data);
}
