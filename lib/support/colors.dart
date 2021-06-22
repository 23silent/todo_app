import 'package:flutter/material.dart';
import 'package:todo_app/classes/todo_item.dart';

List<Color> colorByTag(TodoItemTag tag) {
  switch(tag) {
    case TodoItemTag.Inbox:
      return [Colors.black12, Colors.black87];
    case TodoItemTag.Work:
      return [Colors.greenAccent, Colors.white];
    case TodoItemTag.Shopping:
      return [Colors.redAccent, Colors.white];
    case TodoItemTag.Family:
      return [Colors.yellowAccent, Colors.black87];
    case TodoItemTag.Personal:
      return [Colors.purpleAccent, Colors.white];
    default:
      return [Colors.white, Colors.black87];
  }
}