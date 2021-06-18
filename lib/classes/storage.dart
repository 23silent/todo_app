import 'package:todo_app/classes/todo_item.dart';

abstract class Storage {
  List<TodoItem> getTodoItems();

  void setTodoItems(List<TodoItem> todoItems);
}
