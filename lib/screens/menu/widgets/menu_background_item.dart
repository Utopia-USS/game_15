import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:utopia_widgets/layout/overflow_transform_box.dart';

class MenuBackgroundItem extends HookWidget {
  final double initialOffsetX;
  final double initialOffsetY;
  final double intervalStart;
  final double intervalEnd;
  final Color gradientBegin;
  final Color gradientEnd;
  final Animation<double> animation;

  const MenuBackgroundItem({
    Key? key,
    required this.intervalStart,
    required this.intervalEnd,
    required this.gradientBegin,
    required this.gradientEnd,
    required this.animation,
    this.initialOffsetX = 0,
    this.initialOffsetY = 0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final curvedAnimation = useCurvedAnimation();
    return Expanded(
      child: OverflowTransformBox(
        alignment: Alignment.bottomCenter,
        transform: (constraints) => BoxConstraints.tightFor(
          width: constraints.maxWidth,
          height: constraints.maxHeight + 1, // workaround: avoid artifacts between items
        ),
        child: SlideTransition(
          position: Tween<Offset>(
            begin: Offset(initialOffsetX, initialOffsetY),
            end: const Offset(0, 0),
          ).animate(curvedAnimation),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular((1 - curvedAnimation.value) * 20),
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  gradientBegin,
                  gradientEnd,
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  CurvedAnimation useCurvedAnimation() {
    return useMemoized(
      () => CurvedAnimation(
        curve: Interval(
          intervalStart,
          intervalEnd,
          curve: Curves.easeOutCubic,
        ),
        parent: animation,
      ),
    );
  }
}
