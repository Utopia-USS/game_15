import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:game_15/widgets/color_picker/state/color_picker_state.dart';
import 'package:game_15/widgets/model/item_color.dart';

class ColorPickerBackground extends HookWidget {
  final ColorPickerState state;
  final Widget child;
  final BoxConstraints constraints;

  const ColorPickerBackground({
    Key? key,
    required this.state,
    required this.child,
    required this.constraints,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final width = constraints.maxWidth;
    final height = constraints.maxHeight;
    final size = width < height ? height : width;
    return AnimatedBuilder(
      animation: state.animationController,
      builder: (context, animation) {
        return Stack(
          alignment: Alignment.center,
          fit: StackFit.loose,
          children: [
            _buildItem(state.backgroundColor, size),
            if (state.animationController.isAnimating) _buildForeground(size),
            child,
          ],
        );
      },
    );
  }

  Widget _buildForeground(double size) {
    /// positioned anchor is based on edge of the widget, thus in order to avoid gradient flick at the end anchor is animated
    /// note: align is bugged and clips size of the widget to the constraints
    return Positioned(
      left: -size * state.animation,
      bottom: -size * state.animation,
      child: _buildItem(
        state.foregroundColor,
        size * 2 * state.animation,
        shape: BoxShape.circle,
        begin: Alignment.center,
      ),
    );
  }

  Widget _buildItem(ItemColor color, double size, {BoxShape? shape, Alignment? begin}) {
    return Container(
      height: size,
      width: size,
      decoration: BoxDecoration(
        shape: shape ?? BoxShape.rectangle,
        gradient: LinearGradient(
          end: Alignment.topRight,
          begin: Alignment.bottomLeft,
          colors: [
            color.primary,
            color.primary,
            color.accent,
          ],
        ),
      ),
    );
  }
}
