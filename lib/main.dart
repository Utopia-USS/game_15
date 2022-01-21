import 'dart:math';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

void main() {
  runApp(const MaterialApp(home: MyHomePage()));
}

class MyHomePage extends HookWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = useAnimationController(duration: const Duration(seconds: 2));

    useEffect(() {
      Future.microtask(() => controller.repeat(reverse: true));
    }, []);

    return Scaffold(
      appBar: AppBar(),
      body: SizedBox(
        width: double.infinity,
        child: AspectRatio(
          aspectRatio: 1,
          child: Game(
            model: useMemoized(() => controller.drive(GameModelAnimatable(initialModel: _generateInitialModel()))),
            child: Scaffold(appBar: AppBar(title: Text("Ryłko i koko chuj ci w oko"))),
          ),
        ),
      ),
    );
  }

  GameModel _generateInitialModel() {
    final random = Random();
    return GameModel(
      positions: [
        for (int i = 0; i < _gameChildCount; i++) Alignment(random.nextDouble() * 2 - 1, random.nextDouble() * 2 - 1),
      ],
    );
  }
}

const _gameChildCount = 15;
const _gameDimension = 4;

class GameModel {
  final List<Alignment> positions;

  const GameModel({required this.positions});
}

class GameModelAnimatable extends Animatable<GameModel> {
  final GameModel initialModel;

  GameModelAnimatable({required this.initialModel});

  @override
  GameModel transform(double t) {
    final t2 = 2 * t - 1; // [0,1] -> [-1,1]
    return GameModel(positions: [for (final position in initialModel.positions) position * t2]);
  }
}

class Game extends SingleChildRenderObjectWidget {
  final ValueListenable<GameModel> model;

  const Game({Key? key, required this.model, required Widget child}) : super(key: key, child: child);

  @override
  RenderObject createRenderObject(BuildContext context) => GameRenderBox(model: model);
}

class GameRenderBox extends RenderProxyBox {
  final ValueListenable<GameModel> model;

  GameRenderBox({required this.model});

  final _gameLayerHandle = LayerHandle(GameLayer());

  get _gameLayer => _gameLayerHandle.layer;

  @override
  void attach(covariant PipelineOwner owner) {
    super.attach(owner);
    model.addListener(markNeedsPaint);
  }

  @override
  void detach() {
    model.removeListener(markNeedsPaint);
    super.detach();
  }

  @override
  void dispose() {
    _gameLayer.layer!.dispose();
    super.dispose();
  }

  @override
  bool get isRepaintBoundary => true;

  @override
  bool get alwaysNeedsCompositing => true;

  @override
  void paint(PaintingContext context, Offset offset) {
    final childSize = size / _gameDimension.toDouble();
    // maps [-1,1] -> [-1,(1-childSize)] so that child is never outside of parent
    final effectiveOffset = (size - childSize) as Offset;
    final layerModel = <GameLayerModelItem>[];
    for (int i = 0; i < _gameDimension; i++) {
      for (int j = 0; j < _gameDimension; j++) {
        final childIndex = i * _gameDimension + j;
        if (childIndex < _gameChildCount) {
          final childOffset = Offset(childSize.width * i, childSize.height * j);
          final parentOffset = model.value.positions[childIndex].alongOffset(effectiveOffset);
          final parentRect = (parentOffset & childSize).translate(offset.dx, offset.dy);
          layerModel.add(GameLayerModelItem(clipRect: parentRect, offset: offset + parentOffset - childOffset));
        }
      }
    }

    _gameLayer.model = layerModel;
    context.pushLayer(_gameLayer, super.paint, offset);
  }
}

class GameLayerModelItem {
  final Rect clipRect;
  final Offset offset;

  const GameLayerModelItem({required this.clipRect, required this.offset});
}

typedef GameLayerModel = List<GameLayerModelItem>;

class GameLayer extends ContainerLayer {
  GameLayerModel? _model;

  set model(GameLayerModel? model) {
    _model = model;
    markNeedsAddToScene();
  }

  final _storage = EngineLayerStorage();

  @override
  void dispose() {
    _storage.dispose();
    super.dispose();
  }

  // TODO retain clip and offset layers
  // TODO support retained rendering
  @override
  void addToScene(ui.SceneBuilder builder) {
    if (_model == null || firstChild == null) return;
    for (int run = 0; run < _gameChildCount; run++) {
      final item = _model![run];
      builder
        ..pushClipRect(item.clipRect)
        ..pushOffset(item.offset.dx, item.offset.dy);

      _recursivelyMarkNeedsAddToScene(firstChild!);
      firstChild!.addToScene(MySceneBuilder(builder, storage: _storage, run: run));

      builder
        ..pop()
        ..pop();
    }
    _storage.disposeUnused();
  }

  void _recursivelyMarkNeedsAddToScene(Layer layer) {
    layer.markNeedsAddToScene();
    if (layer is ContainerLayer) {
      Layer? child = layer.firstChild;
      while (child != null) {
        _recursivelyMarkNeedsAddToScene(child);
        child = child.nextSibling;
      }
    }
  }
}

class EngineLayerStorage {
  final _layers = <ui.EngineLayer, List<ui.EngineLayer>>{};
  final _usedKeyLayers = <ui.EngineLayer>{};

  T execute<T extends ui.EngineLayer>(int run, T? keyLayer, T Function(T? oldLayer) block) {
    final effectiveKeyLayer = keyLayer != null && keyLayer is FakeEngineLayer ? keyLayer : FakeEngineLayer.create<T>();
    _layers[effectiveKeyLayer] ??= [];
    final layerList = _layers[effectiveKeyLayer]!;

    if (layerList.length <= run) {
      layerList.add(block(null));
    } else {
      layerList[run] = block(layerList[run] as T);
    }

    _usedKeyLayers.add(effectiveKeyLayer);
    return effectiveKeyLayer;
  }

  void disposeUnused() {
    final keysToRemove = <ui.EngineLayer>{};
    for (final keyLayer in _layers.keys) {
      if (!_usedKeyLayers.contains(keyLayer)) {
        for (final layer in _layers[keyLayer]!) {
          layer.dispose();
          keysToRemove.add(keyLayer);
        }
      }
    }
    for (final key in keysToRemove) {
      _layers.remove(key);
    }
    _usedKeyLayers.clear();
  }

  void dispose() {
    for (final layers in _layers.values) {
      for (final layer in layers) {
        layer.dispose();
      }
    }
  }
}

class FakeEngineLayer implements ui.EngineLayer {
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

class MySceneBuilder implements ui.SceneBuilder {
  final ui.SceneBuilder delegate;
  final EngineLayerStorage storage;
  final int run;

  const MySceneBuilder(this.delegate, {required this.storage, required this.run});

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
      storage.execute(run, oldLayer, (oldLayer) => delegate.pushOpacity(alpha, offset: offset, oldLayer: oldLayer));

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
