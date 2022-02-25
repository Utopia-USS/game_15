import 'package:flutter/cupertino.dart';
import 'package:game_15/screens/game/state/game_screen_state.dart';
import 'package:game_15/screens/menu/menu_screen.dart';
import 'package:game_15/state/game_type_state.dart';
import 'package:utopia_hooks/utopia_hooks.dart';

class MenuScreenState {
  final void Function(GameType) onTypeChanged;

  const MenuScreenState({
    required this.onTypeChanged,
  });
}

MenuScreenState useMenuScreenState() {
  final typeState = useProvided<GameTypeState>();
  final context = useContext();

  return MenuScreenState(
    onTypeChanged: (type) async {
      typeState.onTypeChanged(type);
      Navigator.pop(context, MenuScreenResult.game_changed);
    },
  );
}
