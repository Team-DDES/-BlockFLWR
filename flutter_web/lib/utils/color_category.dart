import 'package:flutter/material.dart';

Color metamaskButton = "#00FF0A".toColor();
Color textBlack = Colors.black;
Color textWhite = Colors.white;
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
