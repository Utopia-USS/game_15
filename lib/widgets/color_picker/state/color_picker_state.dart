import 'package:flutter/material.dart';
import 'package:game_15/model/item_color.dart';
import 'package:game_15/screens/game/state/game_screen_state.dart';
import 'package:utopia_hooks/utopia_hooks.dart';

class ColorPickerState {
  final AnimationController animationController;
  final PageController pageController;

  final ItemColor? foregroundColor;
  final ItemColor backgroundColor;

  final Future<void> Function({required ItemColor color, required int index}) onItemPressed;

  const ColorPickerState({
    required this.pageController,
    required this.animationController,
    required this.backgroundColor,
    required this.foregroundColor,
    required this.onItemPressed,
  });

  bool get isAnimating => foregroundColor != null;
}

ColorPickerState useColorPickerState() {
  final animationController = useAnimationController(duration: const Duration(milliseconds: 700));
  final pageController = usePageController(initialPage: 1, viewportFraction: 0.4);
  final gameState = useProvided<GameScreenState>();

  final foregroundColorState = useState<ItemColor?>(null);
  final backgroundColorState = useState<ItemColor>(ItemColor.all[1]);

  void animatePageView(int index) {
    pageController.animateToPage(index, duration: const Duration(milliseconds: 300), curve: Curves.easeInCubic);
  }

  Future<void> onItemPressed({required ItemColor color, required int index}) async {
    if (foregroundColorState.value != color) {
      foregroundColorState.value = color;
      animatePageView(index);
      await animationController.forward(from: 0.0);
      foregroundColorState.value = null;
      backgroundColorState.value = color;
    }
  }

  useSimpleEffect(() {
    WidgetsBinding.instance!.addPostFrameCallback((_) async {
      await Future.delayed(gameState.initialDuration);
      await onItemPressed(color: ItemColor.all[2], index: 2);
      await Future.delayed(const Duration(milliseconds: 500));
      await onItemPressed(color: ItemColor.all[1], index: 1);
      await Future.delayed(const Duration(milliseconds: 500));
      gameState.setGame();
    });
  }, []);

  return ColorPickerState(
    animationController: animationController,
    pageController: pageController,
    foregroundColor: foregroundColorState.value,
    backgroundColor: backgroundColorState.value,
    onItemPressed: onItemPressed,
  );
}
