import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/classes/todo_item.dart';
import 'package:todo_app/components/tag_list.dart';
import 'package:todo_app/components/tag_todo_list.dart';
import 'package:todo_app/support/colors.dart';
import 'package:todo_app/utils/date.dart';

import '/components/todo_items_list_component.dart';
import '/models/todo_item.dart';

class ListScreen extends StatefulWidget {
  @override
  _ListScreen createState() => _ListScreen();
}

class _ListScreen extends State<ListScreen> {
  DateTime dt = DateTime.now();

  @override
  Widget build(BuildContext context) {
    List<TodoItem> todoItems =
        context.watch<TodoItemModel>().getTodoItemsByDate(dt);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Padding(
            padding: EdgeInsets.only(left: 44, top: 16),
            child: Text(
              formatDt(dt, 'MMM dd'),
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 32,
                  fontWeight: FontWeight.bold),
            )),
        actions: [
          IconButton(
              color: CustomColor.blue,
              iconSize: 32,
              padding: EdgeInsets.only(top: 15, right: 10),
              onPressed: () {
                showDatePicker(
                  context: context,
                  initialDate: dt,
                  firstDate: dt.subtract(Duration(days: 100)),
                  lastDate: dt.add(Duration(days: 100)),
                ).then((date) {
                  setState(() {
                    if (date != null) {
                      dt = date;
                    }
                  });
                });
              },
              icon: Icon(
                Icons.more_horiz,
              ))
        ],
      ),
      body: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        Expanded(
          child: todoItemsWidget(
            context,
            todoItems,
            Padding(
              padding: EdgeInsets.only(left: 60, right: 16, top: 32),
              child: TagList(
                todoItems: todoItems,
                title: Padding(
                  padding: EdgeInsets.only(bottom: 15),
                  child: Text(
                    'List',
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black26),
                  ),
                ),
                onTagPressed: (TodoItemTag tag) => showModal(context, tag),
              ),
            ),
            null,
          ),
        ),
      ]),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.pushNamed(context, '/edit'),
        backgroundColor: Colors.white,
        child: const Icon(Icons.add, color: CustomColor.blue, size: 32),
      ),
    );
  }

  Widget todoItemsWidget(BuildContext context, List<TodoItem> items,
          Widget? footer, ScrollController? controller) =>
      TodoItemsListComponent(
        todoItems: items,
        onRemovePressed: (int id) => showDeleteConfirmDialog(context, id),
        onEditPressed: (int id) =>
            Navigator.pushNamed(context, '/edit', arguments: {'id': id}),
        onShowItemPressed: (int id) =>
            Navigator.pushNamed(context, '/item', arguments: {'id': id}),
        onDonePressed: (int id) {
          TodoItem item = context.read<TodoItemModel>().getItem(id);
          context.read<TodoItemModel>().setIsDone(id, !item.isDone);
        },
        footer: footer,
        controller: controller,
      );

  void showDeleteConfirmDialog(BuildContext context, int id) {
    showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
              title: Text('Are you sure?'),
              content: const Text(''),
              actions: <Widget>[
                ElevatedButton(
                  child: Text('Yep'),
                  onPressed: () {
                    context.read<TodoItemModel>().remove(id);
                    Navigator.of(context).pop();
                  },
                ),
                ElevatedButton(
                  child: Text('Nop'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ));
  }

  void showModal(BuildContext context, TodoItemTag tag) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      isDismissible: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        List<TodoItem> items = context
            .watch<TodoItemModel>()
            .todoItems
            .where((item) => tag == item.tag)
            .toList();
        return TagTodoList(
            items: items,
            tag: tag,
            child: (ScrollController controller) =>
                todoItemsWidget(context, items, null, controller));
      },
    );
  }
}
