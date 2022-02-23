import 'dart:ui' as ui;

import 'package:flutter/rendering.dart';
import 'package:game_15/util/kaleidoscope/kaleidoscope_shard.dart';
import 'package:game_15/util/ui/engine_layer/keyed_engine_layer_storage.dart';
import 'package:game_15/util/ui/scene_builder/scene_builder_with_storage.dart';

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

  final _layers = <ui.EngineLayer?>[null, null];

  // TODO retain layers
  // TODO support retained rendering
  @override
  void addToScene(ui.SceneBuilder builder) {
    if (_model == null || firstChild == null) return;
    for (int index = 0; index < _model!.length; index++) {
      final builderWithStorage = SceneBuilderWithStorage(builder, storage: _storage, index: index);
      final shard = _model![index];
      _layers[0] = builderWithStorage.pushTransform(
        shard.transform.storage,
        oldLayer: _layers[0] as ui.TransformEngineLayer?,
      );
      _layers[1] = shard.clip.push(builderWithStorage, oldLayer: _layers[1]);

      _recursivelyMarkNeedsAddToScene(firstChild!);

      firstChild!.addToScene(builderWithStorage);

      builderWithStorage
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
