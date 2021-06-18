import 'package:flutter/material.dart';

class SlideMenu extends StatefulWidget {
  final Widget child;

  final List<Widget> Function(VoidCallback defaultOnPressed) menuItems;

  SlideMenu({required this.child, required this.menuItems});

  @override
  _SlideMenuState createState() => _SlideMenuState();
}

class _SlideMenuState extends State<SlideMenu>
    with SingleTickerProviderStateMixin {
  AnimationController? _controller;

  @override
  initState() {
    super.initState();
    _controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 200));
  }

  @override
  dispose() {
    _controller!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    AnimationController controller = _controller!;
    final animation = Tween(begin: Offset(0.0, 0.0), end: Offset(-0.3, 0.0))
        .animate(CurveTween(curve: Curves.decelerate).animate(controller));

    return GestureDetector(
      onHorizontalDragUpdate: (data) {
        // we can access context.size here
        setState(() {
          controller.value -= data.primaryDelta! / context.size!.width;
        });
      },
      onHorizontalDragEnd: (data) {
        if (data.primaryVelocity! > 300)
          controller
              .animateTo(.0); //close menu on fast swipe in the right direction
        else if (controller.value >= .5 ||
            data.primaryVelocity! <
                -300) // fully open if dragged a lot to left or on fast swipe to left
          controller.animateTo(1.0);
        else // close if none of above
          controller.animateTo(.0);
      },
      child: Stack(
        children: <Widget>[
          SlideTransition(position: animation, child: widget.child),
          Positioned.fill(
            child: LayoutBuilder(
              builder: (context, constraint) {
                return AnimatedBuilder(
                  animation: controller,
                  builder: (context, child) {
                    return Stack(
                      children: <Widget>[
                        Positioned(
                          right: .0,
                          top: .0,
                          bottom: .0,
                          width: constraint.maxWidth * animation.value.dx * -1,
                          child: Container(
                            color: Colors.black26,
                            child: Row(
                              children: widget
                                  .menuItems(() {
                                    controller.animateTo(.0);
                                  })
                                  .map((w) => Expanded(child: w))
                                  .toList(),
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                );
              },
            ),
          )
        ],
      ),
    );
  }
}
