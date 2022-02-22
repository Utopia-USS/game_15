import 'dart:ui' as ui;

import 'package:flutter/rendering.dart';
import 'package:game_15/util/ui/engine_layer/keyed_engine_layer_storage.dart';
import 'package:game_15/util/ui/scene_builder/scene_builder_with_storage.dart';

import 'kaleidoscope_delegate.dart';

typedef KaleidoscopeLayerModel = List<KaleidoscopeShard>;

class KaleidoscopeLayer extends ContainerLayer {
  KaleidoscopeLayerModel? _model;

  set model(KaleidoscopeLayerModel? model) {
    _model = model;
    markNeedsAddToScene();
  }

  final _storage = KeyedEngineLayerStorage();

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
    for (int index = 0; index < _model!.length; index++) {
      final shard = _model![index];
      builder
        ..pushClipRect(shard.clip)
        ..pushOffset(shard.offset.dx, shard.offset.dy);

      _recursivelyMarkNeedsAddToScene(firstChild!);

      final effectiveBuilder =
          index == 0 ? builder : SceneBuilderWithStorage(builder, storage: _storage, index: index - 1);

      firstChild!.addToScene(effectiveBuilder);

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
