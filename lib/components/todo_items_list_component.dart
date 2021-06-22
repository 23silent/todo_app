import 'package:flutter/material.dart';
import 'package:todo_app/support/colors.dart';
import 'package:todo_app/utils/date.dart';

import '/components/slide_menu.dart';
import '/classes/todo_item.dart';
import 'done_circle_button.dart';

class TodoItemsListComponent extends StatelessWidget {
  final List<TodoItem> todoItems;
  final Function(int id) onRemovePressed;
  final Function(int id) onEditPressed;
  final Function(int id) onDonePressed;
  final Function(int id) onShowItemPressed;
  final Widget? footer;

  TodoItemsListComponent({
    required this.todoItems,
    required this.onRemovePressed,
    required this.onEditPressed,
    required this.onDonePressed,
    required this.onShowItemPressed,
    this.footer,
  });

  @override
  Widget build(BuildContext context) {
    List<TodoItem> todoItems =
        this.todoItems.where((e) => e.removed != true).toList();
    return ListView(
      children: [
        ...todoItems.map((item) {
          return Container(
              padding: EdgeInsets.only(left: 16),
              child: SlideMenu(
                child: Container(
                  height: 60,
                  alignment: Alignment.centerLeft,
                  child: Row(
                    children: [
                      DoneCircleButton(
                        isDone: item.isDone,
                        onPressed: () => onDonePressed(item.id),
                      ),
                      SizedBox(
                        width: 16,
                      ),
                      Expanded(
                        child: Container(
                            alignment: Alignment.centerLeft,
                            decoration: BoxDecoration(
                              border: Border(
                                bottom:
                                    BorderSide(width: 1, color: Colors.black26),
                              ),
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Opacity(
                                      opacity: item.isDone ? 0.2 : 1,
                                      child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              item.text,
                                              style: TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.w500),
                                            ),
                                            Padding(
                                              padding: EdgeInsets.only(top: 5),
                                              child: Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  Icon(Icons.alarm,
                                                      color: Colors.black38,
                                                      size: 16),
                                                  SizedBox(width: 4),
                                                  Text(
                                                    formatTime(item.dt)
                                                        .toLowerCase(),
                                                    style: TextStyle(
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        color: Colors.black38),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ])),
                                ),
                                if (item.tag != null)
                                  Container(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 16),
                                    child: Container(
                                      width: 12,
                                      height: 12,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: colorByTag(item.tag!)[0],
                                      ),
                                    ),
                                  ),
                              ],
                            )),
                      ),
                    ],
                  ),
                  // onTap: () => onShowItemPressed(item.id),
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
                        icon: Icon(Icons.edit),
                        onPressed: () {
                          defaultOnPressed();
                          onEditPressed(item.id);
                        },
                      ),
                    ),
                  ];
                },
              ));
        }).toList(),
        if (footer != null) footer!,
      ],
    );
  }
}
