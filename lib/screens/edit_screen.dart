import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '/classes/todo_item.dart';
import '/utils/date.dart';
import '/models/todo_item.dart';

class EditScreen extends StatefulWidget {
  @override
  _EditScreenState createState() => _EditScreenState();
}

class _EditScreenState extends State<EditScreen> {
  final _titleController = TextEditingController();
  final _textController = TextEditingController();
  TodoItem? todoItem;
  DateTime dt = DateTime.now();
  bool isNotificationScheduled = false;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      final args = ModalRoute.of(context)!.settings.arguments;
      if (args != null) {
        final item = context.read<TodoItemModel>().getItem((args as Map)['id']);

        setState(() {
          todoItem = item;
          dt = item.dt;
          isNotificationScheduled = item.isNotificationScheduled;
        });

        _titleController.text = item.title;
        _textController.text = item.text;
      }
    });
  }

  @override
  void dispose() {
    _titleController.dispose();
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Todo edit'),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              decoration: InputDecoration(
                  border: OutlineInputBorder(), hintText: 'Enter title'),
              controller: _titleController,
            ),
            SizedBox(
              height: 20,
            ),
            TextField(
              decoration: InputDecoration(
                  border: OutlineInputBorder(), hintText: 'Enter text'),
              controller: _textController,
              maxLines: 10,
              minLines: 5,
            ),
            SizedBox(
              height: 20,
            ),
            SizedBox(
                height: 50,
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(width: 1, color: Colors.black38),
                    borderRadius: BorderRadius.all(Radius.circular(5)),
                  ),
                  child: TextButton(
                    onPressed: () {
                      showDatePicker(
                        context: context,
                        initialDate: dt,
                        firstDate: DateTime.now(),
                        lastDate: DateTime.now().add(Duration(days: 100)),
                      ).then((date) {
                        if (date != null) {
                          showTimePicker(
                            context: context,
                            initialTime: TimeOfDay.now(),
                          ).then((time) {
                            if (time != null) {
                              setState(() {
                                dt = DateTime(
                                  date.year,
                                  date.month,
                                  date.day,
                                  time.hour,
                                  time.minute,
                                );
                              });
                            }
                          });
                        }
                      });
                    },
                    child: Text('${formatDt(dt, null)}'),
                  ),
                )),
            SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Show notification'),
                Switch(value: isNotificationScheduled, onChanged: (value) {
                  setState(() {
                    isNotificationScheduled = value;
                  });
                })
              ],
            ),
            SizedBox(
              height: 20,
            ),
            ElevatedButton(
              onPressed: () => _onSubmitPressed(context),
              child: Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }

  _onSubmitPressed(BuildContext context) {
    if (todoItem != null) {
      context.read<TodoItemModel>().edit(todoItem!.id, _titleController.text,
          _textController.text, dt, todoItem!.isDone, isNotificationScheduled);
    } else {
      context
          .read<TodoItemModel>()
          .add(_titleController.text, _textController.text, dt, isNotificationScheduled);
    }
    Navigator.pop(context);
  }
}
