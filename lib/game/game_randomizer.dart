import 'dart:math';

import 'package:equatable/equatable.dart';
import 'package:game_15/game/game_values.dart';
import 'package:vector_math/vector_math_64.dart';

class _Position extends Equatable {
  final int x, y;

  const _Position(this.x, this.y);

  @override
  get props => [x, y];

  bool isAdjacent(_Position other) => (x - other.x).abs() + (y - other.y).abs() == 1;
}

class EngineRandomizer {
  const EngineRandomizer._();

  static List<Vector2> generatePositions({required int moves}) {
    final random = Random();
    final positions = [for (int i = 0; i < GameValues.childCount; i++) _initialPositionFor(i)];
    _Position? prevHole;
    var hole = _initialPositionFor(GameValues.childCount);
    while (moves > 0) {
      final adjacentTileIndexes = _findAdjacentTileIndexes(positions, hole);
      final tileToMove = adjacentTileIndexes[random.nextInt(adjacentTileIndexes.length)];
      final oldPosition = positions[tileToMove];
      if (oldPosition == prevHole) continue; // workaround: prevent 1-move cycles
      positions[tileToMove] = hole;
      prevHole = hole;
      hole = oldPosition;
      moves--;
    }
    return positions.map(_transformPosition).toList();
  }

  static List<int> _findAdjacentTileIndexes(List<_Position> positions, _Position hole) {
    return [
      for (int i = 0; i < GameValues.childCount; i++)
        if (positions[i].isAdjacent(hole)) i,
    ];
  }

  static _Position _initialPositionFor(int i) => _Position(GameValues.xFor(i), GameValues.yFor(i));

  static Vector2 _transformPosition(_Position position) =>
      Vector2(GameValues.transformCoordinate(position.x), GameValues.transformCoordinate(position.y));
}
