import 'package:flutter/cupertino.dart';

class GameConfig {
  final Decoration? decoration;
  final Decoration? foregroundDecoration;
  final int moves;
  final Duration initialAnimationDuration;
  final Curve initialAnimationCurve;

  const GameConfig({
    this.decoration,
    this.foregroundDecoration,
    required this.moves,
    required this.initialAnimationDuration,
    required this.initialAnimationCurve,
  });
}
