import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '/utils/date.dart';
import '/models/todo_item.dart';

class ItemScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as Map;
    final item = context.read<TodoItemModel>().getItem(args['id']);
    return Scaffold(
      appBar: AppBar(
        title: Text('Todo item'),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              item.title,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Text(item.text),
            Text(formatDt(item.dt, null)),
          ],
        ),
      ),
    );
  }
}
