import 'package:flutter/material.dart';

import 'color_category.dart';

class StyleResources {
  static BoxShadow defaultBoxShadow = BoxShadow(
      color: Colors.grey.withOpacity(0.7),
      blurRadius: 20.0,
      offset: const Offset(1, 1));

  static MaterialPropertyResolver<Color> createBtnCallback = (states) {
    if (states.contains(MaterialState.hovered)) {
      return defaultBtnColor;
    } else {
      return commonBtnColor;
    }
  };

  static MaterialPropertyResolver<Color> pagerBtnCallback = (states) {
    if (states.contains(MaterialState.focused)) {
      return defaultBtnColor;
    }

    if (!states.contains(MaterialState.focused)) {
      if (states.contains(MaterialState.hovered)) {
        return notSelectTextColor;
      }
      return Colors.transparent;
    }
    return Colors.transparent;
  };

  static TextStyle pagerTextBtnNormalStyle = TextStyle(
    fontSize: 15,
    color: textBlack,
  );
  static TextStyle pagerTextBtnHoverStyle = TextStyle(
    fontSize: 20,
    color: defaultBtnColor,
  );

  static ButtonStyle pagerBtnStyle = ButtonStyle(
      backgroundColor: MaterialStateColor.resolveWith(pagerBtnCallback),
      shadowColor: MaterialStateColor.resolveWith(pagerBtnCallback),
      overlayColor: MaterialStateColor.resolveWith(pagerBtnCallback));

  static ButtonStyle pagerNormalBtnStyle = ElevatedButton.styleFrom(
    backgroundColor: Colors.transparent,
    shadowColor: Colors.transparent,
  );
  static ButtonStyle pagerSelectBtnStyle = ElevatedButton.styleFrom(
    backgroundColor: defaultBtnColor,
    shadowColor: Colors.transparent,
  );
}
