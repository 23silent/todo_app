import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '/classes/todo_item.dart';
import '/classes/storage.dart';

class StorageService implements Storage {
  SharedPreferences prefs;

  StorageService({required this.prefs});

  static init() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // await prefs.clear();
    return StorageService(prefs: prefs);
  }

  @override
  getTodoItems() {
    var fromStorage = prefs.getStringList('todoItems');

    return fromStorage != null
        ? fromStorage.map((e) => TodoItem.fromJson(jsonDecode(e))).toList()
        : List<TodoItem>.empty();
  }

  @override
  void setTodoItems(List<TodoItem> todoItems) {
    prefs.setStringList(
        'todoItems', todoItems.map((e) => jsonEncode(e.toJson())).toList());
  }
}
