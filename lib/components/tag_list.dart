import 'package:flutter/material.dart';
import 'package:todo_app/classes/todo_item.dart';
import 'package:todo_app/components/tag_button.dart';

class TagList extends StatelessWidget {
  final List<TodoItem> todoItems;
  final Widget? title;
  final Function(TodoItemTag tag) onTagPressed;
  final TodoItemTag? selectedTag;

  TagList({required this.todoItems, required this.onTagPressed, this.title, this.selectedTag});

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
      if (title != null) title!,
      ...TodoItemTag.values
          .map((e) => TagButton(
        tag: e,
        count: todoItems.where((item) => item.tag == e).length,
        onPressed: () => onTagPressed(e),
        showIconChecked: selectedTag != null ? selectedTag == e : false,
      ))
          .toList()
    ]);
  }
}
