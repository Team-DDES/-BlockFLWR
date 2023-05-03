import 'package:flutter/material.dart';
import 'package:flutter_web/data/bcfl.dart';
import 'package:flutter_web/page/base_main_page.dart';

import '../utils/color_category.dart';
import '../utils/string_resources.dart';
import '../utils/style_resources.dart';
import '../utils/text_utils.dart';

class ParticiPateMainPage extends BaseMainView{
  ParticiPateMainPage({required super.title,
    required super.child,
    required super.userName,
    required super.userType,
    required super.isConnect})
  : super();

}

class ParticiPateMainPageState extends State<ParticiPateMainPage>{
  @override
  Widget build(BuildContext context) {

    var title = "ParticiPateMainPage";
    var userName = "@ID";
    var userType = "participate";
    var isConnect = true;
    var child = null;

    return ParticiPateMainPage(
      title: title,
      userName: userName,
      userType: userType,
      isConnect: isConnect,
      child: participateView(context),
    );
  }

  Widget participateView(BuildContext context){
    return Column(
      children: [
        Container(
          margin: EdgeInsets.fromLTRB(0, 15, 30, 15),
          alignment: Alignment.centerRight,
          child: ElevatedButton(
            onPressed: () {

            }, //TODO onPressed: ,TASKREGISTER
            style: ButtonStyle(
              backgroundColor: MaterialStateColor.resolveWith(
                  StyleResources.createBtnCallback),
            ),
            child: Container(
              padding: EdgeInsets.fromLTRB(15, 5, 15, 5),
              child: TextUtils.defaultTextWithSize("Explore tasks", 17),
            ),
          ),
        ),
        taskTable(context, StringResources.taskInProgress, dummyBCFLList),
        Container(height: 30,),
        taskTable(context, StringResources.pastTask, dummyBCFLList),
      ],
    );
  }

  Widget taskTable(BuildContext context, String title, List<BCFL> data) {
    return Container(
        padding: EdgeInsets.all(30),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20.0),
          color: Colors.white,
          boxShadow: [StyleResources.defaultBoxShadow],
        ),
        child: Column(
          children: [
            Container(
              alignment: Alignment.centerLeft,
              child: Text("Task in progress", textAlign: TextAlign.left,
                style: TextStyle(
                  color: textBlack,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
            ),
            createTaskList(context, data, false),
          ],
        )
    );
  }

  Widget createTaskList(BuildContext context, List<BCFL> data, bool isSearch){
    return ConstrainedBox(
      constraints: const BoxConstraints(maxHeight: 60 * 4 + (10 * 4)),
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Column(
          children: [
            for (BCFL curData in data)
              Container(
                margin: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                child: taskElement(curData, isSearch),
              ),
          ],
        ),
      ),
    );
  }

  Widget taskElement(BCFL content, bool isSearch) {
    double itemHeight = 60;
    if (content == null) {
      return Container(
        padding: EdgeInsets.all(10),
        height: itemHeight,
        alignment: Alignment.centerLeft,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20.0),
          color: didElementColor,
        ),
      );
    } else {
      return Container(
          padding: EdgeInsets.fromLTRB(0, 0, 0, 7),
          height: itemHeight,
          alignment: Alignment.centerLeft,
          child: Column(
            children: [
              if(content.idx != "num")
                Row(
                  children: [
                    Expanded(flex: 1,
                      child: TextUtils.defaultTextWithSizeAlign(
                          content.idx, 17, TextAlign.center),),
                    Expanded(flex: 6,
                      child: TextUtils.defaultTextWithSize(content.taskName, 17),),
                    Expanded(flex: 6,
                      child: TextUtils.defaultTextWithSize(content.owner, 17),),
                    Expanded(flex: 4,
                      child: TextUtils.defaultTextWithSize(
                          isSearch ? content.participants : content.role, 17),),
                    Expanded(
                      flex: 3,
                      child: Container(
                        padding: EdgeInsets.all(10),
                        child: ElevatedButton(
                          onPressed: () {
                            dummy();
                          }, //TODO onPressed: ,TASKREGISTER
                          style: ButtonStyle(
                            backgroundColor: MaterialStateColor.resolveWith(
                                StyleResources.createBtnCallback),
                          ),
                          child: Container(
                            padding: EdgeInsets.fromLTRB(15, 5, 15, 5),
                            child: TextUtils.defaultTextWithSize("DETAIL", 17),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              if(content.idx != "num")
                Divider(
                  height: 2,
                  thickness: 1,
                  color: notSelectTextColor,
                ),
            ],
          )
      );
    }
  }
  void dummy(){
    print("dummy button");
  }
}