import 'package:flutter/material.dart';
import 'package:flutter_web/controllers/user_controller.dart';
import 'package:flutter_web/mainpage/base_main_page.dart';
import 'package:flutter_web/mainpage/participate_datapath_popup.dart';
import 'package:flutter_web/utils/text_utils.dart';

import 'package:flutter_web/data/bcfl.dart';
import 'package:flutter_web/data/user.dart';
import 'package:flutter_web/utils/string_resources.dart';
import 'package:flutter_web/utils/style_resources.dart';

class ParticipateDetailPage extends StatefulWidget {
  ParticipateDetailPage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<ParticipateDetailPage> createState() => ParticipateDetailPageState();
}

class ParticipateDetailPageState extends State<ParticipateDetailPage> {
  @override
  Widget build(BuildContext context) {
    var args;
    var selectedItem;
    try {
      args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>;
      selectedItem = args['content'];
    } catch (Exception) {
      selectedItem = dummyBCFLList[0];
    }
    var userName = dummyUser.userName;
    var userType = dummyUser.userType;
    var isConnect = walletConnect;

    return BaseMainView(
        child: detailPopup(selectedItem),
        userName: userName,
        userType: userType,
        isConnect: isConnect);
  }

  Widget detailPopup(BCFL data) {
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
                        data.owner, 20, TextAlign.left, FontWeight.bold)),
                Container(
                    margin: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                    child: TextUtils.defaultTextWithSize(data.intro, 15)),
                Container(
                    alignment: Alignment.centerLeft,
                    padding: const EdgeInsets.fromLTRB(0, 40, 0, 0),
                    child: TextUtils.defaultTextWithSizeAlignWeight(
                        StringResources.contact,
                        20,
                        TextAlign.left,
                        FontWeight.bold)),
                Container(
                  margin: const EdgeInsets.fromLTRB(20, 20, 0, 0),
                  alignment: Alignment.centerLeft,
                  child: TextUtils.defaultTextWithSize(stringContact(data), 15),
                ),
                Container(
                    alignment: Alignment.centerLeft,
                    padding: const EdgeInsets.fromLTRB(0, 40, 0, 0),
                    child: TextUtils.defaultTextWithSizeAlignWeight(
                        StringResources.details,
                        20,
                        TextAlign.left,
                        FontWeight.bold)),
                Container(
                  margin: const EdgeInsets.fromLTRB(20, 20, 0, 0),
                  alignment: Alignment.centerLeft,
                  child: TextUtils.defaultTextWithSize(stringDetails(data), 15),
                ),
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
                        ParticipateDataPathPopup.showDataPathPopup(context);
                        setState(() {

                        });
                      },
                      child: Container(
                        alignment: Alignment.center,
                        child: const Text(
                          StringResources.participate,
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

  String stringContact(BCFL data) {
    return "email : " + data.email + "\nphone : " + data.phone;
  }

  String stringDetails(BCFL data) {
    return "Framework : " +
        data.framework +
        "\nTrainers : " +
        data.participants +
        "\nToken Supply : " +
        data.tokenSupply +
        "\nPurpose : " +
        data.purpose +
        "\nData type : " +
        data.dataType;
  }
}
