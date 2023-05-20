import 'package:flutter/material.dart';
import 'package:flutter_web/data/bcfl.dart';
import 'package:flutter_web/utils/color_category.dart';
import 'package:flutter_web/utils/style_resources.dart';
import 'package:flutter_web/utils/text_utils.dart';

class MarketplaceBuyPopup {
  static void showBuyPopup(BuildContext context, BCFL bcfl) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return SingleChildScrollView(
            child: Container(
              margin: EdgeInsets.fromLTRB(300, 100, 300, 100),
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  image: DecorationImage(
                      image: AssetImage(
                          'assets/images/popup_model_info_background.png'))),
              child: Stack(
                children: [
                  Column(
                    children: [
                      Expanded(
                        flex: 1,
                        child: Row(
                          children: [
                            //Organization Image
                            Expanded(
                              flex: 1,
                              child: Container(
                                width: double.maxFinite,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20)),
                                child: Image(
                                  fit: BoxFit.fitWidth,
                                  image: AssetImage(
                                      'assets/images/example_org_1.png'),
                                ),
                              ),
                            ),
                            Expanded(
                                flex: 1,
                                child: Container(
                                  width: double.maxFinite,
                                  alignment: Alignment.centerLeft,
                                  child: Column(
                                    children: [
                                      ColorFiltered(
                                        colorFilter: ColorFilter.mode(
                                            Colors.white, BlendMode.srcIn),
                                        child: TextUtils
                                            .defaultTextWithSizeAlignWeight(
                                            bcfl.userName,
                                            25,
                                            TextAlign.left,
                                            FontWeight.bold),
                                      ),
                                      ColorFiltered(
                                        colorFilter: ColorFilter.mode(
                                            Colors.white, BlendMode.srcIn),
                                        child: TextUtils
                                            .defaultTextWithSize(
                                          bcfl.taskName,
                                          15,),
                                      ),
                                    ],
                                  ),
                                )),
                          ],
                        ),
                      ),
                      //Model info
                      Expanded(
                        flex: 1,
                        child: Container(
                          alignment: Alignment.center,
                          child: Column(
                            children: [
                             Container(
                               margin: EdgeInsets.all(20),
                               child: TextUtils.defaultTextWithSizeColor('Model info Abstract', 25, color: commonBtnColor),
                             ),
                              modelInfoElement("Framework : " + bcfl.taskFramework),
                              modelInfoElement("Traniners : " + bcfl.taskMaxTrainer),
                              modelInfoElement("Token supply : " + bcfl.taskContractAddress),
                              modelInfoElement("Downloads : " + bcfl.taskId.toString()),
                              modelInfoElement("Purpose : " + bcfl.taskPurpose),
                              Container(
                                margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
                                child: TextUtils.defaultTextWithSizeAlignWeight("Price : " + bcfl.taskId.toString(), 15, TextAlign.center, FontWeight.bold),
                              ),
                              Container(
                                child: ElevatedButton(
                                  onPressed: () {},
                                  style: ButtonStyle(
                                    backgroundColor: MaterialStateColor.resolveWith(
                                        StyleResources.commonBtnCallback),
                                  ),
                                  child: TextUtils.defaultTextWithSizeAlignWeight(
                                      'BUY', 20, TextAlign.center, FontWeight.bold),
                                ),
                              )
                            ],
                          ),
                        )
                      ),
                    ],
                  ),
                  Container(
                      height: 30,
                      alignment: Alignment.topRight,
                      child: ElevatedButton(
                          style: StyleResources.pagerNormalBtnStyle,
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: const ColorFiltered(
                            colorFilter:
                                ColorFilter.mode(Colors.white, BlendMode.srcIn),
                            child: Image(
                              fit: BoxFit.cover,
                              image: AssetImage(
                                  'assets/images/common_cancel_btn.png'),
                            ),
                          ))),
                ],
              ),
            ),
          );
        });
  }

  static Widget modelInfoElement(String content){
    return Container(
      padding: EdgeInsets.all(5),
      child: ColorFiltered(
        colorFilter: ColorFilter.mode(Colors.white, BlendMode.srcIn),
        child: TextUtils.defaultTextWithSizeAlign(content, 25, TextAlign.left),
      )
    );
  }
}
