import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/classes/todo_item.dart';
import 'package:todo_app/components/tag_list.dart';

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
              'Todo list',
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 32,
                  fontWeight: FontWeight.bold),
            )),
        actions: [
          IconButton(
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
                Icons.menu_rounded,
                color: Colors.black,
              ))
        ],
      ),
      body: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        Expanded(
          child: TodoItemsListComponent(
            todoItems: todoItems,
            onRemovePressed: (int id) =>
                context.read<TodoItemModel>().remove(id),
            onEditPressed: (int id) =>
                Navigator.pushNamed(context, '/edit', arguments: {'id': id}),
            onShowItemPressed: (int id) =>
                Navigator.pushNamed(context, '/item', arguments: {'id': id}),
            onDonePressed: (int id) {
              showDialog(
                  context: context,
                  builder: (BuildContext context) => AlertDialog(
                        title: Text('is done?'),
                        content: const Text(''),
                        actions: <Widget>[
                          ElevatedButton(
                            child: Text('Yep'),
                            onPressed: () {
                              Navigator.of(context).pop(true);
                            },
                          ),
                          ElevatedButton(
                            child: Text('Nop'),
                            onPressed: () {
                              Navigator.of(context).pop(false);
                            },
                          ),
                        ],
                      )).then((value) {
                context.read<TodoItemModel>().setIsDone(id, value);
              });
            },
            footer: Padding(
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
                onTagPressed: (TodoItemTag tag) {},
              ),
            ),
          ),
        ),
      ]),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.pushNamed(context, '/edit'),
        backgroundColor: Colors.white,
        child: const Icon(Icons.add, color: Colors.blueAccent, size: 32),
      ),
    );
  }
}
