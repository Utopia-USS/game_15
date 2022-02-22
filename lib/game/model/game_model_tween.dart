import 'package:flutter/animation.dart';
import 'package:game_15/game/game_values.dart';
import 'package:game_15/game/model/game_model.dart';
import 'package:vector_math/vector_math_64.dart';

class GameModelTween extends Tween<GameModel> {
  GameModelTween({required GameModel begin, required GameModel end}) : super(begin: begin, end: end);

  @override
  GameModel lerp(double t) {
    return GameModel(
      translation: _lerp(begin!.translation, end!.translation, t),
      positions: [for (int i = 0; i < GameValues.childCount; i++) _lerp(begin!.positions[i], end!.positions[i], t)],
    );
  }

  Vector2 _lerp(Vector2 begin, Vector2 end, double t) {
    final result = Vector2.zero();
    Vector2.mix(begin, end, t, result);
    return result;
  }
}
