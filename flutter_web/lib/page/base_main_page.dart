import 'package:flutter/material.dart';

import '../utils/color_category.dart';
import '../utils/text_utils.dart';

class BaseMainView extends StatefulWidget {
  final String title;
  final Widget child;
  var userName;
  var userType;
  var isConnect;

  BaseMainView({
    required this.title,
    required this.child,
    required this.userName,
    required this.userType,
    required this.isConnect
  });

  @override
  State<BaseMainView> createState() => BaseMainViewState();
}

class BaseMainViewState extends State<BaseMainView>{
  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.fromLTRB(10, 10, 30, 30),
        child: Column(
          children: [
            topBar(context),
            widget.child,
          ],
        )
    );
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
              const Spacer(),
              Container(
                alignment: Alignment.centerRight,
                margin: const EdgeInsets.fromLTRB(0, 0, 10, 0),
                child: TextUtils.defaultTextWithSizeColor(
                    "participate", 17, color: (widget.userType == "part"
                    ? Colors.black
                    : notSelectTextColor)),
              ),
              Container(
                alignment: Alignment.centerRight,
                margin: const EdgeInsets.fromLTRB(0, 0, 40, 0),
                child: TextUtils.defaultTextWithSizeColor(
                    "organization", 17, color: (widget.userType == "org"
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
                child: Image(image: widget.isConnect ?
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
}