import 'package:flutter/animation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:game_15/widgets/model/item_color.dart';

class ColorPickerState {
  final AnimationController animationController;
  final double animation;
  final PageController pageController;

  final ItemColor foregroundColor;
  final ItemColor backgroundColor;

  final Future<void> Function({required ItemColor color, required int index}) onItemPressed;

  const ColorPickerState({
    required this.pageController,
    required this.animation,
    required this.animationController,
    required this.backgroundColor,
    required this.foregroundColor,
    required this.onItemPressed,
  });
}

ColorPickerState useColorPickerState() {
  final animationController = useAnimationController(duration: const Duration(milliseconds: 600));
  final animation = useAnimation(CurvedAnimation(parent: animationController, curve: Curves.easeInCubic));
  final pageController = usePageController(initialPage: 1, viewportFraction: 0.5);

  final foregroundColorState = useState<ItemColor>(ItemColor.blue);
  final backgroundColorState = useState<ItemColor>(ItemColor.blue);

  void animatePageView(int index) {
    pageController.animateToPage(index, duration: const Duration(milliseconds: 300), curve: Curves.easeInCubic);
  }

  Future<void> onItemPressed({required ItemColor color, required int index}) async {
    if(foregroundColorState.value != color){
      foregroundColorState.value = color;
      animatePageView(index);
      await animationController.forward(from: 0.0);
      backgroundColorState.value = color;
    }
  }

  return ColorPickerState(
    animationController: animationController,
    animation: animation,
    pageController: pageController,
    foregroundColor: foregroundColorState.value,
    backgroundColor: backgroundColorState.value,
    onItemPressed: onItemPressed,
  );
}
