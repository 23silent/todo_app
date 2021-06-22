import 'package:flutter/material.dart';

import '/classes/todo_item.dart';
import '/classes/storage.dart';
import '/services/notification_service.dart';

class TodoItemModel with ChangeNotifier {
  Storage storageService;
  NotificationService notificationService;

  TodoItemModel(
      {required this.storageService, required this.notificationService});

  List<TodoItem> _todoItems = [];

  List<TodoItem> get todoItems => _todoItems;

  TodoItem getItem(int id) => _todoItems.firstWhere((item) => item.id == id);

  List<TodoItem> getTodoItemsByDate(DateTime dt) {
    var items =
        _todoItems.where((item) => dt.difference(item.dt).inDays == 0).toList();
    return items;
  }

  void init() {
    this._todoItems = this.storageService.getTodoItems();
  }

  void add(
      String title, String text, DateTime dt, TodoItemTag? tag, bool isNotificationScheduled) {
    int id = _todoItems.length == 0 ? 0 : _todoItems.last.id + 1;
    TodoItem newItem = TodoItem(
        id: id,
        createdDt: DateTime.now(),
        dt: dt,
        tag: tag,
        isDone: false,
        isNotificationScheduled: isNotificationScheduled,
        text: text);
    _todoItems = [..._todoItems, newItem];

    if (isNotificationScheduled) {
      _scheduleNotification(newItem);
    } else {
      _unScheduleNotification(id);
    }

    _toStorage();
    notifyListeners();
  }

  void remove(int id) {
    _todoItems = _todoItems
        .map((e) => e.id == id
            ? TodoItem(
                id: id,
                text: e.text,
                createdDt: e.createdDt,
                dt: e.dt,
                tag: e.tag,
                isDone: e.isDone,
                isNotificationScheduled: e.isNotificationScheduled,
                removed: true)
            : e)
        .toList();
    _unScheduleNotification(id);
    _toStorage();
    notifyListeners();
  }

  void edit(int id, String title, String text, DateTime dt, TodoItemTag? tag, bool isDone,
      bool isNotificationScheduled) {
    TodoItem toUpdate = _todoItems.firstWhere((element) => element.id == id);
    TodoItem updated = TodoItem(
        id: id,
        text: text,
        createdDt: toUpdate.createdDt,
        dt: dt,
        tag: tag,
        isDone: isDone,
        removed: toUpdate.removed,
        isNotificationScheduled: isNotificationScheduled);
    _todoItems = _todoItems.map((e) => e.id == id ? updated : e).toList();
    _toStorage();
    if (isNotificationScheduled) {
      _scheduleNotification(updated);
    } else {
      _unScheduleNotification(id);
    }
    notifyListeners();
  }

  void setIsDone(int id, bool? isDone) {
    _todoItems = _todoItems
        .map((e) => e.id == id
            ? TodoItem(
                id: e.id,
                text: e.text,
                createdDt: e.createdDt,
                dt: e.dt,
                tag: e.tag,
                isDone: isDone != null ? isDone : !e.isDone,
                isNotificationScheduled: e.isNotificationScheduled,
                removed: e.removed)
            : e)
        .toList();
    _unScheduleNotification(id);
    _toStorage();
    notifyListeners();
  }

  void _toStorage() {
    storageService.setTodoItems(_todoItems);
  }

  void _scheduleNotification(TodoItem item) {
    notificationService.zonedScheduleNotification(item.id, 'Scheduled notif',
        item.text, item.id.toString(), item.dt.subtract(Duration(minutes: 15)));
  }

  void _unScheduleNotification(int id) {
    notificationService.cancelNotification(id);
  }
}
