import 'package:flutter/material.dart';

import '/components/slide_menu.dart';
import '/classes/todo_item.dart';

class TodoItemsListComponent extends StatelessWidget {
  final List<TodoItem> todoItems;
  final Function(int id) onRemovePressed;
  final Function(int id) onEditPressed;
  final Function(int id) onDonePressed;
  final Function(int id) onShowItemPressed;

  TodoItemsListComponent(
      {required this.todoItems,
      required this.onRemovePressed,
      required this.onEditPressed,
      required this.onDonePressed,
      required this.onShowItemPressed});

  @override
  Widget build(BuildContext context) {
    List<TodoItem> todoItems =
        this.todoItems.where((e) => e.removed != true).toList();
    return ListView(
      children: ListTile.divideTiles(
        context: context,
        tiles: todoItems.map((item) {
          return SlideMenu(
            child: ListTile(
              title: Row(
                children: [
                  SizedBox(
                    child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.lightBlueAccent,
                        border:
                            Border.all(width: 1, color: Colors.lightBlueAccent),
                      ),
                      child: Icon(
                        Icons.done,
                        color: Colors.white,
                        size: 18,
                      ),
                    ),
                    width: 28,
                    height: 28,
                  ),
                  SizedBox(
                    width: 16,
                  ),
                  Container(child: Text(item.text, style: TextStyle(fontSize: 18),)),
                ],
              ),
              onTap: () => onShowItemPressed(item.id),
            ),
            menuItems: (VoidCallback defaultOnPressed) {
              return [
                Container(
                  child: IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () {
                      defaultOnPressed();
                      onRemovePressed(item.id);
                    },
                  ),
                ),
                Container(
                  child: IconButton(
                    icon: Icon(Icons.done),
                    onPressed: () {
                      defaultOnPressed();
                      onDonePressed(item.id);
                    },
                  ),
                ),
                Container(
                  child: IconButton(
                    icon: Icon(Icons.edit),
                    onPressed: () {
                      defaultOnPressed();
                      onEditPressed(item.id);
                    },
                  ),
                ),
              ];
            },
          );
        }),
      ).toList(),
    );
  }
}
