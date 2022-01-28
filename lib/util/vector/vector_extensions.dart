import 'package:flutter/cupertino.dart';
import 'package:vector_math/vector_math_64.dart';

extension Vector2X on Vector2 {
  Offset toOffset([Size size = const Size.square(1)]) => Offset(x * size.width, y * size.height);

  Aabb2 aabbAround([Vector2? halfExtent]) => Aabb2.centerAndHalfExtents(this, halfExtent ?? Vector2.zero());

  Vector2 extendedToInfinity() => Vector2(x == 0 ? 0 : double.infinity, y == 0 ? 0 : double.infinity);
}

extension Aabb2X on Aabb2 {
  Rect toRect([Size size = const Size.square(1)]) => Rect.fromPoints(min.toOffset(size), max.toOffset(size));

  Aabb2 extendedBy(Vector2 vector) {
    final result = Aabb2();
    Vector2.min(min, min + vector, result.min);
    Vector2.max(max, max + vector, result.max);
    return result;
  }

  bool intersectsWithAabb2Strict(Aabb2 other) {
    final otherMax = other.max;
    final otherMin = other.min;

    return (min.x < otherMax.x) && (min.y < otherMax.y) && (max.x > otherMin.x) && (max.y > otherMin.y);
  }
}
