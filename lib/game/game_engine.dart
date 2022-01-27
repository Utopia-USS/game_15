import 'package:game_15/game/game_model.dart';
import 'package:game_15/game/game_values.dart';
import 'package:game_15/util/vector/vector_extensions.dart';
import 'package:vector_math/vector_math_64.dart';

class _PanData {
  final int index;
  final Vector2 offset;

  const _PanData({required this.index, required this.offset});
}

class GameBody {
  final Vector2 position;

  Aabb2 get aabb => Aabb2.centerAndHalfExtents(position, GameValues.halfChildSize);
}

class GameEngine {
  _PanData? _currentPan;

  GameEngine() {
  }

  void update(Duration duration) {
  }

  GameModel buildModel() => GameModel(positions: [for (final body in _bodies) body.position]);

  void onPanStart(Vector2 position) {
    final index = _findBodyIndex(position);
    if (index != null) {
      _currentPan = _PanData(index: index, offset: position - _bodies[index].position);
    }
  }

  void onPanUpdate(Vector2 position) {
    if (_currentPan != null) {
      final body = _bodies[_currentPan!.index];
      body.applyForce(((position - _currentPan!.offset) - body.position).normalized());
    }
  }

  void onPanEnd() {
    _currentPan = null;
  }

  int? _findBodyIndex(Vector2 position) {
    final userData = _world.queryFirst(position.aabbAround(Vector2.all(0.01)).toF2())?.body.userData;
    if (userData is int) return userData;
  }

}
