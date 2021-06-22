import 'package:flutter/material.dart';
import 'package:todo_app/classes/todo_item.dart';

class CustomColor {
  static const black =  Color(0xFF252A31);
  static const black10 =  Color(0x1A252A31);
  static const black30 =  Color(0x4D252A31);
  static const black50 =  Color(0x80252A31);
  static const blue =  Color(0xFF006CFF);
  static const listsPurple =  Color(0xFFB678FF);
  static const listsYellow =  Color(0xFFFFE761);
  static const listsRed =  Color(0xFFF45E6D);
  static const listsGreen =  Color(0xFF61DEA4);
  static const listsGrey =  Color(0xFFEBEFF5);
}

List<Color> colorByTag(TodoItemTag tag) {
  switch(tag) {
    case TodoItemTag.Inbox:
      return [CustomColor.listsGrey, CustomColor.black];
    case TodoItemTag.Work:
      return [CustomColor.listsGreen, Colors.white];
    case TodoItemTag.Shopping:
      return [CustomColor.listsRed, Colors.white];
    case TodoItemTag.Family:
      return [CustomColor.listsYellow, CustomColor.black];
    case TodoItemTag.Personal:
      return [CustomColor.listsPurple, Colors.white];
    default:
      return [Colors.white, CustomColor.black];
  }
}