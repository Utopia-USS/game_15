import 'package:vector_math/vector_math_64.dart';

class GameValues {
  const GameValues._();

  static const childCount = 15;

  static const dimension = 4;

  static const halfChildSize = 0.5 / dimension;

  static final halfChildExtent = Vector2.all(halfChildSize);

  static final center = Vector2.all(0.5);

  static Vector2 initialPositionFor(int index) =>
      Vector2((xFor(index) + 0.5) / dimension, (yFor(index) + 0.5) / dimension);

  static int xFor(int index) => index % dimension;

  static int yFor(int index) => index ~/ dimension;
}
