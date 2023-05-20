import 'package:flutter/material.dart';
import 'package:flutter_web/controllers/user_controller.dart';
import 'package:flutter_web/data/user.dart';
import 'package:flutter_web/data/user_register.dart';
import 'package:flutter_web/services/clientService.dart';
import 'package:flutter_web/utils/color_category.dart';

import 'package:flutter_web/utils/style_resources.dart';
import 'package:flutter_web/utils/string_resources.dart';
import 'package:flutter_web/utils/text_utils.dart';

class DidVc extends StatefulWidget {
  const DidVc({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<DidVc> createState() => DidVcPageState();
}

class DidVcPageState extends State<DidVc> {
  List<TextEditingController> itemTextControllers = List.generate(
    4,
    (index) => TextEditingController(),
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
          height: 550,
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
                  child: TextUtils.defaultTextWithSizeAlignWeight(
                      StringResources.whyDID,
                      20,
                      TextAlign.left,
                      FontWeight.bold)),
              Container(
                  margin: const EdgeInsets.fromLTRB(0, 0, 0, 20),
                  child: TextUtils.defaultTextWithSize(
                      StringResources.didIntro, 15)),
              for (int i = 0; i < 4; i++) didElement(items[i], i),
              Container(
                width: 110,
                height: 30,
                margin: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                child: ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateColor.resolveWith(
                          StyleResources.commonBtnCallback),
                    ),
                    onPressed: createVC, //createVC
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
              hintStyle: TextStyle(color: notSelectTextColor, fontSize: 15),
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
        ));
  }

  Future<void> createVC() async {
    if(userController.address.value.isEmpty){
      userController.address.value = "0x7F2aefB41181cc37487f6be5a03266d912852bc4";
    }
    PostUserRegisterData postData = PostUserRegisterData(
        userAddress: userController.address.value,
        userName: itemTextControllers[0].text,
        userType: itemTextControllers[1].text,
        userEmail: itemTextControllers[2].text,
        userPhone: itemTextControllers[3].text);

    UserApi vcApi = UserApi();

    UserRegister response = await vcApi.registerUser(postData.toJson());
    if (response.result.code == "200") {
      if (postData.userType == typeParticipant) {
        Navigator.pushNamed(
          context,
          "participate_main_page",
        );
      } else if (postData.userType == typeOrganization) {
        Navigator.pushNamed(
          context,
          "organization_main_page",
        );
      }
    } else if (response.result.code == "404") {
      if (globalUser.data.userType == typeParticipant) {
        Navigator.pushNamed(
          context,
          "participate_main_page",
        );
      } else if (globalUser.data.userType == typeOrganization) {
        Navigator.pushNamed(
          context,
          "organization_main_page",
        );
      }
    } else {
      print("Not Create VC");
    }
  }
}
