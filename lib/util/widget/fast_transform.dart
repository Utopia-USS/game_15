import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';

class FastTransform extends StatelessWidget {
  final ValueListenable<Matrix4 Function(Size)> transform;
  final Widget child;
  final Clip clipBehaviour;

  const FastTransform({
    Key? key,
    required this.transform,
    required this.child,
    this.clipBehaviour = Clip.hardEdge,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Flow(
      clipBehavior: clipBehaviour,
      delegate: _FlowDelegate(transform),
      children: [child],
    );
  }
}

class _FlowDelegate extends FlowDelegate {
  final ValueListenable<Matrix4 Function(Size)> transform;

  const _FlowDelegate(this.transform) : super(repaint: transform);

  @override
  void paintChildren(FlowPaintingContext context) => context.paintChild(0, transform: transform.value(context.size));

  @override
  bool shouldRepaint(_FlowDelegate other) => other.transform != transform;
}
