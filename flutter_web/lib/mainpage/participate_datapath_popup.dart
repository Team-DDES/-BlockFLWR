import 'package:flutter/material.dart';
import 'package:flutter_web/utils/file_utils.dart';
import 'package:flutter_web/utils/style_resources.dart';
import 'package:flutter_web/utils/text_utils.dart';

class ParticipateDataPathPopup {
  static String filePath = '';

  static void showDataPathPopup(BuildContext context) {
    FilePathBox pathBox = FilePathBox(
      context: context, text: 'browse ...',
    );
    FilePathBoxState pathBoxState = pathBox.createState();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          title: Stack(
            children: [
              TextUtils.defaultTextWithSize('Data path registration', 25),
              Container(
                height: 30,
                alignment: Alignment.topRight,
                child: ElevatedButton(
                  style: StyleResources.pagerNormalBtnStyle,
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Image(
                    fit: BoxFit.cover,
                    image: AssetImage(
                      'assets/images/common_cancel_btn.png',
                    ),
                  ),
                ),
              ),
            ],
          ),
          content: Container(
            height: 100,
            child: Column(
              children: [
                TextUtils.defaultTextWithSize(
                  'warning : Data type is JPEG only, path name should be \'data\'',
                  15,
                ),
                Row(
                  children: [
                    Container(
                      margin: EdgeInsets.fromLTRB(0, 20, 0, 0),
                      height: 50,
                      child: Image(
                        fit: BoxFit.fitHeight,
                        image: AssetImage(
                          'assets/images/common_folder_icon.png',
                        ),
                      ),
                    ),
                    Container(
                      height: 50,
                      margin: EdgeInsets.fromLTRB(10, 20, 0, 0),
                      color: Colors.transparent,
                      child: pathBox,
                    ),
                  ],
                ),
              ],
            ),
          ),
          actions: [
            Container(
              alignment: Alignment.center,
              margin: EdgeInsets.fromLTRB(0, 0, 0, 30),
              child: TextButton(
                style: ButtonStyle(
                  backgroundColor:
                  MaterialStateColor.resolveWith(StyleResources.commonBtnCallback),
                ),
                onPressed: () {
                  filePath = pathBoxState.getSelectedFilePath();
                },
                child: TextUtils.defaultTextWithSize("Confirm", 15),
              ),
            ),
          ],
        );
      },
    );
  }
}
