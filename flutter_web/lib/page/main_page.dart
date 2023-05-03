import 'package:flutter/material.dart';
import 'package:flutter_web/utils/string_resources.dart';
import '../utils/color_category.dart';
import '../utils/style_resources.dart';
import '../utils/text_utils.dart';

class MainPage extends StatefulWidget{
  const MainPage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<MainPage> createState() => MainPageState();
}

class MainPageState extends State<MainPage>{
  //TODO User 정보가져오는 방법 협의
  var userName = "@ID";
  var type = "part";
  var isConnect = true;
  var dummyData = {
    TaskData("Cat, dog classification model", "ABC inc", "Trainer"),
    TaskData("Handwriting classification model", "MNIST", "Evaluator"),
    TaskData("Create Wallet", "D-DES", "Trainer"),
  };
  var dummyPastData = {
    TaskData("Create Wallet", "D-DES", "Trainer"),
    TaskData("Handwriting classification model", "MNIST", "Evaluator"),
    TaskData("Cat, dog classification model", "ABC inc", "Trainer"),
  };
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: welcomeBackgroundColor,
        image: const DecorationImage(fit: BoxFit.cover,image:  AssetImage('assets/images/main_background.png')),
      ),
      child: Container(
        margin: EdgeInsets.all(10),
        child: Column(
          children: [
            topBar(context),
            Container(
              margin: EdgeInsets.fromLTRB(0, 15, 30, 15),
              alignment: Alignment.centerRight,
              child: ElevatedButton(
                onPressed: () {
                  dummy();
                },//TODO onPressed: ,TASKREGISTER
                style: ButtonStyle(
                  backgroundColor: MaterialStateColor.resolveWith(StyleResources.createBtnCallback),
                ),
                child: Container(
                  padding: EdgeInsets.fromLTRB(15, 5, 15, 5),
                  child: TextUtils.defaultTextWithSize("TASK REGISTER", 17),
                ),
              ),
            ),
            taskTable(context, StringResources.taskInProgress, dummyData),
            Container(height: 30,),
            taskTable(context, StringResources.pastTask, dummyData),
          ],
        ),
      )
      
    );
  }

  Widget topBar(BuildContext context){
    return Column(
      children: [
        Container(
          margin: const EdgeInsets.fromLTRB(10, 0, 30, 0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                alignment: Alignment.centerLeft,
                child: TextUtils.defaultTextWithSize("Welcome, " + userName, 17),
              ),
              const Spacer(),
              Container(
                alignment: Alignment.centerRight,
                margin: const EdgeInsets.fromLTRB(0, 0, 10, 0),
                child: TextUtils.defaultTextWithSizeColor(
                    "participate", 17, color: (type == "part" ? Colors.black : notSelectTextColor)),
              ),
              Container(
                alignment: Alignment.centerRight,
                margin: const EdgeInsets.fromLTRB(0, 0, 40, 0),
                child: TextUtils.defaultTextWithSizeColor(
                    "participate", 17, color: (type == "org" ? Colors.black : notSelectTextColor)),
              ),
              Container(
                alignment: Alignment.centerRight,
                margin: const EdgeInsets.fromLTRB(0, 0, 5, 0),
                child: TextUtils.defaultTextWithSize("Wallet connection", 17),
              ),
              Container(
                height: 45,
                alignment: Alignment.centerRight,
                padding: const EdgeInsets.all(10),
                child: Image(image: isConnect?
                AssetImage('assets/images/main_wallet_connection.png')
                    : AssetImage('assets/images/main_wallet_notconnect.png')),
              ),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
          child: const Divider(
            height: 2,
            thickness: 1,
            color: Colors.black,
          ),
        ),
      ],
    );
  }

  Widget taskTable(BuildContext context, String title, Set<TaskData> data){
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
              ),),
          ),
          createTaskList(context, data),
        ],
      )
    );
  }

  double itemHeight = 60;
  Widget createTaskList(BuildContext context, Set<TaskData> data){
    int idx = 1;
    Iterator dIter = data.iterator;
    return ConstrainedBox(
      constraints: BoxConstraints(maxHeight: itemHeight * 4 + (10 * 4)),
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Column(
          children: [
            for (TaskData cur = data.first; dIter.moveNext(); cur = dIter.current, idx++)
              Container(
                margin: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                child: taskElement(cur, idx),
              ),
          ],
        ),
      ),
    );
  }

  Widget taskElement(TaskData content, int idx){
    if(content == null){
      return Container(
        padding: EdgeInsets.all(10),
        height: itemHeight,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20.0),
          color: didElementColor,
        ),
      );
    } else{
      return Container(
          padding: EdgeInsets.fromLTRB(0, 0, 0, 7),
        height: itemHeight,
        alignment: Alignment.center,
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextUtils.defaultTextWithSize(idx.toString() , 17),
                TextUtils.defaultTextWithSize(content.title , 17),
                TextUtils.defaultTextWithSize(content.group , 17),
                TextUtils.defaultTextWithSize(content.role , 17),
                Container(
                  padding: EdgeInsets.all(10),
                  child: ElevatedButton(
                    onPressed: () {
                      dummy();
                    },//TODO onPressed: ,TASKREGISTER
                    style: ButtonStyle(
                      backgroundColor: MaterialStateColor.resolveWith(StyleResources.createBtnCallback),
                    ),
                    child: Container(
                      padding: EdgeInsets.fromLTRB(15, 5, 15, 5),
                      child: TextUtils.defaultTextWithSize("DETAIL", 17),
                    ),
                  ),
                ),
                
                
              ],
            ),
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

class TaskData{
  String title;
  String group;
  String role;

  TaskData(this.title, this.group, this.role);
}