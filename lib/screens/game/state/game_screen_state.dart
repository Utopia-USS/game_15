import 'package:game_15/game/game_controller.dart';
import 'package:game_15/state/game_type_state.dart';
import 'package:utopia_hooks/utopia_hooks.dart';

import '../../menu/menu_screen.dart';

class GameScreenState {
  final GameType type;
  final bool isWon;
  final void Function() onMenuPressed;
  final GameController gameController;

  const GameScreenState({
    required this.type,
    required this.onMenuPressed,
    required this.isWon,
    required this.gameController,
  });

  get initialDuration => const Duration(milliseconds: 300) + MenuScreen.transitionDuration;
}

GameScreenState useGameScreenState({required Future<MenuScreenResult> Function() navigateToMenu}) {
  final typeState = useProvided<GameTypeState>();
  final isWonState = useState(false);

  final gameController = useMemoized(GameController.new, [typeState.type]);

  onMenuPressed() async {
    final result = await navigateToMenu();
    if (result == MenuScreenResult.game_changed) isWonState.value = false;
  }

  return GameScreenState(
    type: typeState.type,
    onMenuPressed: onMenuPressed,
    isWon: isWonState.value,
    gameController: gameController,
  );
}
