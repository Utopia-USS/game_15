import 'package:game_15/game/game_controller.dart';
import 'package:game_15/state/game_type_state.dart';
import 'package:utopia_hooks/utopia_hooks.dart';

import '../../menu/menu_screen.dart';

enum GameScreenStage { demo, inProgress, won }

class GameScreenState {
  final GameType type;
  final GameScreenStage stage;

  final GameController gameController;
  final void Function() setGame;
  final void Function() onMenuPressed;

  final void Function() onResetPressed;

  final bool isLocked;
  final void Function(bool) onLockChanged;

  const GameScreenState({
    required this.type,
    required this.onMenuPressed,
    required this.stage,
    required this.gameController,
    required this.setGame,
    required this.onResetPressed,
    required this.onLockChanged,
    required this.isLocked,
  });

  get initialDuration => const Duration(milliseconds: 300) + MenuScreen.transitionDuration;

  bool get isWon => stage == GameScreenStage.won;

  bool get isResetVisible => stage != GameScreenStage.demo;
}

GameScreenState useGameScreenState({required Future<MenuScreenResult> Function() navigateToMenu}) {
  final typeState = useProvided<GameTypeState>();
  final stageState = useState(GameScreenStage.demo);

  final gameController = useMemoized(GameController.new, [typeState.type]);

  final isGameLockedState = useState<bool>(false);

  void onMenuPressed() async {
    final result = await navigateToMenu();
    if (result == MenuScreenResult.game_changed) stageState.value = GameScreenStage.demo;
  }

  void setGame() async {
    if (gameController.isAttached) {
      await gameController.shuffle!();
      stageState.value = GameScreenStage.inProgress;
      await gameController.perform!();
      stageState.value = GameScreenStage.won;
    }
  }

  void reset() async {
    if(gameController.isAttached) {
      stageState.value = GameScreenStage.demo;
      await gameController.reset!();
      await Future.delayed(const Duration(seconds: 1));
      setGame();
    }
  }

  return GameScreenState(
    type: typeState.type,
    onMenuPressed: onMenuPressed,
    stage: stageState.value,
    gameController: gameController,
    setGame: setGame,
    onResetPressed: reset,
    isLocked: isGameLockedState.value,
    onLockChanged: (value) => isGameLockedState.value = value,
  );
}
