import 'package:flutter/material.dart';

class TextUtils{
  static Widget defaultTextWithSize(String content, double size){
    return Text(content,
      style: TextStyle(
        decoration: TextDecoration.none,
        fontSize: size,
        color: Colors.black,
      ),
    );
  }

  static Widget defaultTextWithSizeColor(String content, double size, {required Color color}){
    return Text(content,
      style: TextStyle(
        decoration: TextDecoration.none,
        fontSize: size,
        color: color,
      ),
    );
  }
}