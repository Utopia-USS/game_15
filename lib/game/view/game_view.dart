import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:game_15/game/model/game_model.dart';
import 'package:game_15/game/game_values.dart';
import 'package:game_15/game/state/game_state.dart';
import 'package:game_15/util/kaleidoscope/kaleidoscope.dart';
import 'package:game_15/util/kaleidoscope/kaleidoscope_delegate.dart';
import 'package:game_15/util/vector/vector_extensions.dart';
import 'package:game_15/util/widget/decoration_clipper.dart';
import 'package:vector_math/vector_math_64.dart';

class GameView extends StatelessWidget {
  final GameState state;
  final Widget child;

  const GameView({Key? key, required this.state, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _buildGestureDetector(
      context,
      child: Flow(
        clipBehavior: Clip.none,
        delegate: _FlowDelegate(state.model),
        children: [
          _buildDecoration(
            child: Kaleidoscope(
              delegate: _KaleidoscopeDelegate(state.model),
              child: child,
            ),
          )
        ],
      ),
    );
  }

  Widget _buildGestureDetector(BuildContext context, {required Widget child}) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onPanStart: (details) => state.onPanStart(_transform(context, details.localPosition)),
      onPanUpdate: (details) => state.onPanUpdate(_transform(context, details.localPosition)),
      onPanEnd: (details) => state.onPanEnd(),
      child: child,
    );
  }

  Widget _buildDecoration({required Widget child}) {
    return Stack(
      fit: StackFit.passthrough,
      children: [
        if (state.config.decoration != null) Container(padding: const EdgeInsets.all(1), decoration: state.config.decoration!),
        Padding(
          padding: const EdgeInsets.all(1),
          child: ClipPath(
            clipper: state.config.decoration != null ? DecorationClipper(decoration: state.config.decoration!) : null,
            clipBehavior: Clip.hardEdge,
            child: child,
          ),
        ),
        if (state.config.foregroundDecoration != null) DecoratedBox(decoration: state.config.foregroundDecoration!),
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
    return KaleidoscopeShard(
      src: position.aabbAround(GameValues.halfChildExtent).toRect(size),
      dst: (model.value.positions[index] - GameValues.halfChildExtent).toOffset(size),
    );
  }

  @override
  bool shouldRepaint(_KaleidoscopeDelegate other) => other.model != model;
}
