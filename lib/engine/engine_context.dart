import 'package:game_15/engine/engine_body.dart';
import 'package:game_15/engine/engine_direction.dart';
import 'package:vector_math/vector_math_64.dart';

class EngineQueryResult {
  final EngineBody body;
  final double distance;

  const EngineQueryResult({required this.body, required this.distance});
}

class EngineQueryRequest {
  final Aabb2 aabb;
  final Vector2 direction;

  EngineQueryRequest({required this.aabb, required this.direction});

  late final aabbExtension = _calculateAabbExtension();

  Aabb2 _calculateAabbExtension() {
    final min = aabb.min;
    final max = aabb.max;
    if (direction == EngineDirection.up) {
      return Aabb2.minMax(Vector2(min.x, -double.infinity), Vector2(max.x, min.y));
    }
    if (direction == EngineDirection.down) {
      return Aabb2.minMax(Vector2(min.x, max.y), Vector2(max.x, double.infinity));
    }
    if (direction == EngineDirection.left) {
      return Aabb2.minMax(Vector2(-double.infinity, min.y), Vector2(min.x, max.y));
    }
    if (direction == EngineDirection.right) {
      return Aabb2.minMax(Vector2(max.x, min.y), Vector2(double.infinity, max.y));
    }
    throw UnimplementedError("Invalid direction");
  }
}

abstract class EngineContext {
  EngineQueryResult query(Aabb2 aabb, Vector2 direction, {EngineTile? excludeTile});
}