import 'package:game_15/engine/engine_body.dart';
import 'package:game_15/engine/engine_context.dart';
import 'package:game_15/engine/engine_direction.dart';
import 'package:game_15/game/game_values.dart';
import 'package:game_15/game/model/game_model.dart';
import 'package:vector_math/vector_math_64.dart';

class _PanData {
  final int index;
  Vector2 lastPosition;

  _PanData({required this.index, required this.lastPosition});
}

class Engine implements EngineQueryContext {
  _PanData? _currentPan;
  final List<EngineTile> _tiles;
  final _container = EngineContainer();

  Engine({required List<Vector2> initialPositions}) : _tiles = _buildInitialTiles(initialPositions);

  List<EngineBody> get _bodies => [_container, ..._tiles];

  void update(Duration duration) {
    if (_currentPan == null) {
      for (final body in _bodies) {
        body.updateFreely(duration.inMicroseconds / Duration.microsecondsPerSecond);
      }
    }
  }

  GameModel buildModel() {
    return GameModel(
      translation: _container.translation,
      positions: [for (final tile in _tiles) tile.position],
    );
  }

  void onPanStart(Vector2 position) {
    final index = _findBodyIndex(position);
    if (index != null) {
      _currentPan = _PanData(index: index, lastPosition: position);
    }
  }

  void onPanUpdate(Vector2 position) {
    if (_currentPan != null) {
      final offset = position - _currentPan!.lastPosition;
      final horizontalDirection = offset.x < 0 ? EngineDirection.left : EngineDirection.right;
      final verticalDirection = offset.y < 0 ? EngineDirection.up : EngineDirection.down;
      final tile = _tiles[_currentPan!.index];
      tile.move(this, horizontalDirection, offset.x.abs());
      tile.move(this, verticalDirection, offset.y.abs());
      _currentPan!.lastPosition = position;
    }
  }

  void onPanEnd() {
    _currentPan = null;
  }

  @override
  EngineQueryResult query(Aabb2 aabb, Vector2 direction, {EngineTile? excludeTile}) {
    final request = EngineQueryRequest(aabb: aabb, direction: direction);
    var result = EngineQueryResult(body: _container, distance: _container.handleQuery(request));
    for (final tile in _tiles) {
      if (tile != excludeTile) {
        final distance = tile.handleQuery(request);
        if (distance != null && distance < result.distance) {
          result = EngineQueryResult(body: tile, distance: distance);
        }
      }
    }
    return result;
  }

  int? _findBodyIndex(Vector2 position) {
    for (int i = 0; i < _tiles.length; i++) {
      if (_tiles[i].aabb.containsVector2(position)) return i;
    }
    return null;
  }

  static List<EngineTile> _buildInitialTiles(List<Vector2> positions) =>
      [for (int i = 0; i < GameValues.childCount; i++) EngineTile(position: positions[i], debugIndex: i)];
}
