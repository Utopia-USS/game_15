import 'package:flutter/cupertino.dart';

class CoverFullscreenWrapper extends StatelessWidget {
  final double aspectRatio;
  final Widget child;

  const CoverFullscreenWrapper({
    required this.aspectRatio,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      var scale = constraints.biggest.aspectRatio * aspectRatio;

      // to prevent scaling down, invert the value
      if (scale < 1) scale = 1 / scale;

      return ClipRect(
        child: Transform.scale(
          scale: scale,
          child: Center(child: child),
        ),
      );
    });
  }
}
