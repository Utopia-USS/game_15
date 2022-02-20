import 'dart:math';

import 'package:game_15/engine/engine_context.dart';
import 'package:game_15/engine/engine_direction.dart';
import 'package:game_15/game/game_values.dart';
import 'package:game_15/util/vector/vector_extensions.dart';
import 'package:vector_math/vector_math_64.dart';

abstract class EngineBody {
  /// Handle distance query from the engine.
  ///
  /// Returns `null` if this body is outside the query's [request.direction].
  /// Otherwise, returns distance from [request.aabb]'s center to this body's nearest edge.
  double? handleQuery(EngineQueryRequest request);

  /// Try to move this body by [distance] in [direction].
  ///
  /// Returns `true` if the move "succeeded", i.e. body requesting the movement can assume there's now [distance] of
  /// free space in given [direction].
  bool move(EngineContext context, Vector2 direction, double distance);

  /// Let this body move freely for delta [time].
  void updateFreely(double time);
}

class EngineTile implements EngineBody {
  static const _teleportDistance = 0.005;
  static const _snapVelocity = 0.005;

  /// Position of this body's center.
  Vector2 position;

  final int? debugIndex;

  EngineTile({required this.position, this.debugIndex});

  Aabb2 get aabb => Aabb2.centerAndHalfExtents(position, GameValues.halfChildExtent);

  @override
  double? handleQuery(EngineQueryRequest request) {
    if (request.aabbExtension.intersectsWithAabb2Strict(aabb)) {
      return (position - request.aabb.center).dot(request.direction) - GameValues.halfChildSize;
    }
    return null;
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

  @override
  void updateFreely(double time) {
    position = Vector2(_update(position.x, time), _update(position.y, time));
  }

  double _update(double current, double time) {
    final closest = GameValues.closestPositionFor(current);
    final offset = closest - current;
    if (offset.abs() <= _teleportDistance) {
      return closest;
    } else {
      return current + offset.sign * min(offset.abs(), time * _snapVelocity);
    }
  }
}

class EngineContainer implements EngineBody {
  static const _velocityLengthRatio = 0.1;

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

  @override
  void updateFreely(double time) {
    final length = translation.length;
    final velocity = length * _velocityLengthRatio;
    final distance = min(length, velocity * time);
    translation -= translation * distance;
  }
}
