import 'package:flutter/material.dart';
import 'package:flutter_web/data/user.dart';
import 'package:flutter_web/mainpage/base_main_page.dart';
import 'package:flutter_web/mainpage/participate_main_page.dart';
import 'package:flutter_web/manager/task_manager.dart';
import 'package:flutter_web/utils/style_resources.dart';

import 'package:flutter_web/data/bcfl.dart';
import 'package:flutter_web/utils/color_category.dart';
import 'package:flutter_web/utils/text_utils.dart';

class ParticipateSearchPage extends StatefulWidget {
  ParticipateSearchPage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<ParticipateSearchPage> createState() => ParticipateSearchPageState();
}

class ParticipateSearchPageState extends State<ParticipateSearchPage> {
  static double maxCapacity = 9;
  var userName = globalUser.data.userName;
  var userType = globalUser.data.userType;

  final capacity = 9;
  final List<BCFL> filteredData = TaskManager.sInstance.taskListParticiable.toList();
  final List<BCFL> displayData = <BCFL>[];

  int selectPage = 1;

  TextEditingController itemTextControllers = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60 * maxCapacity + (10 * maxCapacity),
      child: BaseMainView(
          child: taskSearchTable(context, TaskManager.sInstance.taskListParticiable),
          userName: userName,
          userType: userType,),
    );
  }

  Widget taskSearchTable(BuildContext context, List<BCFL> data) {
    return Container(
        child: Column(
      children: [
        Card(
            color: Colors.transparent,
            elevation: 4.0,
            shadowColor: Colors.transparent,
            child: Container(
              height: 60,
              margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20.0),
                color: Colors.white,
              ),
              child: TextField(
                controller: itemTextControllers,
                onChanged: (value) {
                  filterData(value);
                  setState(() {
                    selectPage = 1;
                  });
                },
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Search more FL tasks...',
                  hintStyle: TextStyle(color: notSelectTextColor, fontSize: 20),
                  //TODO search Icon 수정
                  prefixIcon: Icon(
                    Icons.search,
                    color: Colors.black,
                  ),
                  suffixIcon: IconButton(
                    onPressed: itemTextControllers.clear,
                    icon: Icon(Icons.cancel,
                    color: Colors.black,)
                  ),
                  //prefixIcon: const Image(fit: BoxFit.cover, image: AssetImage("assets/images/main_search_icon.png")),
                ),
              ),
            )),
        Container(
            alignment: Alignment.topCenter,
            margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
            padding: EdgeInsets.fromLTRB(30, 20, 30, 20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: TextUtils.defaultTextWithSizeAlign(
                          "num", 17, TextAlign.center),
                    ),
                    Expanded(
                      flex: 6,
                      child: TextUtils.defaultTextWithSize("task", 17),
                    ),
                    Expanded(
                      flex: 6,
                      child: TextUtils.defaultTextWithSize("owner", 17),
                    ),
                    Expanded(
                      flex: 7,
                      child: TextUtils.defaultTextWithSize("participants", 17),
                    ),
                  ],
                ),
                Container(
                  height: 10,
                ),
                ParticipateMainPageState.createTaskList(
                    context,
                    filteredData.isEmpty
                        ? createDisplayData(TaskManager.sInstance.taskListByT, selectPage)
                        : createDisplayData(filteredData, selectPage),
                    true),
                Stack(
                  children: [
                    pagerList(context,
                        filteredData.isEmpty ? TaskManager.sInstance.taskListParticiable : filteredData),
                    Container(
                        height: 30,
                        alignment: Alignment.bottomLeft,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          style: ButtonStyle(
                            backgroundColor: MaterialStateColor.resolveWith(
                                StyleResources.commonBtnCallback),
                          ),
                          child: Container(
                            padding: EdgeInsets.fromLTRB(15, 5, 15, 5),
                            child: TextUtils.defaultTextWithSize(
                                "back to main page", 17),
                          ),
                        )),
                  ],
                ),
              ],
            )),
      ],
    ));
  }

  Widget pagerList(BuildContext context, List<BCFL> listData) {
    var pagerNeed = listData.length % maxCapacity == 0
        ? listData.length ~/ maxCapacity
        : listData.length ~/ maxCapacity + 1;
    List<bool> pagerSelect = List.filled(pagerNeed == 0? 1 : pagerNeed, false);
    pagerSelect[selectPage - 1] = true;
    double screenWidth = MediaQuery.of(context).size.width;
    return Container(
      alignment: Alignment.center,
      height: 20,
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(screenWidth / 4, 0, screenWidth / 4, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          ElevatedButton(
            style: StyleResources.pagerBtnStyle,
            onPressed: () {
              if (selectPage > 1) {
                setState(() {
                  selectPage = selectPage - 1;
                });
              }
            },
            child: Icon(Icons.chevron_left_rounded, color: Colors.black),
          ),
          for (int i = 1; i <= pagerNeed; i++)
            ElevatedButton(
              style: pagerSelect[i - 1]
                  ? StyleResources.pagerSelectBtnStyle
                  : StyleResources.pagerNormalBtnStyle,
              onPressed: () {
                setState(() {
                  selectPage = i;
                });
              },
              child: Text(
                i.toString(),
                style: StyleResources.pagerTextBtnNormalStyle,
              ),
            ),
          ElevatedButton(
            style: StyleResources.pagerBtnStyle,
            onPressed: () {
              if (selectPage < pagerNeed) {
                setState(() {
                  selectPage = selectPage + 1;
                });
              }
            },
            child: Icon(Icons.chevron_right_rounded, color: Colors.black),
          )
        ],
      ),
    );
  }

  void filterData(String query) {
    print("input query :: " + query);
    filteredData.clear();
    if (query != "") {
      for (var item in TaskManager.sInstance.taskListParticiable) {
        if (item.containKeyword(query)) {
          filteredData.add(item);
        }
      }
    } else {
      print("query else routine !!");
      filteredData.addAll(TaskManager.sInstance.taskListParticiable.toList());
    }
    print("filteredData result :: " + filteredData.length.toString());
    setState(() {
    });
  }

  List<BCFL> createDisplayData(List<BCFL> targetData, int page) {
    List<BCFL> displayData = <BCFL>[];
    int start = (maxCapacity * (page - 1)).toInt();
    int limit;
    if (targetData.length < start + maxCapacity.toInt()) {
      limit = targetData.length;
    } else {
      limit = maxCapacity.toInt() + start;
    }
    for (int i = start; i < limit; i++) {
      displayData.add(targetData[i]);
    }
    return displayData;
  }

  static void setMaxCapacity(double cap) {
    maxCapacity = cap;
  }
}
