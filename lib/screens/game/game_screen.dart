import 'package:flutter/widgets.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:game_15/screens/game/state/game_screen_state.dart';
import 'package:game_15/screens/game/view/game_screen_view.dart';
import 'package:game_15/screens/menu/menu_screen.dart';

class GameScreen extends HookWidget {
  const GameScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final state = useGameScreenState(
      navigateToMenu: () => MenuScreen.show(context),
    );
    return GameScreenView(state: state);
  }
}
