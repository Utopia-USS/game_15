import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart' as ui;
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:game_15/engine/engine.dart';
import 'package:game_15/screens/game/widgets/kaleidoscope/kaleidoscope.dart';
import 'package:game_15/screens/game/widgets/kaleidoscope/kaleidoscope_delegate.dart';
import 'package:game_15/util/vector/vector_extensions.dart';
import 'package:game_15/util/widget/decoration_clipper.dart';
import 'package:vector_math/vector_math_64.dart';

import 'game_model.dart';
import 'game_randomizer.dart';
import 'game_values.dart';

class Game extends HookWidget {
  static const _moves = 3;

  final Widget child;
  final Decoration? decoration;
  final Decoration? foregroundDecoration;

  const Game({
    Key? key,
    required this.child,
    this.decoration,
    this.foregroundDecoration,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final engine = useMemoized(_createEngine);
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

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onPanStart: (details) => engine.onPanStart(_transform(context, details.localPosition)),
      onPanUpdate: (details) => engine.onPanUpdate(_transform(context, details.localPosition)),
      onPanEnd: (details) => engine.onPanEnd(),
      child: Flow(
        clipBehavior: Clip.none,
        delegate: _FlowDelegate(model),
        children: [
          Stack(
            fit: StackFit.passthrough,
            overflow: Overflow.visible,
            children: [
              ui.Material(
                elevation: 50,
                color: ui.Colors.transparent,
                child: DecoratedBox(decoration: decoration!),
              ),
              ClipPath(
                clipper: DecorationClipper(decoration: decoration!),
                child: Kaleidoscope(
                  delegate: _KaleidoscopeDelegate(model),
                  child: child,
                ),
              ),
              ///without stretch border was desynchronized while moving
              if (foregroundDecoration != null)
                Positioned(
                  left: -1,
                  right: -1,
                  bottom: -1,
                  top: -1,
                  child: DecoratedBox(
                    decoration: foregroundDecoration!,
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Engine _createEngine() => Engine(initialPositions: EngineRandomizer.generatePositions(moves: _moves));

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
    final position = Vector2(
      GameValues.transformCoordinate(GameValues.xFor(index)),
      GameValues.transformCoordinate(GameValues.yFor(index)),
    );
    return KaleidoscopeShard(
      src: position.aabbAround(GameValues.halfChildExtent).toRect(size),
      dst: (model.value.positions[index] - GameValues.halfChildExtent).toOffset(size),
    );
  }

  @override
  bool shouldRepaint(_KaleidoscopeDelegate other) => other.model != model;
}
