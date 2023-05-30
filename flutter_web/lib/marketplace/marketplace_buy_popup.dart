import 'package:flutter/material.dart';
import 'package:flutter_web/data/bcfl.dart';
import 'package:flutter_web/data/market.dart';
import 'package:flutter_web/utils/color_category.dart';
import 'package:flutter_web/utils/style_resources.dart';
import 'package:flutter_web/utils/text_utils.dart';

class MarketplaceBuyPopup {
  static void showBuyPopup(BuildContext context, Market nft) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Container(
            width: 400,
            height: 500,
            alignment: Alignment.center,
            margin: EdgeInsets.fromLTRB(300, 70, 300, 100),
            padding: EdgeInsets.fromLTRB(0, 30, 0, 30),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                image: DecorationImage(
                    image: AssetImage(
                        'assets/images/popup_model_info_background.png'))),
            child: Stack(
              children: [
                Container(
                  alignment: Alignment.center,
                  child: Column(
                    children: [
                      Container(
                        width: 300,
                        alignment: Alignment.centerLeft,
                        child: Column(
                          children: [
                            ColorFiltered(
                              colorFilter: ColorFilter.mode(
                                  Colors.white, BlendMode.srcIn),
                              child: TextUtils.defaultTextWithSizeAlignWeight(
                                  nft.owner,
                                  25,
                                  TextAlign.left,
                                  FontWeight.bold),
                            ),
                            Container(height: 10,),
                            ColorFiltered(
                              colorFilter: ColorFilter.mode(
                                  Colors.white, BlendMode.srcIn),
                              child: TextUtils.defaultTextWithSize(
                                nft.task_name,
                                15,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.fromLTRB(0, 20, 0, 0),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20)),
                        child: Image(
                          fit: BoxFit.cover,
                          image: AssetImage('assets/images/example_org_1.png'),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.all(20),
                        child: TextUtils.defaultTextWithSizeColor(
                            'Model info Abstract', 25,
                            color: commonBtnColor),
                      ),
                      modelInfoElement("Framework : " + nft.task_framework),
                      modelInfoElement(
                          "Traniners : " + nft.task_max_trainer.toString()),
                      modelInfoElement("Token supply : " + nft.owner_address),
                      modelInfoElement("Downloads : " + nft.model_uri),
                      modelInfoElement("Purpose : " + nft.description),
                      Container(
                        margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
                        child: TextUtils.defaultTextWithSizeAlignWeight(
                            "Price : " + nft.task_contract_address,
                            15,
                            TextAlign.center,
                            FontWeight.bold),
                      ),
                      Container(
                        child: ElevatedButton(
                          onPressed: () {
                            
                          },
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
                ),
                Container(
                    height: 30,
                    padding: EdgeInsets.fromLTRB(0, 0, 30, 0),
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
          );
        });
  }

  static Widget modelInfoElement(String content) {
    return Container(
      width: 300,
      padding: EdgeInsets.all(5),
      child: ColorFiltered(
        colorFilter: ColorFilter.mode(Colors.white, BlendMode.srcIn),
        child:
            TextUtils.defaultTextWithSizeAlign(content, 15, TextAlign.left),
      ));
  }
}
