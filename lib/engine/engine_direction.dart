import 'package:vector_math/vector_math_64.dart';

class EngineDirection {
  const EngineDirection._();

  static final up = Vector2(0, -1);
  static final down = Vector2(0, 1);
  static final left = Vector2(-1, 0);
  static final right = Vector2(1, 0);
}