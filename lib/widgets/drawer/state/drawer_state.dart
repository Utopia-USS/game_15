import 'package:flutter/animation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:game_15/widgets/drawer/drawer.dart';
import 'package:utopia_hooks/utopia_hooks.dart';

import '../../../screens/game/state/game_screen_state.dart';

class DrawerState {
  final AnimationController animationController;
  final double animation;
  final ValueNotifier<double> offsetState;
  final void Function(double) triggerAnimation;

  const DrawerState({
    required this.animation,
    required this.animationController,
    required this.offsetState,
    required this.triggerAnimation,
  });
}

DrawerState useDrawerState() {
  final gameState = useProvided<GameScreenState>();
  final animationController = useAnimationController(duration: const Duration(milliseconds: 500), initialValue: 1);
  final animation = useAnimation(CurvedAnimation(parent: animationController, curve: Curves.easeInCubic));
  final offsetController = useState<double>(0);

  void triggerAnimation(double slideValue) {
    if (animationController.value == 0) {
      animationController.forward();
      offsetController.value = slideValue;
    } else if (animationController.value == 1) {
      animationController.reverse();
      offsetController.value = 0;
    }
  }

  useSimpleEffect(() {
    WidgetsBinding.instance!.addPostFrameCallback((_) async {
      await Future.delayed(gameState.initialDuration);
      await animationController.reverse();
      await Future.delayed(const Duration(milliseconds: 500));
      await animationController.forward();
      await Future.delayed(const Duration(milliseconds: 800));
      gameState.setGame();
    });
  }, []);

  return DrawerState(
    offsetState: offsetController,
    animationController: animationController,
    animation: animation,
    triggerAnimation: triggerAnimation,
  );
}
