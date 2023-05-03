import 'package:flutter/material.dart';

import 'color_category.dart';

class StyleResources{
  static BoxShadow defaultBoxShadow = BoxShadow(
      color: Colors.grey.withOpacity(0.7),
      blurRadius: 20.0,
      offset: const Offset(1, 1)
  );

  static MaterialPropertyResolver<Color> createBtnCallback = (states) {
    if(states.contains(MaterialState.hovered)){
      return defaultBtnColor;
    }else{
      return commonBtnColor;
    }
  };
}