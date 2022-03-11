import 'package:utopia_hooks/utopia_hooks.dart';

enum GameType { color_picker, menu, ripple, camera, square }

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
    final typeState = useState<GameType>(GameType.color_picker);

    return GameTypeState(
      type: typeState.value,
      onTypeChanged: (type) => typeState.value = type,
    );
  }
}
