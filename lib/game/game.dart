import 'package:flutter/cupertino.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:game_15/game/game_config.dart';
import 'package:game_15/game/game_controller.dart';
import 'package:game_15/game/state/game_state.dart';
import 'package:game_15/game/view/game_view.dart';

class Game extends HookWidget {
  final GameConfig config;
  final GameController controller;
  final Widget child;

  const Game({
    Key? key,
    required this.child,
    required this.config,
    required this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final state = useGameState(config: config, controller: controller);
    return GameView(state: state, child: child);
  }
}
