import 'package:flutter/material.dart';
import 'package:todo_app/classes/todo_item.dart';
import 'package:todo_app/support/colors.dart';
import 'package:todo_app/utils/format.dart';

class TagButton extends StatelessWidget {
  final int count;
  final TodoItemTag tag;
  final VoidCallback onPressed;
  final bool showIconChecked;

  TagButton({required this.count, required this.tag, required this.onPressed, this.showIconChecked = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 69,
      margin: EdgeInsets.only(bottom: 8),
      child: ElevatedButton(
        style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(colorByTag(tag)[0]),
            elevation: MaterialStateProperty.all(0),
            shape: MaterialStateProperty.all(RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10)))),
        onPressed: onPressed,
        child: Row(
          children: [
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(tag.toString().split('.').last,
                      style: TextStyle(
                        color: colorByTag(tag)[1],
                        fontSize: 19,
                        fontWeight: FontWeight.w500,
                      )),
                  Text(maybePluralize(count, 'task'),
                      style: TextStyle(
                        color: CustomColor.black50,
                        fontSize: 14,
                      )),
                ],
              ),
            ),
            if (showIconChecked) Container(
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
              ),
              child: IconButton(
                padding: EdgeInsets.zero,
                onPressed: onPressed,
                icon: Icon(
                  Icons.done,
                  color: Colors.lightBlueAccent,
                  size: 18,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
