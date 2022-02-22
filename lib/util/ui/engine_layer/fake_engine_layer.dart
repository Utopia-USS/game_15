import 'dart:ui' as ui;

abstract class FakeEngineLayer implements ui.EngineLayer {
  @override
  void dispose() {}

  static final _map = {
    ui.TransformEngineLayer: FakeTransformEngineLayer.new,
    ui.PhysicalShapeEngineLayer: FakePhysicalShapeEngineLayer.new,
    ui.ShaderMaskEngineLayer: FakeShaderMaskEngineLayer.new,
    ui.BackdropFilterEngineLayer: FakeBackdropFilterEngineLayer.new,
    ui.ImageFilterEngineLayer: FakeImageFilterEngineLayer.new,
    ui.ColorFilterEngineLayer: FakeColorFilterEngineLayer.new,
    ui.OpacityEngineLayer: FakeOpacityEngineLayer.new,
    ui.ClipPathEngineLayer: FakeClipPathEngineLayer.new,
    ui.ClipRRectEngineLayer: FakeClipRRectEngineLayer.new,
    ui.ClipRectEngineLayer: FakeClipRectEngineLayer.new,
    ui.OffsetEngineLayer: FakeOffsetEngineLayer.new,
  };

  static T create<T extends ui.EngineLayer>() => _map[T]!() as T;
}

class FakeTransformEngineLayer extends FakeEngineLayer implements ui.TransformEngineLayer {}

class FakePhysicalShapeEngineLayer extends FakeEngineLayer implements ui.PhysicalShapeEngineLayer {}

class FakeShaderMaskEngineLayer extends FakeEngineLayer implements ui.ShaderMaskEngineLayer {}

class FakeBackdropFilterEngineLayer extends FakeEngineLayer implements ui.BackdropFilterEngineLayer {}

class FakeImageFilterEngineLayer extends FakeEngineLayer implements ui.ImageFilterEngineLayer {}

class FakeColorFilterEngineLayer extends FakeEngineLayer implements ui.ColorFilterEngineLayer {}

class FakeOpacityEngineLayer extends FakeEngineLayer implements ui.OpacityEngineLayer {}

class FakeClipPathEngineLayer extends FakeEngineLayer implements ui.ClipPathEngineLayer {}

class FakeClipRRectEngineLayer extends FakeEngineLayer implements ui.ClipRRectEngineLayer {}

class FakeClipRectEngineLayer extends FakeEngineLayer implements ui.ClipRectEngineLayer {}

class FakeOffsetEngineLayer extends FakeEngineLayer implements ui.OffsetEngineLayer {}