import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:game_15/widgets/drawer/drawer.dart';

class DrawerGestureWrapper extends StatelessWidget {
  final ValueNotifier<double> offsetController;
  final AnimationController animationController;
  final Widget child;
  final double slideValue;

  const DrawerGestureWrapper({
    Key? key,
    required this.offsetController,
    required this.animationController,
    required this.child,
    required this.slideValue,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      dragStartBehavior: DragStartBehavior.start,
      onTap: () => animationController.isDismissed ? animationController.forward() : animationController.reverse(),
      onHorizontalDragUpdate: (details) {
        offsetController.value += details.delta.dx;
        animationController.value = offsetController.value / slideValue;
      },
      onHorizontalDragEnd: (details) {
        final velocity = details.velocity.pixelsPerSecond.dx;
        if (velocity > 1000) {
          animationController.forward();
          offsetController.value = slideValue;
        } else if (velocity < -1000) {
          animationController.reverse();
          offsetController.value = 0;
        } else if (offsetController.value < slideValue / 2) {
          animationController.reverse();
          offsetController.value = 0;
        } else if (offsetController.value > slideValue / 2) {
          animationController.forward();
          offsetController.value = slideValue;
        }
      },
      child: child,
    );
  }
}
