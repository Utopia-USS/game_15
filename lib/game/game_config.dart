import 'package:flutter/cupertino.dart';

class GameConfig {
  final Decoration? decoration;
  final Decoration? foregroundDecoration;
  final int moves;
  final Function() onWon;

  const GameConfig({this.decoration, this.foregroundDecoration, required this.moves, required this.onWon});
}