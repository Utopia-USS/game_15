import 'package:flutter/cupertino.dart';

class GameConfig {
  final Decoration? decoration;
  final Decoration? foregroundDecoration;
  final int moves;
  final Duration animationDuration;
  final Curve animationCurve;

  const GameConfig({
    this.decoration,
    this.foregroundDecoration,
    required this.moves,
    required this.animationDuration,
    required this.animationCurve,
  });
}
