import 'package:flutter/material.dart';
import 'package:flutter_web/controllers/user_controller.dart';
import 'package:flutter_web/mainpage/base_main_page.dart';
import 'package:flutter_web/manager/wallet_connection_manager.dart';
import 'package:flutter_web/utils/text_utils.dart';

import 'package:flutter_web/data/user.dart';
import 'package:flutter_web/utils/color_category.dart';
import 'package:flutter_web/utils/style_resources.dart';

class OrganizationRegisterPage extends StatefulWidget {
  OrganizationRegisterPage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<OrganizationRegisterPage> createState() => OrganizationRegisterPageState();
}

class OrganizationRegisterPageState extends State<OrganizationRegisterPage> {

  var items = <String>[
    "list 1",
    "list 2",
    "list 3",
    "list 4",
    "list 5",
    "list 6",
  ];
  var itemHeight = 60;

  @override
  Widget build(BuildContext context) {
    var userName = dummyUser.userData.userName;
    var userType = dummyUser.userData.userType;

    return BaseMainView(
        userName: userName,
        userType: userType,
        child: taskRegister());
  }

  Widget taskRegister() {
    return Container(
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
                createTaskList(context),
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
                        // TODO register 이후?
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
        ));
  }

  Widget createTaskList(context) {
    return ConstrainedBox(
      constraints: BoxConstraints(maxHeight: itemHeight * 4 + (10 * 4)),
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Column(
          children: [
            for (int i = 0; i < items.length; i++)
              Container(
                margin: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                child: taskElement(items[i]),
              ),
          ],
        ),
      ),
    );
  }

  Widget taskElement(String content) {
    if (content == null) {
      return Container(
        width: 360,
        height: 60,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20.0),
          color: didElementColor,
        ),
      );
    } else {
      return Container(
        width: 360,
        height: 60,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20.0),
          color: didElementColor,
        ),
        child: Text(
          content,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 15),
        ),
      );
    }
  }
}
