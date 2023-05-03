import 'package:flutter/material.dart';

Color textBlack = Colors.black;
Color textWhite = Colors.white;
Color welcomeBackgroundColor = const Color(0xfff5f5f5);
Color didElementColor = const Color(0xffc3c3c3);
Color commonBtnColor = const Color(0xff00ff0a);
Color defaultBtnColor = const Color(0xff2196f3);
Color notSelectTextColor = const Color(0xffa1a1a1);
// Color textGrey = "#AAAAAA".toColor();
// Color blueColor = "#EDF2FF".toColor();
// Color primaryColor = const Color(0xFFF6F6F6);
// Color accentColor = "#396ADB".toColor();
// Color subTextColor = "#B3B3B3".toColor();
// Color descriptionColor = "#525252".toColor();
// Color introMainColor = "#E5EDFF".toColor();
// Color textColorDark = "#777777".toColor();
// Color greyWhite = const Color(0xFFEBEAEF);
// Color darkGrey = const Color(0xFFEBEAEF);
// Color greenButton = const Color(0xFF37BD4D);
// Color blueButton = const Color(0xFF0078FF);
// Color quickSvgColor = const Color(0xFF283182);



// getQuickWorkoutColor(int index) {
//   if (index == 0) {
//     return "#DFE6FF".toColor();
//   } else if (index == 1) {
//     return "#FFDED1".toColor();
//   } else if (index == 2) {
//     return "#FFF0D4".toColor();
//   }
// }



extension ColorExtension on String {
  toColor() {
    var hexColor = replaceAll("#", "");
    if (hexColor.length == 6) {
      hexColor = "FF$hexColor";
    }
    if (hexColor.length == 8) {
      return Color(int.parse("0x$hexColor"));
    }
  }
}
