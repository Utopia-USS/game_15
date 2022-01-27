import 'package:flutter/cupertino.dart';
import 'package:forge2d/forge2d.dart';
import 'package:vector_math/vector_math_64.dart';

extension Vector2X on Vector2 {
  Offset toOffset([Size size = const Size.square(1)]) => Offset(x * size.width, y * size.height);

  Aabb2 aabbAround([Vector2? halfExtent]) => Aabb2.centerAndHalfExtents(this, halfExtent ?? Vector2.zero());
}

extension Aabb2X on Aabb2 {
  Rect toRect([Size size = const Size.square(1)]) => Rect.fromPoints(min.toOffset(size), max.toOffset(size));

  AABB toF2() => AABB.withVec2(min, max);
}