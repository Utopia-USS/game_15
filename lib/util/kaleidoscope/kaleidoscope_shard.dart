import 'dart:ui' as ui;

import 'package:flutter/widgets.dart';

abstract class KaleidoscopeShardClip {
  ui.EngineLayer push(ui.SceneBuilder builder, {Clip clipBehaviour = Clip.antiAlias, ui.EngineLayer? oldLayer});

  bool contains(Offset offset);

  const factory KaleidoscopeShardClip.rect(Rect rect) = KaleidoscopeShardClipRect;

  const factory KaleidoscopeShardClip.rRect(RRect rRect) = KaleidoscopeShardClipRRect;

  const factory KaleidoscopeShardClip.path(Path path) = KaleidoscopeShardClipPath;

  static KaleidoscopeShardClip oval(Rect rect) => KaleidoscopeShardClip.path(Path()..addOval(rect));
}

class KaleidoscopeShardClipRect implements KaleidoscopeShardClip {
  final Rect rect;

  const KaleidoscopeShardClipRect(this.rect);

  @override
  ui.EngineLayer push(ui.SceneBuilder builder, {Clip clipBehaviour = Clip.antiAlias, ui.EngineLayer? oldLayer}) =>
      builder.pushClipRect(rect, clipBehavior: clipBehaviour, oldLayer: oldLayer as ui.ClipRectEngineLayer?);

  @override
  bool contains(Offset offset) => rect.contains(offset);
}

class KaleidoscopeShardClipRRect implements KaleidoscopeShardClip {
  final RRect rRect;

  const KaleidoscopeShardClipRRect(this.rRect);

  @override
  ui.EngineLayer push(ui.SceneBuilder builder, {Clip clipBehaviour = Clip.antiAlias, ui.EngineLayer? oldLayer}) =>
      builder.pushClipRRect(rRect, clipBehavior: clipBehaviour, oldLayer: oldLayer as ui.ClipRRectEngineLayer?);

  @override
  bool contains(Offset offset) => rRect.contains(offset);
}

class KaleidoscopeShardClipPath implements KaleidoscopeShardClip {
  final Path path;

  const KaleidoscopeShardClipPath(this.path);

  @override
  ui.EngineLayer push(ui.SceneBuilder builder, {Clip clipBehaviour = Clip.antiAlias, ui.EngineLayer? oldLayer}) =>
      builder.pushClipPath(path, clipBehavior: clipBehaviour, oldLayer: oldLayer as ui.ClipPathEngineLayer?);

  @override
  bool contains(Offset offset) => path.contains(offset);
}

class KaleidoscopeShard {
  /// clip region of [child]
  final KaleidoscopeShardClip clip;

  final Clip clipBehaviour;

  /// transform to be applied to the clipped region
  final Matrix4 transform;

  const KaleidoscopeShard({required this.clip, required this.transform, this.clipBehaviour = Clip.antiAlias});

  KaleidoscopeShard.fromSrcDst({required Rect src, required Offset dst, this.clipBehaviour = Clip.antiAlias})
      : clip = KaleidoscopeShardClip.rect(src),
        transform = Matrix4.translationValues(dst.dx - src.left, dst.dy - src.top, 0);
}
