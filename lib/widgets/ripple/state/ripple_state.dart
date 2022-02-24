import 'package:flutter/animation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:utopia_hooks/utopia_hooks.dart';

import '../../../screens/game/state/game_screen_state.dart';

class RippleState {
  final AnimationController animationController;
  final double animation;
  final void Function(BuildContext context, TapDownDetails details) triggerAnimation;
  final Offset offset;

  const RippleState({
    required this.animation,
    required this.animationController,
    required this.triggerAnimation,
    required this.offset,
  });
}

RippleState useRippleState({
  required GlobalKey widgetKey,
}) {
  final animationController = useAnimationController(duration: const Duration(milliseconds: 2500));
  final animation = useAnimation(CurvedAnimation(parent: animationController, curve: Curves.easeOut));
  final offsetState = useState<Offset>(const Offset(150, 150));
  final gameState = useProvided<GameScreenState>();

  final globalToLocalOffset = (widgetKey.currentContext?.findRenderObject() as RenderBox?)?.globalToLocal;

  void triggerAnimation(BuildContext context, TapDownDetails details) async {
    offsetState.value = globalToLocalOffset!(details.globalPosition);
    await animationController.forward(from: 0.0);
    animationController.value = 0;
  }

  useSimpleEffect(() {
    WidgetsBinding.instance!.addPostFrameCallback((_) async {
      await Future.delayed(gameState.initialDuration);
      await animationController.forward();
      animationController.value = 0;
      animationController.duration = const Duration(milliseconds: 4000);
      gameState.gameController.perform?.call();
    });
  }, []);

  return RippleState(
    animationController: animationController,
    animation: animation,
    triggerAnimation: triggerAnimation,
    offset: offsetState.value,
  );
}
