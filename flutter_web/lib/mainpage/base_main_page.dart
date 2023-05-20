import 'package:flutter/material.dart';
import 'package:flutter_web/controllers/user_controller.dart';

import 'package:flutter_web/utils/color_category.dart';
import 'package:flutter_web/utils/style_resources.dart';
import 'package:flutter_web/utils/text_utils.dart';
import 'package:get/get.dart';

class BaseMainView extends StatefulWidget {
  var child;
  var userName;
  var userType;

  BaseMainView({
    required this.child,
    required this.userName,
    required this.userType,
  });

  @override
  State<BaseMainView> createState() => BaseMainViewState();
}

class BaseMainViewState extends State<BaseMainView> {
  @override
  Widget build(BuildContext context) {
    return Container(
        height: 1010,
        width: 1920,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: welcomeBackgroundColor,
          image: const DecorationImage(
              fit: BoxFit.fill,
              image: AssetImage('assets/images/main_background.png')),
        ),
        child: Container(
          margin: EdgeInsets.fromLTRB(10, 10, 30, 30),
          child: Column(
            children: [
              topBar(context),
              widget.child,
            ],
          ),
        ));
  }

  Widget topBar(BuildContext context) {
    return Column(
      children: [
        Container(
          margin: const EdgeInsets.fromLTRB(10, 0, 30, 0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                alignment: Alignment.centerLeft,
                child: TextUtils.defaultTextWithSize(
                    "Welcome, " + widget.userName, 17),
              ),
              Container(
                margin: EdgeInsets.fromLTRB(50, 15, 30, 15),
                alignment: Alignment.centerRight,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, "marketplace_main_page");
                  },
                  style: ButtonStyle(
                    backgroundColor: MaterialStateColor.resolveWith(
                        StyleResources.commonBtnCallback),
                  ),
                  child: Container(
                    padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
                    child: TextUtils.defaultTextWithSize("Marrket Place", 17),
                  ),
                ),
              ),
              const Spacer(),
              Container(
                alignment: Alignment.centerRight,
                margin: const EdgeInsets.fromLTRB(0, 0, 10, 0),
                child: TextUtils.defaultTextWithSizeColor("participate", 17,
                    color: (widget.userType == "T"
                        ? Colors.black
                        : notSelectTextColor)),
              ),
              Container(
                alignment: Alignment.centerRight,
                margin: const EdgeInsets.fromLTRB(0, 0, 40, 0),
                child: TextUtils.defaultTextWithSizeColor("organization", 17,
                    color: (widget.userType == "E"
                        ? Colors.black
                        : notSelectTextColor)),
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
                  child: Obx(() {
                    return Image(
                        image: userController.walletConnect.value
                            ? AssetImage(
                                'assets/images/main_wallet_connection.png')
                            : AssetImage(
                                'assets/images/main_wallet_notconnect.png'));
                  })),
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
}
