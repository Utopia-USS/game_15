import 'package:game_15/game/game_values.dart';
import 'package:vector_math/vector_math_64.dart';

class GameModel {
  final Vector2 translation;
  final List<Vector2> positions;

  GameModel({Vector2? translation, required this.positions}) : translation = translation ?? Vector2.zero();

  static final initial = GameModel(
    positions: [for (int i = 0; i < GameValues.childCount; i++) GameValues.positionFor(i)],
  );
}
