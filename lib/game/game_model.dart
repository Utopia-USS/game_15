import 'package:flutter/cupertino.dart';
import 'package:game_15/game/game_values.dart';
import 'package:game_15/util/geometry/alignment_rect.dart';

class GameModel {
  final List<Alignment> positions;

  const GameModel({required this.positions});

  GameModel update(int index, Alignment Function(Alignment) block) =>
      GameModel(positions: [for(int i = 0; i < positions.length; i++) i == index ? block(positions[i]) : positions[i]]);

  AlignmentRect getRect(int index) => AlignmentRect.fromSize(positions[index], GameValues.childSize);
}