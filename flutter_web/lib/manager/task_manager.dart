import 'package:flutter_web/controllers/user_controller.dart';
import 'package:flutter_web/data/bcfl.dart';

import 'package:flutter_web/data/user.dart';
import 'package:flutter_web/services/taskServices.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';

class TaskManager{
  static final TaskManager sInstance = TaskManager._internal();

  factory TaskManager(){
    return sInstance;
  }TaskManager._internal();

  RxList<BCFL> taskListParticiable = <BCFL>[].obs;
  RxList<BCFL> taskListByT = <BCFL>[].obs;
  RxList<BCFL> completedTaskListByT = <BCFL>[].obs;
  RxList<BCFL> taskListByE = <BCFL>[].obs;
  RxList<BCFL> completedTaskListByE = <BCFL>[].obs;

  void initTaskList() async {
    Map<String, dynamic> mapByE = {
      "organizationUserId": globalUser.data.userId,
      "taskStatusCode": "1"}
    ;
    Map<String, dynamic> mapByCompletedE = {
      "organizationUserId": globalUser.data.userId,
      "taskStatusCode": "2"}
    ;
    Map<String, dynamic> mapByT = {
      "trainerUserId": globalUser.data.userId,
      "taskStatusCode": "1"
    };
    Map<String, dynamic> mapByCompletedT = {
      "trainerUserId": globalUser.data.userId,
      "taskStatusCode": "2"
    };

    TaskApi taskApi = TaskApi();

    taskListParticiable.value = await taskApi.getTaskList({"taskStatusCode": "1"});
    if(userController.type.value == typeParticipant){
      taskListByT.value = await taskApi.getTaskList(mapByT);
      completedTaskListByT.value = await taskApi.getTaskList(mapByCompletedT);
    }else if(userController.type.value == typeOrganization){
      taskListByE.value = await taskApi.getTaskList(mapByE);
      completedTaskListByE.value = await taskApi.getTaskList(mapByCompletedE);
    }
  }
}