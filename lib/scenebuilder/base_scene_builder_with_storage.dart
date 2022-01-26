import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/rendering.dart';
import 'package:game_15/main.dart';

abstract class BaseSceneBuilderWithStorage implements ui.SceneBuilder {
  final ui.SceneBuilder delegate;
  final EngineLayerStorage storage;
  final int run;

  const BaseSceneBuilderWithStorage(this.delegate, {required this.storage, required this.run});

  @override
  ui.TransformEngineLayer pushTransform(Float64List matrix4, {ui.TransformEngineLayer? oldLayer}) =>
      storage.execute(run, oldLayer, (oldLayer) => delegate.pushTransform(matrix4, oldLayer: oldLayer));

  @override
  ui.PhysicalShapeEngineLayer pushPhysicalShape({
    required Path path,
    required double elevation,
    required Color color,
    Color? shadowColor,
    Clip clipBehavior = Clip.none,
    ui.PhysicalShapeEngineLayer? oldLayer,
  }) {
    return storage.execute(
      run,
      oldLayer,
      (oldLayer) => delegate.pushPhysicalShape(
        path: path,
        elevation: elevation,
        color: color,
        shadowColor: shadowColor,
        clipBehavior: clipBehavior,
        oldLayer: oldLayer,
      ),
    );
  }

  @override
  ui.ShaderMaskEngineLayer pushShaderMask(
    Shader shader,
    Rect maskRect,
    BlendMode blendMode, {
    ui.ShaderMaskEngineLayer? oldLayer,
    FilterQuality filterQuality = FilterQuality.low,
  }) {
    return storage.execute(
      run,
      oldLayer,
      (oldLayer) => delegate.pushShaderMask(
        shader,
        maskRect,
        blendMode,
        filterQuality: filterQuality,
        oldLayer: oldLayer,
      ),
    );
  }

  @override
  ui.BackdropFilterEngineLayer pushBackdropFilter(
    ui.ImageFilter filter, {
    BlendMode blendMode = BlendMode.srcOver,
    ui.BackdropFilterEngineLayer? oldLayer,
  }) {
    return storage.execute(
      run,
      oldLayer,
      (oldLayer) => delegate.pushBackdropFilter(filter, blendMode: blendMode, oldLayer: oldLayer),
    );
  }

  @override
  ui.ImageFilterEngineLayer pushImageFilter(ui.ImageFilter filter, {ui.ImageFilterEngineLayer? oldLayer}) =>
      storage.execute(run, oldLayer, (oldLayer) => delegate.pushImageFilter(filter, oldLayer: oldLayer));

  @override
  ui.ColorFilterEngineLayer pushColorFilter(ColorFilter filter, {ui.ColorFilterEngineLayer? oldLayer}) =>
      storage.execute(run, oldLayer, (oldLayer) => delegate.pushColorFilter(filter, oldLayer: oldLayer));

  @override
  ui.OpacityEngineLayer pushOpacity(int alpha, {Offset? offset = Offset.zero, ui.OpacityEngineLayer? oldLayer}) =>
      storage.execute(
        run,
        oldLayer,
        (oldLayer) => delegate.pushOpacity(alpha, offset: offset ?? Offset.zero, oldLayer: oldLayer),
      );

  @override
  ui.ClipPathEngineLayer pushClipPath(
    Path path, {
    Clip clipBehavior = Clip.antiAlias,
    ui.ClipPathEngineLayer? oldLayer,
  }) {
    return storage.execute(
      run,
      oldLayer,
      (oldLayer) => delegate.pushClipPath(path, clipBehavior: clipBehavior, oldLayer: oldLayer),
    );
  }

  @override
  ui.ClipRRectEngineLayer pushClipRRect(
    RRect rrect, {
    Clip clipBehavior = Clip.antiAlias,
    ui.ClipRRectEngineLayer? oldLayer,
  }) {
    return storage.execute(
      run,
      oldLayer,
      (oldLayer) => delegate.pushClipRRect(rrect, clipBehavior: clipBehavior, oldLayer: oldLayer),
    );
  }

  @override
  ui.ClipRectEngineLayer pushClipRect(
    Rect rect, {
    Clip clipBehavior = Clip.antiAlias,
    ui.ClipRectEngineLayer? oldLayer,
  }) {
    return storage.execute(
      run,
      oldLayer,
      (oldLayer) => delegate.pushClipRect(rect, clipBehavior: clipBehavior, oldLayer: oldLayer),
    );
  }

  @override
  ui.OffsetEngineLayer pushOffset(double dx, double dy, {ui.OffsetEngineLayer? oldLayer}) =>
      storage.execute(run, oldLayer, (oldLayer) => delegate.pushOffset(dx, dy, oldLayer: oldLayer));

  @override
  void addPerformanceOverlay(int enabledOptions, ui.Rect bounds) =>
      delegate.addPerformanceOverlay(enabledOptions, bounds);

  @override
  void addPicture(ui.Offset offset, ui.Picture picture, {bool isComplexHint = false, bool willChangeHint = false}) =>
      delegate.addPicture(offset, picture, isComplexHint: isComplexHint, willChangeHint: willChangeHint);

  @override
  void addPlatformView(int viewId, {ui.Offset offset = Offset.zero, double width = 0.0, double height = 0.0}) =>
      delegate.addPlatformView(viewId, offset: offset, width: width, height: height);

  @override
  void addRetained(ui.EngineLayer retainedLayer) {
    throw UnimplementedError("Retained rendering is not supported");
  }

  @override
  void addTexture(
    int textureId, {
    ui.Offset offset = Offset.zero,
    double width = 0.0,
    double height = 0.0,
    bool freeze = false,
    ui.FilterQuality filterQuality = FilterQuality.low,
  }) =>
      delegate.addTexture(textureId,
          offset: offset, width: width, height: height, freeze: freeze, filterQuality: filterQuality);

  @override
  ui.Scene build() => delegate.build();

  @override
  void pop() => delegate.pop();

  @override
  void setCheckerboardOffscreenLayers(bool checkerboard) => delegate.setCheckerboardOffscreenLayers(checkerboard);

  @override
  void setCheckerboardRasterCacheImages(bool checkerboard) => delegate.setCheckerboardRasterCacheImages(checkerboard);

  @override
  void setRasterizerTracingThreshold(int frameInterval) => delegate.setRasterizerTracingThreshold(frameInterval);
}
