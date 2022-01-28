import 'dart:math';

import 'package:game_15/game/game_values.dart';
import 'package:vector_math/vector_math_64.dart';
import 'package:game_15/util/vector/vector_extensions.dart';

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

  late final extendedAabb = aabb.extendedBy(direction * double.infinity);
  late final directionCrossDownRight = direction.cross(EngineDirection.downRight);
  late final directionCrossHalfChildExtentAbs = direction.cross(GameValues.halfChildExtent).abs();
}

abstract class EngineContext {
  EngineQueryResult query(Aabb2 aabb, Vector2 direction);
}

abstract class EngineBody {
  double? handleQuery(EngineQueryRequest request);
  bool move(EngineContext context, Vector2 direction, double distance);
}

class EngineTile implements EngineBody {
  Vector2 position;

  EngineTile({required this.position});

  Aabb2 get aabb => Aabb2.centerAndHalfExtents(position, GameValues.halfChildExtent - Vector2.all(0.001));

  @override
  double? handleQuery(EngineQueryRequest request) {
    if(request.extendedAabb.intersectsWithAabb2()) {
      return (position - request.aabb.center).cross(request.direction) - request.directionCrossHalfChildExtentAbs;
    }
  }

  @override
  bool move(EngineContext context, Vector2 direction, double distance) {
    final queryResult = context.query(aabb, direction);
    final unobstructedDistance = queryResult.distance - GameValues.halfChildSize;
    if(unobstructedDistance >= distance) {
      position.add(direction * distance);
      return true;
    } else {
      position.add(direction * unobstructedDistance);
      final distanceLeft = distance - unobstructedDistance;
      final canMove = queryResult.body.move(context, direction, distanceLeft);
      if(canMove) position.add(direction * distanceLeft);
      return canMove;
    }
  }
}

class EngineContainer implements EngineBody {
  Vector2 translation = Vector2.zero();

  @override
  double handleQuery(EngineQueryRequest request) {
    final target = Vector2.all(request.directionCrossDownRight > 0 ? 1 : 0);
    return (target - request.aabb.center).cross(request.direction);
  }

  @override
  bool move(EngineContext context, Vector2 direction, double distance) {
    translation.add(direction * distance);
    return false;
  }
}
