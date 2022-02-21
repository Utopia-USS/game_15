import 'package:game_15/screens/game/state/game_screen_state.dart';
import 'package:utopia_hooks/utopia_hooks.dart';

class GameTypeState {
  final GameType type;
  final void Function(GameType) onTypeChanged;

  const GameTypeState({
    required this.type,
    required this.onTypeChanged,
  });
}

class GameTypeStateProvider extends HookStateProviderWidget<GameTypeState> {
  @override
  GameTypeState use() {
    final typeState = useState<GameType>(GameType.menu);

    return GameTypeState(
      type: typeState.value,
      onTypeChanged: (type) => typeState.value = type,
    );
  }
}
