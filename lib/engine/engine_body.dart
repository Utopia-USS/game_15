import 'dart:math';

import 'package:game_15/game/game_values.dart';
import 'package:game_15/util/vector/vector_extensions.dart';
import 'package:vector_math/vector_math_64.dart';

class EngineDirection {
  const EngineDirection._();

  static final up = Vector2(0, -1);
  static final down = Vector2(0, 1);
  static final left = Vector2(-1, 0);
  static final right = Vector2(1, 0);
  static final downRight = (down + right).normalized();
}

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

abstract class EngineBody {
  double? handleQuery(EngineQueryRequest request);

  bool move(EngineContext context, Vector2 direction, double distance);
}

class EngineTile implements EngineBody {
  Vector2 position;

  final int? debugIndex;

  EngineTile({required this.position, this.debugIndex});

  Aabb2 get aabb => Aabb2.centerAndHalfExtents(position, GameValues.halfChildExtent);

  @override
  double? handleQuery(EngineQueryRequest request) {
    if (request.aabbExtension.intersectsWithAabb2Strict(aabb)) {
      return (position - request.aabb.center).dot(request.direction) - GameValues.halfChildSize;
    }
  }

  @override
  bool move(EngineContext context, Vector2 direction, double distance) {
    final queryResult = context.query(aabb, direction, excludeTile: this);
    final unobstructedDistance = max(0.0, queryResult.distance - GameValues.halfChildSize);
    if (unobstructedDistance >= distance) {
      position.add(direction * distance);
      return true;
    } else {
      position.add(direction * unobstructedDistance);
      final distanceLeft = distance - unobstructedDistance;
      final canMove = queryResult.body.move(context, direction, distanceLeft);
      if (canMove) position.add(direction * distanceLeft);
      return canMove;
    }
  }
}

class EngineContainer implements EngineBody {
  Vector2 translation = Vector2.zero();

  @override
  double handleQuery(EngineQueryRequest request) {
    final target = Vector2.all(request.direction.dot(EngineDirection.downRight) > 0 ? 1 : 0);
    return (target - request.aabb.center).dot(request.direction);
  }

  @override
  bool move(EngineContext context, Vector2 direction, double distance) {
    translation.add(direction * distance);
    return false;
  }
}
