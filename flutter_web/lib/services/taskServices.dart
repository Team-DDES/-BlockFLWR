import 'package:dio/dio.dart';
import 'package:flutter_web/data/bcfl.dart';
import 'package:retrofit/retrofit.dart';

part 'taskServices.g.dart';

@RestApi(baseUrl: "tvstorm-ai.asuscomm.com:12300/flower/")
abstract class TaskApi {
  factory TaskApi(Dio dio, {String baseUrl}) = _TaskApi;

  @GET("task/list/")
  Future<List<BCFL>> getTaskList(@Body() Map<String, dynamic> data);
}