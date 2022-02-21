import 'package:flutter/widgets.dart';

class KaleidoscopeShard {
  /// specifies fragment of child to be used in this shard
  final Rect src;

  /// specifies position of this shard in parent
  final Offset dst;

  const KaleidoscopeShard({required this.src, required this.dst});

  KaleidoscopeShard translate(Offset offset) => KaleidoscopeShard(src: src.shift(offset), dst: dst + offset);

  // derivative fields, used during rendering

  /// translation which needs to be applied to child, so that [src] is in right position of parent
  Offset get offset => dst - src.topLeft;

  /// region in parent to be clipped during painting this shard
  Rect get clip => dst & src.size;
}

abstract class KaleidoscopeDelegate {
  final Listenable? repaint;

  const KaleidoscopeDelegate({this.repaint});

  int get shardCount;

  KaleidoscopeShard getShard(Size size, int index);

  bool shouldRepaint(covariant KaleidoscopeDelegate other);
}