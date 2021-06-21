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
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(200),
        child: AppBar(
          iconTheme: IconThemeData(
            color: Colors.black, //change your color here
          ),
          title: Text(
            'Todo list',
            style: TextStyle(color: Colors.black),
          ),
          centerTitle: true,
          flexibleSpace: SizedBox(
            child: Opacity(
                opacity: .4,
                child:
                    Image.asset('assets/images/cover.png', fit: BoxFit.cover)),
          ),
        ),
      ),
      body: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        TextButton(
            onPressed: () {
              showDatePicker(
                context: context,
                initialDate: dt.subtract(Duration(days: 100)),
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
