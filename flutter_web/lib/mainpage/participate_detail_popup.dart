import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_web/controllers/user_controller.dart';
import 'package:flutter_web/data/bcfl.dart';
import 'package:flutter_web/data/user.dart';
import 'package:flutter_web/utils/color_category.dart';
import 'package:flutter_web/utils/file_utils.dart';
import 'package:flutter_web/utils/http_utils.dart';
import 'package:flutter_web/utils/string_resources.dart';
import 'package:flutter_web/utils/style_resources.dart';
import 'package:flutter_web/utils/text_utils.dart';

class ParticipateDetailPopup {
  static String mintPath = '';

  static void showDetailPopup(
      BuildContext context, BCFL content, String userType) {
    FilePathBox pathBox = FilePathBox(
      context: context, text: 'Insert description of model here...',
    );
    FilePathBoxState pathBoxState = pathBox.createState();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return SingleChildScrollView(
          child: Container(
            alignment: Alignment.center,
            width: 450,
            height: 500,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20.0),
                image: DecorationImage(
                    image: AssetImage(
                        'assets/images/popup_task_detail_background.png'))),
            child: AlertDialog(
              titlePadding: EdgeInsets.fromLTRB(10, 30, 10, 0),
              backgroundColor: Colors.transparent,
              contentPadding: EdgeInsets.all(20.0),
              title: Container(
                margin: EdgeInsets.fromLTRB(0, 20, 0, 0),
                child: Stack(
                  children: [
                    TextUtils.defaultTextWithSizeColor(
                        StringResources.taskDetail, 25,
                        color: textWhite),
                    Container(
                        height: 30,
                        alignment: Alignment.topRight,
                        child: ElevatedButton(
                            style: StyleResources.pagerNormalBtnStyle,
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: const ColorFiltered(
                              colorFilter: ColorFilter.mode(Colors.white, BlendMode.srcIn),
                              child: Image(
                                fit: BoxFit.cover,
                                image:
                                AssetImage('assets/images/common_cancel_btn.png'),
                              ),
                            )

                        )),
                  ],
                ),
              ),
              content: Column(
                children: [
                  taskDetailElement('Owner', content.userName),
                  taskDetailElement('Learning Status', statusCodeToString(content.taskStatusCode)),
                  taskDetailElement('Contract Address', content.taskContractAddress),
                  if (userType == typeParticipant)
                  Column(
                    children: [
                      //임의로 사용자 지갑 주소 넣음
                      taskDetailElement('My toknes', userController.address.value),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          TextUtils.defaultTextWithSizeColor(
                              'Transaction Approval', 15,
                              color: commonBtnColor),
                          const Spacer(),
                          TextButton(
                              style: ButtonStyle(
                                  backgroundColor:
                                      MaterialStateColor.resolveWith(
                                          StyleResources.commonBtnCallback)),
                              onPressed: dummy,
                              child: Text(
                                "sign tx",
                                style: StyleResources.pagerTextBtnNormalStyle,
                              )),
                        ],
                      ),
                    ],
                  ),
                if (userType == typeOrganization)
                  Column(
                    children: [
                      TextUtils.defaultTextWithSizeColor('Model Minting', 25,
                          color: textWhite),
                      pathBox,
                      TextButton(
                          style: ButtonStyle(
                              backgroundColor: MaterialStateColor.resolveWith(
                                  StyleResources.commonBtnCallback)),
                          onPressed: () {
                            mintPath = pathBoxState.getSelectedFilePath();
                            //TODO MINT 함수 구현
                          },
                          child: Text(
                            'MINT IT!',
                            style: StyleResources.pagerTextBtnNormalStyle,
                          )),
                    ],
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  static Widget taskDetailElement(String field, String data) {
    return Container(
      margin: EdgeInsets.fromLTRB(0, 10, 0, 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          TextUtils.defaultTextWithSizeColor(field, 15, color: commonBtnColor),
          const Spacer(),
          TextUtils.defaultTextWithSizeColor(data, 15, color: textWhite),
        ],
      ),
    );
  }

  static void dummy() {
    print("dummy button");
  }
}
