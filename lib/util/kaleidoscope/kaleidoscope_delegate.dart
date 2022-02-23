import 'package:flutter/widgets.dart';
import 'package:game_15/util/kaleidoscope/kaleidoscope_shard.dart';

abstract class KaleidoscopeDelegate {
  final Listenable? repaint;

  const KaleidoscopeDelegate({this.repaint});

  int get shardCount;

  KaleidoscopeShard getShard(Size size, int index);

  bool shouldRepaint(covariant KaleidoscopeDelegate other);
}
