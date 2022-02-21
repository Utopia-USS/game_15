import 'package:game_15/game/game_model.dart';
import 'package:game_15/game/game_values.dart';

class GameWinDetector {
  const GameWinDetector._();

  static bool isWon(GameModel model) {
    for(int i = 0; i < GameValues.childCount; i++) {
      final position = model.positions[i];
      if(position != GameValues.positionFor(i)) return false;
    }
    return true;
  }
}