import 'package:flutter/material.dart';

class DoneCircleButton extends StatelessWidget {
  final bool isDone;
  final VoidCallback onPressed;

  DoneCircleButton({required this.isDone, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 28,
      height: 28,
      decoration: isDone
          ? BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.lightBlueAccent,
              border: Border.all(width: 2, color: Colors.lightBlueAccent),
            )
          : BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
              border: Border.all(width: 2, color: Colors.black26),
            ),
      child: IconButton(
        padding: EdgeInsets.zero,
        onPressed: onPressed,
        icon: Icon(
          Icons.done,
          color: Colors.white,
          size: 18,
        ),
      ),
    );
  }
}
