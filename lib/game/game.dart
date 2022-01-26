import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:game_15/game/game_engine.dart';
import 'package:game_15/game/game_model.dart';
import 'package:game_15/game/game_values.dart';
import 'package:game_15/kaleidoscope/kaleidoscope.dart';
import 'package:game_15/kaleidoscope/kaleidoscope_delegate.dart';
import 'package:game_15/util/geometry/alignment_rect.dart';

class Game extends HookWidget {
  final Widget child;

  const Game({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final engine = useMemoized(GameEngine.new);

    return GestureDetector(
      onPanStart: (details) => engine.onPanStart(_transform(context, details.localPosition)),
      onPanUpdate: (details) => engine.onPanUpdate(_transform(context, details.localPosition)),
      onPanEnd: (details) => engine.onPanEnd(),
      child: Kaleidoscope(
        delegate: _GameDelegate(engine.model),
        child: child,
      ),
    );
  }

  Alignment _transform(BuildContext context, Offset offset) =>
      FractionalOffset.fromOffsetAndSize(offset, context.size!);
}

class _GameDelegate extends RelativeKaleidoscopeDelegate {
  final ValueListenable<GameModel> model;

  const _GameDelegate(this.model) : super(repaint: model);

  @override
  int get shardCount => GameValues.childCount;

  @override
  RelativeKaleidoscopeShard getRelativeModel(int index) {
    return RelativeKaleidoscopeShard(
      src: AlignmentRect.fromSize(GameValues.alignmentFor(index), GameValues.childSize),
      dst: model.value.positions[index],
    );
  }

  @override
  bool shouldRepaint(_GameDelegate other) => other.model != model;
}
