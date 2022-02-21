import 'package:flutter/foundation.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:game_15/engine/engine.dart';
import 'package:game_15/game/game_config.dart';
import 'package:game_15/game/game_model.dart';
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

GameState useGameState({required GameConfig config}) {
  Engine createEngine() => Engine(initialPositions: GameRandomizer.generatePositions(moves: config.moves));

  final engine = useMemoized(createEngine);
  final model = useMemoized(() => ValueNotifier(engine.buildModel()));
  final tickerProvider = useSingleTickerProvider();
  final isWonState = useRef(false);

  void update(Duration elapsed) {
    engine.update(elapsed);
    model.value = engine.buildModel();
    if (!isWonState.value && GameWinDetector.isWon(model.value)) {
      isWonState.value = true;
      config.onWon();
    }
  }

  useEffect(() {
    final ticker = tickerProvider.createTicker(update);
    ticker.start();
    return ticker.dispose;
  }, []);

  return GameState(
    config: config,
    model: model,
    onPanStart: engine.onPanStart,
    onPanUpdate: engine.onPanUpdate,
    onPanEnd: engine.onPanEnd,
  );
}
