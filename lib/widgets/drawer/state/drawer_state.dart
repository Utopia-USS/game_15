import 'package:flutter/animation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:game_15/widgets/drawer/drawer.dart';

class DrawerState {
  final AnimationController animationController;
  final double animation;
  final ValueNotifier<double> offsetState;
  final void Function() triggerAnimation;

  const DrawerState({
    required this.animation,
    required this.animationController,
    required this.offsetState,
    required this.triggerAnimation,
  });
}

DrawerState useDrawerState() {
  final animationController = useAnimationController(duration: const Duration(milliseconds: 300));
  final animation = useAnimation(CurvedAnimation(parent: animationController, curve: Curves.easeInCubic));
  final offsetController = useState<double>(0);


  void triggerAnimation()  {
    if (animationController.value == 0) {
      animationController.forward();
      offsetController.value = DrawerWidget.slideValue;
    } else if (animationController.value == 1) {
      animationController.reverse();
      offsetController.value = 0;
    }
  }

  return DrawerState(
    offsetState: offsetController,
    animationController: animationController,
    animation: animation,
    triggerAnimation: triggerAnimation,
  );
}
