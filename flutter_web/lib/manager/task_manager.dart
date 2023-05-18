import 'package:dio/dio.dart';
import 'package:flutter_web/data/bcfl.dart';
import 'package:flutter_web/services/taskServices.dart';

import 'package:flutter_web/data/user.dart';

class TaskManager{
  static final TaskManager sInstance = TaskManager._internal();

  factory TaskManager(){
    return sInstance;
  }TaskManager._internal();

   List<BCFL> taskListParticiable = <BCFL>[];
   List<BCFL> taskListByE = <BCFL>[];
   List<BCFL> taskListByT = <BCFL>[];

  void initTaskList(){
    var dio = Dio();
    TaskApi taskApi = TaskApi(dio);

    Map<String, dynamic> mapParticiable = {"taskStatusCode": 1};
    Map<String, dynamic> mapByE = {
      "organizationUserId": globalUser.data.userId,
      "taskStatusCode": 2}
    ;
    Map<String, dynamic> mapByT = {
      "trainerUserId": globalUser.data.userId,
      "taskStatusCode": 2
    };

    taskApi.getTaskList(mapParticiable).then((value) => taskListParticiable);
    taskApi.getTaskList(mapByE).then((value) => taskListByE);
    taskApi.getTaskList(mapByT).then((value) => taskListByT);
  }
}