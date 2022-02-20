import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:game_15/state/game_type_state.dart';
import 'package:utopia_hooks/utopia_hooks.dart';

enum GameType{color_picker, menu}

class GameScreenState {
  final GameType type;
  final void Function() onMenuPressed;

  const GameScreenState({
    required this.type,
    required this.onMenuPressed,
});


}

GameScreenState useGameScreenState({required void Function() navigateToMenu}) {
  final typeState = useProvided<GameTypeState>();

  return GameScreenState(
    type: typeState.type,
    onMenuPressed: navigateToMenu,
  );
}
