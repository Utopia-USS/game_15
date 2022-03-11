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

  final bool isLocked;
  final void Function(bool) onLockChanged;

  const GameScreenState({
    required this.type,
    required this.onMenuPressed,
    required this.stage,
    required this.gameController,
    required this.setGame,
    required this.onLockChanged,
    required this.isLocked,
  });

  get initialDuration => const Duration(milliseconds: 300) + MenuScreen.transitionDuration;

  bool get isWon => stage == GameScreenStage.won;
}

GameScreenState useGameScreenState({required Future<MenuScreenResult> Function() navigateToMenu}) {
  final typeState = useProvided<GameTypeState>();
  final stageState = useState(GameScreenStage.demo);

  final gameController = useMemoized(GameController.new, [typeState.type]);

  final isGameLockedState = useState<bool>(false);

  onMenuPressed() async {
    final result = await navigateToMenu();
    if (result == MenuScreenResult.game_changed) stageState.value = GameScreenStage.demo;
  }

  setGame() async {
    if (gameController.perform != null) {
      stageState.value = GameScreenStage.inProgress;
      await gameController.shuffle!();
      await gameController.perform!();
      stageState.value = GameScreenStage.won;
    }
  }

  return GameScreenState(
    type: typeState.type,
    onMenuPressed: onMenuPressed,
    stage: stageState.value,
    gameController: gameController,
    setGame: setGame,
    isLocked: isGameLockedState.value,
    onLockChanged: (value) => isGameLockedState.value = value,
  );
}
