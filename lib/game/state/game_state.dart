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

enum _Stage { notStarted, inProgress, won }

class GameState {
  final GameConfig config;
  final ValueListenable<GameModel> model;
  final bool isWon, areGesturesEnabled;

  final Function(Vector2) onPanStart;
  final Function(Vector2) onPanUpdate;
  final Function() onPanEnd;

  const GameState({
    required this.config,
    required this.model,
    required this.isWon,
    required this.areGesturesEnabled,
    required this.onPanStart,
    required this.onPanUpdate,
    required this.onPanEnd,
  });
}

GameState useGameState({
  required bool isLocked,
  required GameConfig config,
  required GameController controller,
}) {
  final gameId = useState(0);
  final initialPositions = useMemoized(() => GameRandomizer.generatePositions(moves: config.moves), [gameId.value]);
  final engine = useMemoized(() => Engine(initialPositions: initialPositions), [gameId.value]);
  final model = useMemoized(() => ValueNotifier(GameModel.initial), [gameId.value]);
  final animationTickerProvider = useSingleTickerProvider();
  final engineTickerProvider = useSingleTickerProvider();

  final stageState = useState(_Stage.notStarted);
  final wonCompleter = useMemoized(() => Completer<void>());

  Animation<GameModel> buildAnimation(AnimationController controller, GameModel end) =>
      controller.drive(CurveTween(curve: config.animationCurve)).drive(GameModelTween(begin: model.value, end: end));

  Future<void> animateTo(GameModel target) async {
    final animationController = AnimationController(
      vsync: animationTickerProvider,
      duration: config.animationDuration,
    );
    final animation = buildAnimation(animationController, target);
    animation.addListener(() => model.value = animation.value);
    await animationController.forward();
  }

  Future<void> shuffle() async => await animateTo(GameModel(positions: initialPositions));

  Future<void> perform() async {
    stageState.value = _Stage.inProgress;
    await wonCompleter.future;
    stageState.value = _Stage.won;
  }

  Future<void> reset() async {
    await animateTo(GameModel.initial);
    gameId.value++;
    stageState.value = _Stage.notStarted;
  }

  useEffect(() {
    controller
      ..shuffle = shuffle
      ..perform = perform
      ..reset = reset;
    return () => controller
      ..shuffle = null
      ..perform = null
      ..reset = null;
  }, [controller]);

  void update(Duration elapsed) {
    engine.update(elapsed);
    model.value = engine.buildModel();
    if (!wonCompleter.isCompleted && GameWinDetector.isWon(model.value)) {
      wonCompleter.complete();
    }
  }

  useEffect(() {
    if (stageState.value == _Stage.inProgress) {
      final ticker = engineTickerProvider.createTicker(update);
      ticker.start();
      return ticker.dispose;
    }
    return null;
  }, [stageState.value == _Stage.inProgress]);

  return GameState(
    config: config,
    model: model,
    isWon: stageState.value == _Stage.won,
    areGesturesEnabled: stageState.value == _Stage.inProgress && !isLocked,
    onPanStart: engine.onPanStart,
    onPanUpdate: engine.onPanUpdate,
    onPanEnd: engine.onPanEnd,
  );
}
