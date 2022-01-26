import 'package:flutter/painting.dart';
import 'package:game_15/util/geometry/alignment_rect.dart';

class GameValues {
  const GameValues._();

  static const childCount = 15;

  static const dimension = 4;

  static const childSize = FractionalOffset(1 / dimension, 1 / dimension);

  static final allowedPositionRect =
      AlignmentRect.fromPoints(FractionalOffset.topLeft, FractionalOffset.bottomRight - childSize);

  static Alignment alignmentFor(int index) => FractionalOffset(xFor(index) / dimension, yFor(index) / dimension);

  static int xFor(int index) => index % dimension;

  static int yFor(int index) => index ~/ dimension;
}
