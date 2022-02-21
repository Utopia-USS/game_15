import 'package:vector_math/vector_math_64.dart';

class GameModel {
  final Vector2 translation;
  final List<Vector2> positions;

  const GameModel({required this.translation, required this.positions});
}
