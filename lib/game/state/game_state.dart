import 'dart:async';

import 'package:flutter/animation.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:game_15/engine/engine.dart';
import 'package:game_15/game/game_config.dart';
import 'package:game_15/game/game_controller.dart';
import 'package:game_15/game/model/game_model.dart';
import 'package:game_15/game/model/game_model_tween.dart';
import 'package:game_15/game/state/game_randomizer.dart';
import 'package:game_15/game/state/game_win_detector.dart';
import 'package:vector_math/vector_math_64.dart';

class GameState {
  final GameConfig config;
  final ValueListenable<GameModel> model;

  final Function(Vector2) onPanStart;
  final Function(Vector2) onPanUpdate;
  final Function() onPanEnd;

  const GameState({
    required this.config,
    required this.model,
    required this.onPanStart,
    required this.onPanUpdate,
    required this.onPanEnd,
  });
}

GameState useGameState({required GameConfig config, required GameController controller}) {
  final initialPositions = useMemoized(() => GameRandomizer.generatePositions(moves: config.moves));
  final engine = useMemoized(() => Engine(initialPositions: initialPositions));
  final model = useMemoized(() => ValueNotifier(GameModel.initial));
  final animationTickerProvider = useSingleTickerProvider();
  final engineTickerProvider = useSingleTickerProvider();

  final hasStartedState = useState(false);
  final wonCompleter = useMemoized(() => Completer<void>());

  GameModelTween buildModelTween() =>
      GameModelTween(begin: model.value, end: GameModel(translation: Vector2.zero(), positions: initialPositions));

  Future<void> animateToInitialPositions() async {
    final animationController = AnimationController(
      vsync: animationTickerProvider,
      duration: config.initialAnimationDuration,
    );
    final animation =
        animationController.drive(CurveTween(curve: config.initialAnimationCurve)).drive(buildModelTween());
    animation.addListener(() => model.value = animation.value);
    await animationController.forward();
  }

  Future<void> start() async {
    await animateToInitialPositions();
    hasStartedState.value = true;
    await wonCompleter.future;
  }

  useEffect(() {
    controller.perform = start;
    return () => controller.perform = null;
  }, [controller]);

  void update(Duration elapsed) {
    engine.update(elapsed);
    model.value = engine.buildModel();
    if (!wonCompleter.isCompleted && GameWinDetector.isWon(model.value)) {
      wonCompleter.complete();
    }
  }

  useEffect(() {
    if (hasStartedState.value) {
      final ticker = engineTickerProvider.createTicker(update);
      ticker.start();
      return ticker.dispose;
    }
  }, [hasStartedState.value]);

  return GameState(
    config: config,
    model: model,
    onPanStart: engine.onPanStart,
    onPanUpdate: engine.onPanUpdate,
    onPanEnd: engine.onPanEnd,
  );
}
