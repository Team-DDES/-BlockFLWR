import 'package:flutter/material.dart';
import 'package:flutter_web/controllers/user_controller.dart';
import 'package:flutter_web/data/user_register.dart';
import 'package:flutter_web/mainpage/base_main_page.dart';
import 'package:flutter_web/manager/wallet_connection_manager.dart';
import 'package:flutter_web/services/taskServices.dart';
import 'package:flutter_web/utils/text_utils.dart';

import 'package:flutter_web/data/user.dart';
import 'package:flutter_web/utils/color_category.dart';
import 'package:flutter_web/utils/style_resources.dart';

class OrganizationRegisterPage extends StatefulWidget {
  const OrganizationRegisterPage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<OrganizationRegisterPage> createState() => OrganizationRegisterPageState();
}

class OrganizationRegisterPageState extends State<OrganizationRegisterPage> {
  List<TextEditingController> itemTextControllers = List.generate(
    5,
        (index) => TextEditingController(),
  );
  final List<String> items = <String>[
    "Input taskName",
    "input taskPurpose",
    "Input taskFramework",
    "Input taskDataType",
    "Input taskMaxTrainer",
  ];
  var itemHeight = 60;

  @override
  Widget build(BuildContext context) {
    var userName = globalUser.data.userName;
    var userType = globalUser.data.userType;

    return BaseMainView(
        userName: userName,
        userType: userType,
        child: taskRegister());
  }

  Widget taskRegister() {
    return Scaffold(
      body: Container(
          width: 400,
          height: 700,
          margin: EdgeInsets.fromLTRB(0, 30, 0, 0),
          padding: const EdgeInsets.all(30),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.0),
            color: Colors.white,
            boxShadow: [StyleResources.defaultBoxShadow],
          ),
          child: Stack(
            children: [
              Column(
                children: [
                  Container(
                      alignment: Alignment.centerLeft,
                      padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                      child: TextUtils.defaultTextWithSizeAlignWeight(
                          "FL task registeration", 20, TextAlign.left, FontWeight.bold)),
                  for (int i = 0; i < items.length; i++)
                    taskElement(items[i], i),
                  Container(
                    width: 110,
                    height: 30,
                    margin: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                    child: ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor: MaterialStateColor.resolveWith(
                              StyleResources.commonBtnCallback),
                        ),
                        onPressed: () {
                          TaskApi api = TaskApi();
                          TaskRegisterData postData = TaskRegisterData(
                            taskName: itemTextControllers[0].text,
                            taskPurpose: itemTextControllers[1].text,
                            taskFramework: itemTextControllers[2].text,
                            taskDataType: itemTextControllers[3].text,
                            taskMaxTrainer: itemTextControllers[4].text,
                            userId: globalUser.data.userName,
                          );
                          api.postRegisterTask({

                          });
                        },
                        child: Container(
                          alignment: Alignment.center,
                          child: const Text(
                            "Register",
                            textAlign: TextAlign.center,
                          ),
                        )),
                  )
                ],
              ),
              Container(
                  height: 30,
                  alignment: Alignment.topRight,
                  child: ElevatedButton(
                    style: StyleResources.pagerNormalBtnStyle,
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Image(
                      fit: BoxFit.cover,
                      image: AssetImage('assets/images/common_cancel_btn.png'),
                    ),
                  )),
            ],
          )),
    );
  }

  Widget taskElement(String content, int idx) {
    return Container(
      width: 360,
      height: 40,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.0),
        color: didElementColor,
        border: Border.all(color: notSelectTextColor, width: 3),
      ),
      child: Container(
        alignment: Alignment.center,
        padding: EdgeInsets.fromLTRB(10, 6, 0, 6),
        child: TextField(
          onChanged: (value) {
            setState(() {});
          },
          textAlign: TextAlign.left,
          controller: itemTextControllers[idx],
          decoration: InputDecoration(
            border: InputBorder.none,
            hintText: content,
            alignLabelWithHint: true,
            hintStyle: TextStyle(color: notSelectTextColor, fontSize: 17),
            suffixIcon: IconButton(
              padding: EdgeInsets.fromLTRB(0, 0, 0, 12),
              onPressed: () {
                itemTextControllers[idx].clear();
              },
              icon: Icon(Icons.cancel),
              color: Colors.black,
            ),
            //prefixIcon: const Image(fit: BoxFit.cover, image: AssetImage("assets/images/main_search_icon.png")),
          ),
        ),
      )
    );
  }
}
