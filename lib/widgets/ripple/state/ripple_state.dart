import 'package:flutter/animation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:game_15/widgets/drawer/drawer.dart';

class RippleState {
  final AnimationController animationController;
  final double animation;
  final void Function() triggerAnimation;
  final Offset Function(Offset)? globalToLocalOffset;

  const RippleState({
    required this.animation,
    required this.animationController,
    required this.triggerAnimation,
    required this.globalToLocalOffset,
  });
}

RippleState useRippleState({
  required GlobalKey widgetKey,
}) {
  final animationController = useAnimationController(duration: const Duration(milliseconds: 300));
  final animation = useAnimation(CurvedAnimation(parent: animationController, curve: Curves.easeInCubic));

  void triggerAnimation()  {
    animationController.forward();
  }

  return RippleState(
    animationController: animationController,
    animation: animation,
    triggerAnimation: triggerAnimation,
    globalToLocalOffset: (widgetKey.currentContext?.findRenderObject() as RenderBox?)?.globalToLocal,
  );
}
