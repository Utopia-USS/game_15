import 'package:game_15/state/game_type_state.dart';
import 'package:utopia_hooks/utopia_hooks.dart';

enum GameType { color_picker, menu, ripple }

class GameScreenState {
  final GameType type;
  final bool isWon;
  final void Function() onMenuPressed;
  final Function() onWon;

  const GameScreenState({
    required this.type,
    required this.onMenuPressed,
    required this.isWon,
    required this.onWon,
  });
}

GameScreenState useGameScreenState({required void Function() navigateToMenu}) {
  final typeState = useProvided<GameTypeState>();
  final isWonState = useState(false);

  return GameScreenState(
    type: typeState.type,
    onMenuPressed: navigateToMenu,
    isWon: isWonState.value,
    onWon: () => isWonState.value = true,
  );
}
