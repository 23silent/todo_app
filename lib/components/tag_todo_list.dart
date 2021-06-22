import 'package:flutter/material.dart';
import 'package:todo_app/classes/todo_item.dart';
import 'package:todo_app/support/colors.dart';
import 'package:todo_app/utils/format.dart';

class TagTodoList extends StatelessWidget {
  final List<TodoItem> items;
  final TodoItemTag tag;
  final Widget Function(ScrollController controller) child;

  TagTodoList(
      {Key? key, required this.items, required this.tag, required this.child})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: DraggableScrollableSheet(
        // minChildSize: 0.1,
        maxChildSize: 0.9,
        initialChildSize: 0.6,
        builder: (BuildContext context, ScrollController scrollController) {
          return Container(
            decoration: BoxDecoration(
                color: colorByTag(tag)[0],
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20.0),
                  topRight: Radius.circular(20.0),
                )),
            child: Column(
              children: [
                Container(
                  width: 37,
                  height: 5,
                  margin: EdgeInsets.symmetric(vertical: 5),
                  decoration: BoxDecoration(
                    color: Colors.black38,
                    borderRadius: BorderRadius.all(Radius.circular(3.0)),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 60, top: 16, bottom: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        tag.toString().split('.').last,
                        style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: colorByTag(tag)[1]),
                      ),
                      Text(
                        maybePluralize(items.length, 'task'),
                        style:
                            TextStyle(fontSize: 16, color: CustomColor.black50),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: child(scrollController),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
