import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:game_15/widgets/color_picker/state/color_picker_state.dart';
import 'package:game_15/model/item_color.dart';

class ColorPickerBackground extends HookWidget {
  final ColorPickerState state;
  final Widget child;

  const ColorPickerBackground({
    Key? key,
    required this.state,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        _buildItem(state.backgroundColor),
        if (state.isAnimating) _buildForeground(),
        Center(child: child),
      ],
    );
  }

  Widget _buildForeground() {
    final animation = useMemoized(() => state.animationController.drive(CurveTween(curve: Curves.easeInCubic)));
    return ClipOval(
      clipper: _Clipper(animation),
      child: _buildItem(state.foregroundColor!),
    );
  }

  Widget _buildItem(ItemColor color) {
    return DecoratedBox(
      decoration: BoxDecoration(
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

class _Clipper extends CustomClipper<Rect> {
  final Animation<double> animation;

  const _Clipper(this.animation) : super(reclip: animation);

  @override
  Rect getClip(Size size) {
    return Rect.fromCircle(center: Offset(0, size.height), radius: 1.5 * size.longestSide * animation.value);
  }

  @override
  bool shouldReclip(covariant CustomClipper<Rect> oldClipper) =>
      oldClipper is! _Clipper || oldClipper.animation != animation;
}
