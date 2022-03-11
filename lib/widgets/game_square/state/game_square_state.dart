import 'package:flutter/material.dart';
import 'package:game_15/game/game_controller.dart';
import 'package:game_15/screens/game/state/game_screen_state.dart';
import 'package:game_15/screens/menu/menu_screen.dart';
import 'package:game_15/state/game_type_state.dart';
import 'package:utopia_hooks/utopia_hooks.dart';


class GameSquareState {
  final GameController gameController;

  const GameSquareState({
    required this.gameController,
  });

  get initialDuration => const Duration(milliseconds: 300) + MenuScreen.transitionDuration;
}

GameSquareState useGameSquareState() {
  final typeState = useProvided<GameTypeState>();

  final gameController = useMemoized(GameController.new, [typeState.type]);
  final gameState = useProvided<GameScreenState>();


  useSimpleEffect(() {
    WidgetsBinding.instance!.addPostFrameCallback((_) async {
      await Future.delayed(gameState.initialDuration);
      await gameController.shuffle!();
      await Future.delayed(const Duration(milliseconds: 1000));
      gameState.setGame();
      await gameController.perform!();
    });
  }, []);


  return GameSquareState(
    gameController: gameController,
  );
}
