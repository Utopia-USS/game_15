import 'package:flutter/cupertino.dart';
import 'package:game_15/game/game_controller.dart';
import 'package:game_15/state/game_type_state.dart';
import 'package:utopia_hooks/utopia_hooks.dart';

enum GameType { color_picker, menu, ripple }

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
}

GameScreenState useGameScreenState({required void Function() navigateToMenu}) {
  final typeState = useProvided<GameTypeState>();
  final isWonState = useState(false);
  
  final gameController = useMemoized(GameController.new);
  
  useEffect(() {
    WidgetsBinding.instance!.addPostFrameCallback((_) async {
      await Future.delayed(const Duration(seconds: 3));
      await gameController.perform?.call();
      isWonState.value = true;
    });
  }, []);

  return GameScreenState(
    type: typeState.type,
    onMenuPressed: navigateToMenu,
    isWon: isWonState.value,
    gameController: gameController,
  );
}
