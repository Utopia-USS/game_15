import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:game_15/engine/engine.dart';
import 'package:game_15/game/game_model.dart';
import 'package:game_15/game/game_values.dart';
import 'package:game_15/game/game_wrapper.dart';
import 'package:game_15/kaleidoscope/kaleidoscope.dart';
import 'package:game_15/kaleidoscope/kaleidoscope_delegate.dart';
import 'package:game_15/util/vector/vector_extensions.dart';
import 'package:vector_math/vector_math_64.dart';

class Game extends HookWidget {
  final Widget child;

  const Game({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final engine = useMemoized(Engine.new);
    final model = useMemoized(() => ValueNotifier(engine.buildModel()));
    final tickerProvider = useSingleTickerProvider();

    useEffect(() {
      final ticker = tickerProvider.createTicker((elapsed) {
        engine.update(elapsed);
        model.value = engine.buildModel();
      });
      ticker.start();
      return ticker.dispose;
    }, []);

    return  GestureDetector(
        behavior: HitTestBehavior.opaque,
        onPanStart: (details) => engine.onPanStart(_transform(context, details.localPosition)),
        onPanUpdate: (details) => engine.onPanUpdate(_transform(context, details.localPosition)),
        onPanEnd: (details) => engine.onPanEnd(),
        child: Kaleidoscope(
          delegate: _GameDelegate(model),
          child: child,
        ),

    );
  }

  Vector2 _transform(BuildContext context, Offset offset) =>
      Vector2(offset.dx / context.size!.width, offset.dy / context.size!.height);
}

class _GameDelegate extends KaleidoscopeDelegate {
  final ValueListenable<GameModel> model;

  const _GameDelegate(this.model) : super(repaint: model);

  @override
  int get shardCount => GameValues.childCount;

  @override
  KaleidoscopeShard getShard(Size size, int index) {
    final position = GameValues.initialPositionFor(index);
    return KaleidoscopeShard(
      src: position.aabbAround(GameValues.halfChildExtent).toRect(size),
      dst: (model.value.positions[index] - GameValues.halfChildExtent).toOffset(size),
    );
  }

  @override
  bool shouldRepaint(_GameDelegate other) => other.model != model;
}
