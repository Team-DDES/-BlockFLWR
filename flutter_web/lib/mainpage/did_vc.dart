import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_web/controllers/user_controller.dart';
import 'package:flutter_web/data/user_check_data.dart';
import 'package:flutter_web/services/clientService.dart';
import 'package:flutter_web/utils/color_category.dart';

import 'package:flutter_web/utils/style_resources.dart';
import 'package:flutter_web/utils/string_resources.dart';
import 'package:flutter_web/utils/text_utils.dart';
import 'package:get/get.dart';

class DidVc extends StatefulWidget {
  const DidVc({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<DidVc> createState() => DidVcPageState();
}

class DidVcPageState extends State<DidVc> {
  List<TextEditingController> itemTextControllers = List.generate(
    4, (index) => TextEditingController(),
  );
  final List<String> items = <String>[
    "Input Name",
    "input Type (T / E)",
    "Input Email",
    "Input phone",
  ];

  var itemWidth = 300;
  var itemHeight = 40;

  @override
  Widget build(BuildContext context) {
    var dio = Dio();
    UserApi createVC = UserApi(dio);
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          color: welcomeBackgroundColor,
          image: const DecorationImage(
              fit: BoxFit.cover,
              image: AssetImage('assets/images/did_background.png')),
        ),
        child: Center(
            child: Container(
          width: 450,
          height: 500,
          padding: const EdgeInsets.all(30),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.0),
            color: Colors.white,
            boxShadow: [StyleResources.defaultBoxShadow],
          ),
          child: Column(
            children: [
              Container(
                alignment: Alignment.centerLeft,
                padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
                child: TextUtils.defaultTextWithSizeAlignWeight(StringResources.whyDID, 20, TextAlign.left, FontWeight.bold)
              ),
              Container(
                margin: const EdgeInsets.fromLTRB(0, 0, 0, 20),
                child: TextUtils.defaultTextWithSize(StringResources.didIntro, 15)
              ),
              for(int i= 0; i < 4; i++)
                didElement(items[i], i),
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
                      // TODO mainpage로 이동
                      UserRegisterData postData = UserRegisterData(
                          userAddress: userController.address.value,
                          userName: itemTextControllers[0].text,
                          userType: itemTextControllers[1].text,
                          userEmail: itemTextControllers[2].text,
                          userPhone: itemTextControllers[3].text);
                      createVC.registerUser(postData.toJson()).then((value) {
                        if(value.result.code == "200"){
                          Navigator.pushNamed(
                            context,
                            "participate_main_page",
                          );
                        }else{
                          //Popup 생성
                          print("Not Create VC");
                        }
                      });
                    },
                    child: Container(
                      alignment: Alignment.center,
                      child: const Text(
                        StringResources.create,
                        textAlign: TextAlign.center,
                      ),
                    )),
              )
            ],
          ),
        )),
      ),
    );
  }

  Widget didElement(String content, int idx) {
    return Container(
      margin: const EdgeInsets.fromLTRB(0, 10, 0, 10),
      width: 300,
        height: 40,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20.0),
          color: didElementColor,
          border: Border.all(color: notSelectTextColor, width: 3),
        ),
        child: TextField(
          onChanged: (value) {
            setState(() {

            });
          },
          controller: itemTextControllers[idx],
          decoration: InputDecoration(
            border: InputBorder.none,
            hintText: content,
            hintStyle: TextStyle(color: notSelectTextColor, fontSize: 15),
            suffixIcon: IconButton(
              onPressed: () {
                itemTextControllers[idx].clear();
              },
              icon: Icon(Icons.cancel),
              color: Colors.black,
            ),
            //prefixIcon: const Image(fit: BoxFit.cover, image: AssetImage("assets/images/main_search_icon.png")),
          ),
        ),
      );
    }
}
