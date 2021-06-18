import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
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
    return Scaffold(
      appBar: AppBar(
        title: Text('Todo list'),
        centerTitle: true,
      ),
      body: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        TextButton(
            onPressed: () {
              showDatePicker(
                context: context,
                initialDate: dt,
                firstDate: DateTime.now(),
                lastDate: DateTime.now().add(Duration(days: 100)),
              ).then((date) {
                setState(() {
                  if (date != null) {
                    dt = date;
                  }
                });
              });
            },
            child: Text('Todos for ${formatDt(dt, 'dd MMM')}')),
        Expanded(
          child: TodoItemsListComponent(
            todoItems: context.watch<TodoItemModel>().getTodoItemsByDate(dt),
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
          ),
        ),
      ]),
      floatingActionButton: FloatingActionButton(
        key: const Key('increment_floatingActionButton'),
        onPressed: () => Navigator.pushNamed(context, '/edit'),
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
