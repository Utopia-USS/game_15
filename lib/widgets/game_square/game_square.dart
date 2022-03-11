import 'package:flutter/widgets.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:game_15/model/item_color.dart';
import 'package:game_15/widgets/game_square/state/game_square_state.dart';
import 'package:game_15/widgets/game_square/view/game_square_view.dart';

class GameSquare extends HookWidget {
  const GameSquare({Key? key}) : super(key: key);
  static final color = ItemColor.green;
  @override
  Widget build(BuildContext context) {
    final state = useGameSquareState();
    return GameSquareView(state: state);
  }
}
