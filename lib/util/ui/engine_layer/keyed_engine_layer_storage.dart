import 'dart:math';
import 'dart:ui' as ui;

import 'package:game_15/util/ui/engine_layer/fake_engine_layer.dart';

class KeyedEngineLayerStorage {
  final _layers = <ui.EngineLayer, List<ui.EngineLayer>>{};
  final _usedKeyLayers = <ui.EngineLayer>{};
  int _maxUsedIndex = -1;

  T execute<T extends ui.EngineLayer>(int index, T? keyLayer, T Function(T? oldLayer) block) {
    final effectiveKeyLayer = keyLayer != null && keyLayer is FakeEngineLayer ? keyLayer : FakeEngineLayer.create<T>();
    _layers[effectiveKeyLayer] ??= [];
    final layerList = _layers[effectiveKeyLayer]!;

    if (layerList.length <= index) {
      layerList.add(block(null));
    } else {
      layerList[index] = block(layerList[index] as T);
    }

    _usedKeyLayers.add(effectiveKeyLayer);
    _maxUsedIndex = max(_maxUsedIndex, index);
    return effectiveKeyLayer;
  }

  void disposeUnused() {
    // remove entirely unused keys
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
    // remove layers from unused indexes
    final firstUnusedIndex = _maxUsedIndex + 1;
    if (_layers.isNotEmpty && firstUnusedIndex < _layers[_layers.keys.first]!.length) {
      for (final keyLayer in _layers.keys) {
        final layersToRemove = _layers[keyLayer]!.skip(firstUnusedIndex);
        for (final layer in layersToRemove) {
          layer.dispose();
        }
        _layers[keyLayer]!.length = firstUnusedIndex;
      }
    }
    _maxUsedIndex = -1;
  }

  void dispose() {
    for (final layers in _layers.values) {
      for (final layer in layers) {
        layer.dispose();
      }
    }
  }
}
