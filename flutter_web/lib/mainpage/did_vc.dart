import 'package:flutter/material.dart';
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
  var items = <String>[
    "list 1",
    "list 2",
    "list 3",
    "list 4",
    "list 5",
    "list 6",
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
              createDidList(context),
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
                      Navigator.pushNamed(
                        context,
                        "participate_main_page",
                      );
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

  Widget createDidList(context) {
    return ConstrainedBox(
      constraints: BoxConstraints(maxHeight: itemHeight * 4 + (10 * 4)),
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Column(
          children: [
            for (int i = 0; i < items.length; i++)
              Container(
                margin: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                child: didElement(items[i]),
              ),
          ],
        ),
      ),
    );
  }

  Widget didElement(String content) {
    if (content == null) {
      return Container(
        width: 300,
        height: 40,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20.0),
          color: didElementColor,
        ),
      );
    } else {
      return Container(
        width: 300,
        height: 40,
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
