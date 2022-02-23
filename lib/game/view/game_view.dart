import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:game_15/game/game_values.dart';
import 'package:game_15/game/model/game_model.dart';
import 'package:game_15/game/state/game_state.dart';
import 'package:game_15/util/kaleidoscope/kaleidoscope.dart';
import 'package:game_15/util/kaleidoscope/kaleidoscope_delegate.dart';
import 'package:game_15/util/kaleidoscope/kaleidoscope_shard.dart';
import 'package:game_15/util/vector/vector_extensions.dart';
import 'package:game_15/util/widget/decoration_clipper.dart';
import 'package:utopia_hooks/utopia_hooks.dart';
import 'package:vector_math/vector_math_64.dart' hide Colors;

class GameView extends HookWidget {
  final GameState state;
  final Widget child;

  const GameView({Key? key, required this.state, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.passthrough,
      children: [
        Flow(
          clipBehavior: Clip.none,
          delegate: _FlowDelegate(state.model),
          children: [_buildDecoration(child: _buildKaleidoscope())],
        ),
        if (!state.isWon) _buildGestureDetector(context),
      ],
    );
  }

  Widget _buildKaleidoscope() {
    return Kaleidoscope(
      key: useMemoized(GlobalKey.new),
      delegate: state.isWon ? const _WonKaleidoscopeDelegate() : _KaleidoscopeDelegate(state.model),
      child: child,
    );
  }

  Widget _buildGestureDetector(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      dragStartBehavior: DragStartBehavior.down,
      onVerticalDragStart: (details) => state.onPanStart(_transform(context, details.localPosition)),
      onVerticalDragUpdate: (details) => state.onPanUpdate(_transform(context, details.localPosition)),
      onVerticalDragEnd: (details) => state.onPanEnd(),
      onHorizontalDragStart: (details) => state.onPanStart(_transform(context, details.localPosition)),
      onHorizontalDragUpdate: (details) => state.onPanUpdate(_transform(context, details.localPosition)),
      onHorizontalDragEnd: (details) => state.onPanEnd(),
    );
  }

  Widget _buildDecoration({required Widget child}) {
    return Stack(
      fit: StackFit.passthrough,
      children: [
        if (state.config.decoration != null)
          Container(padding: const EdgeInsets.all(1), decoration: state.config.decoration!),
        Padding(
          padding: const EdgeInsets.all(1),
          child: ClipPath(
            clipper: state.config.decoration != null ? DecorationClipper(decoration: state.config.decoration!) : null,
            clipBehavior: Clip.hardEdge,
            child: child,
          ),
        ),
        if (state.config.foregroundDecoration != null)
          IgnorePointer(child: DecoratedBox(decoration: state.config.foregroundDecoration!)),
      ],
    );
  }

  Vector2 _transform(BuildContext context, Offset offset) =>
      Vector2(offset.dx / context.size!.width, offset.dy / context.size!.height);
}

class _FlowDelegate extends FlowDelegate {
  final ValueListenable<GameModel> model;

  const _FlowDelegate(this.model) : super(repaint: model);

  @override
  void paintChildren(FlowPaintingContext context) {
    final translation = model.value.translation.toOffset(context.size);
    context.paintChild(0, transform: Matrix4.translationValues(translation.dx, translation.dy, 0));
  }

  @override
  bool shouldRepaint(_FlowDelegate other) => other.model != model;
}

class _KaleidoscopeDelegate extends KaleidoscopeDelegate {
  final ValueListenable<GameModel> model;

  const _KaleidoscopeDelegate(this.model) : super(repaint: model);

  @override
  int get shardCount => GameValues.childCount;

  @override
  KaleidoscopeShard getShard(Size size, int index) {
    final position = GameValues.positionFor(index);
    return KaleidoscopeShard.fromSrcDst(
      src: position.aabbAround(GameValues.halfChildExtent).toRect(size),
      dst: (model.value.positions[index] - GameValues.halfChildExtent).toOffset(size),
    );
  }

  @override
  bool shouldRepaint(_KaleidoscopeDelegate other) => other.model != model;
}

class _WonKaleidoscopeDelegate extends KaleidoscopeDelegate {
  const _WonKaleidoscopeDelegate();

  @override
  int get shardCount => 1;

  @override
  KaleidoscopeShard getShard(Size size, int index) =>
      KaleidoscopeShard.fromSrcDst(src: Offset.zero & size, dst: Offset.zero);

  @override
  bool shouldRepaint(_WonKaleidoscopeDelegate other) => false;
}
