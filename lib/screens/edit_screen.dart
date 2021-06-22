import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/components/done_circle_button.dart';
import 'package:todo_app/components/tag_list.dart';
import 'package:todo_app/support/colors.dart';

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
  List<TodoItem> todoItems = List<TodoItem>.empty();
  TodoItem? todoItem;
  DateTime dt = DateTime.now();
  bool isNotificationScheduled = false;
  TodoItemTag? tag;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      final args = ModalRoute.of(context)!.settings.arguments;
      if (args != null) {
        final item = context.read<TodoItemModel>().getItem((args as Map)['id']);

        setState(() {
          todoItems = context.read<TodoItemModel>().todoItems;
          todoItem = item;
          dt = item.dt;
          isNotificationScheduled = item.isNotificationScheduled;
          tag = item.tag;
        });

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
      backgroundColor: Colors.white,
      appBar: AppBar(
        // title: Text('Todo edit'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        leadingWidth: 70,
        leading: TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text('Cancel'),
        ),
        actions: [
          TextButton(
            onPressed: () => _onSubmitPressed(context),
            child: Text('Done'),
          )
        ],
      ),
      body: ListView(
        children: [
          Padding(
            padding: EdgeInsets.only(top: 20, left: 20, right: 20),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(top: 8, right: 10),
                        child:
                            DoneCircleButton(isDone: false, onPressed: () {}),
                      ),
                      Expanded(
                        child: TextField(
                          decoration: InputDecoration(
                            hintText: 'Enter text',
                            border: InputBorder.none,
                            // border: OutlineInputBorder(),
                          ),
                          controller: _textController,
                          maxLines: 3,
                          minLines: 1,
                        ),
                      ),
                      if (tag != null)
                        Container(
                          padding: EdgeInsets.only(top: 16),
                          child: Container(
                            width: 12,
                            height: 12,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: colorByTag(tag!)[0],
                            ),
                          ),
                        ),
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.only(bottom: 40, left: 36),
                    child: Row(
                      children: [
                        Row(children: [
                          Icon(
                            Icons.calendar_today,
                            color: Colors.black38,
                            size: 16,
                          ),
                          SizedBox(width: 5),
                          Text(formatDt(dt, 'dd MMM'),
                              style: TextStyle(color: Colors.black38)),
                        ]),
                        SizedBox(width: 10),
                        if (dt.hour != 0 && dt.minute != 0)
                          Row(
                            children: [
                              Icon(
                                Icons.alarm,
                                color: Colors.black38,
                                size: 16,
                              ),
                              SizedBox(width: 5),
                              Text(
                                formatTime(dt),
                                style: TextStyle(color: Colors.black38),
                              ),
                            ],
                          ),
                      ],
                    ),
                  ),
                ]),
          ),
          Divider(color: Colors.black, height: 0),
          Padding(
            padding: EdgeInsets.only(left: 20, right: 20, bottom: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    IconButton(
                      icon: Icon(
                        Icons.calendar_today,
                        color: Colors.blueAccent,
                      ),
                      onPressed: () {
                        showDatePicker(
                          context: context,
                          initialDate: dt,
                          firstDate: DateTime.now(),
                          lastDate: DateTime.now().add(Duration(days: 100)),
                        ).then((date) {
                          if (date != null) {
                            setState(() {
                              dt = DateTime(
                                date.year,
                                date.month,
                                date.day,
                                0,
                                0,
                              );
                            });
                          }
                        });
                      },
                    ),
                    IconButton(
                      icon: Icon(
                        Icons.alarm,
                        color: Colors.blueAccent,
                      ),
                      onPressed: () {
                        showTimePicker(
                          context: context,
                          initialTime: TimeOfDay.now(),
                        ).then((time) {
                          if (time != null) {
                            setState(() {
                              dt = DateTime(
                                dt.year,
                                dt.month,
                                dt.day,
                                time.hour,
                                time.minute,
                              );
                            });
                          }
                        });
                      },
                    ),
                    if (dt.hour != 0 && dt.minute != 0)
                      Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text('Remind'),
                            Switch(
                                value: isNotificationScheduled,
                                onChanged: (value) {
                                  setState(() {
                                    isNotificationScheduled = value;
                                  });
                                })
                          ],
                        ),
                      ),
                  ],
                ),
                SizedBox(height: 20),
                TagList(
                  todoItems: todoItems,
                  onTagPressed: (TodoItemTag tag) {
                    setState(() {
                      this.tag = tag;
                    });
                  },
                  selectedTag: tag,
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  _onSubmitPressed(BuildContext context) {
    if (todoItem != null) {
      context.read<TodoItemModel>().edit(
          todoItem!.id,
          _titleController.text,
          _textController.text,
          dt,
          tag,
          todoItem!.isDone,
          isNotificationScheduled);
    } else {
      context.read<TodoItemModel>().add(
          _titleController.text,
          _textController.text,
          dt,
          TodoItemTag.Family,
          isNotificationScheduled);
    }
    Navigator.pop(context);
  }
}
