import 'dart:ui' as ui;

import 'package:game_15/util/ui/engine_layer/keyed_engine_layer_storage.dart';
import 'package:game_15/util/ui/scene_builder/scene_builder_with_storage.dart';

class SceneBuilderWithStorageImpl extends SceneBuilderWithStorage {
  const SceneBuilderWithStorageImpl(
    ui.SceneBuilder delegate, {
    required KeyedEngineLayerStorage storage,
    required int index,
  }) : super.base(delegate, storage: storage, index: index);
}
