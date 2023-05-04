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
  List<TaskData> dummyData = [
    TaskData("1", "Cat, dog classification model", "ABC inc", "Trainer"),
    TaskData("2", "Handwriting classification model", "MNIST", "Evaluator"),
    TaskData("3", "Create Wallet", "D-DES", "Trainer"),
  ];
  List<TaskData> dummyPastData = [
    TaskData("1", "Create Wallet", "D-DES", "Trainer"),
    TaskData("2", "Handwriting classification model", "MNIST", "Evaluator"),
    TaskData("3", "Cat, dog classification model", "ABC inc", "Trainer"),
  ];
  bool isSearchAndRegister = false;
  final List<TaskData> filteredData = <TaskData>[];
  @override
  Widget build(BuildContext context) {
    String btnTask = type == "part"? "Explore tasks" : "TASK REGISTER";
    return Container(
          decoration: BoxDecoration(
            color: welcomeBackgroundColor,
            image: const DecorationImage(fit: BoxFit.fill, image:  AssetImage('assets/images/main_background.png')),
          ),
          child: Container(
            margin: EdgeInsets.fromLTRB(10, 10, 30, 30),
            child: Column(
              children: [
                topBar(context),
                if(!isSearchAndRegister)
                  Column(
                    children: [
                      Container(
                        margin: EdgeInsets.fromLTRB(0, 15, 30, 15),
                        alignment: Alignment.centerRight,
                        child: ElevatedButton(
                          onPressed: () {
                            setState(() {
                              isSearchAndRegister = !isSearchAndRegister;
                            });
                          }, //TODO onPressed: ,TASKREGISTER
                          style: ButtonStyle(
                            backgroundColor: MaterialStateColor.resolveWith(
                                StyleResources.createBtnCallback),
                          ),
                          child: Container(
                            padding: EdgeInsets.fromLTRB(15, 5, 15, 5),
                            child: TextUtils.defaultTextWithSize(btnTask, 17),
                          ),
                        ),
                      ),
                      taskTable(context, StringResources.taskInProgress, dummyData),
                      Container(height: 30,),
                      taskTable(context, StringResources.pastTask, dummyData),
                    ],
                  ),
                if(isSearchAndRegister)
                  Container(
                    margin: EdgeInsets.fromLTRB(0, 30, 0, 0),
                    child: taskSearchTable(context, dummyData),
                  ),

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
                    "organization", 17, color: (type == "org" ? Colors.black : notSelectTextColor)),
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

  Widget taskSearchTable(BuildContext context, List<TaskData> data){
    List<TaskData> findData = data;
    return Container(
      child: Column(
        children: [
          Card(
            //TODO Card Background 어떻게 해결하지?
              color: Colors.transparent,
              elevation: 4.0,
              child: Container(
                height: 50,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20.0),
                  color: Colors.white,
                ),
                child: TextField(
                  onChanged: (value) {
                    filterData(value);
                    setState(() {});
                  },
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Search more FL tasks...',
                    hintStyle: TextStyle(color: notSelectTextColor, fontSize: 20),
                    //TODO search Icon 수정
                    prefixIcon: Icon(Icons.search,color: Colors.blueAccent,),
                    suffixIcon: Icon(Icons.cancel,color: Colors.blueAccent,),
                    //prefixIcon: const Image(fit: BoxFit.cover, image: AssetImage("assets/images/main_search_icon.png")),
                  ),
                ),
              )
          ),
          Container(
            alignment: Alignment.topCenter,
            margin: EdgeInsets.fromLTRB(0, 20, 0, 20),
            padding: EdgeInsets.fromLTRB(30, 30, 30, 20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(flex: 1, child: TextUtils.defaultTextWithSizeAlign("num" , 17, TextAlign.center),),
                    Expanded(flex: 6, child: TextUtils.defaultTextWithSize("task" , 17),),
                    Expanded(flex: 6, child: TextUtils.defaultTextWithSize("owner" , 17),),
                    Expanded(flex: 7, child: TextUtils.defaultTextWithSize("participants" , 17),),
                  ],
                ),
                Container(height: 20,),
                createTaskList(context, filteredData.isEmpty? dummyData : filteredData, true),
              ],
            )
          ),
        ],
      )
    );
  }

  Widget taskTable(BuildContext context, String title, List<TaskData> data){
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

  double itemHeight = 60;
  Widget createTaskList(BuildContext context, List<TaskData> data, bool isSearch){
    return ConstrainedBox(
      constraints: const BoxConstraints(maxHeight: 60 * 4 + (10 * 4)),
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Column(
          children: [
            for (TaskData curData in data)
              Container(
                margin: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                child: taskElement(curData, isSearch),
              ),
          ],
        ),
      ),
    );
  }

  Widget taskElement(TaskData content, bool isSearch){
    if(content == null){
      return Container(
        padding: EdgeInsets.all(10),
        height: itemHeight,
        alignment: Alignment.centerLeft,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20.0),
          color: didElementColor,
        ),
      );
    } else{
      return Container(
          padding: EdgeInsets.fromLTRB(0, 0, 0, 7),
        height: itemHeight,
        alignment: Alignment.centerLeft,
        child: Column(
          children: [
            if(content.idx != "num")
              Row(
                children: [
                  Expanded(flex: 1, child: TextUtils.defaultTextWithSizeAlign(content.idx , 17, TextAlign.center),),
                  Expanded(flex: 6, child: TextUtils.defaultTextWithSize(content.title , 17),),
                  Expanded(flex: 6, child: TextUtils.defaultTextWithSize(content.group , 17),),
                  Expanded(flex: 4, child: TextUtils.defaultTextWithSize(isSearch? content.part : content.role, 17),),
                  Expanded(
                    flex: 3,
                    child: Container(
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

  void filterData(String query) {

    filteredData.clear();

    if (query.isNotEmpty) {
      for (var item in dummyData) {
        if (item.containKeyword(query)) {
          filteredData.add(item);
        }
      }
    }else{
        filteredData.addAll(dummyData);
    }
    setState(() {});
  }
}

class TaskData{
  String idx;
  String title;
  String group;
  String role;
  String part = "12/15";
  TaskData(this.idx, this.title, this.group, this.role);

  bool containKeyword(String keyword){
    return title.contains(keyword)
        || group.contains(keyword)
        || role.contains(keyword);
  }
}