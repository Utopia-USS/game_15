import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:game_15/game/game_model.dart';
import 'package:game_15/game/game_values.dart';

class GameEngine {
  late final _model = ValueNotifier<GameModel>(_buildInitialModel());

  ValueListenable<GameModel> get model => _model;

  int? _currentIndex;
  Alignment? _offset;

  void onPanStart(Alignment position) {
    _currentIndex = _findIndex(position);
    if (_currentIndex != null) _offset = position - _model.value.positions[_currentIndex!];
  }

  void onPanUpdate(Alignment position) {
    if (_currentIndex != null) {
      _model.value = _model.value.update(
        _currentIndex!,
        (it) => GameValues.allowedPositionRect.clamp(position - _offset!),
      );
    }
  }

  void onPanEnd() {
    _currentIndex = null;
  }

  GameModel _buildInitialModel() {
    return GameModel(
      positions: [for (int i = 0; i < GameValues.childCount; i++) GameValues.alignmentFor(i)],
    );
  }

  int? _findIndex(Alignment position) {
    for (int i = 0; i < GameValues.childCount; i++) {
      if (model.value.getRect(i).contains(position)) return i;
    }
  }
}
