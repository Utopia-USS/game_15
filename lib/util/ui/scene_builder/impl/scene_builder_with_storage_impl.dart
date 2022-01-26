import 'dart:ui' as ui;

import 'package:game_15/util/ui/engine_layer/engine_layer_storage.dart';
import 'package:game_15/util/ui/scene_builder/scene_builder_with_storage.dart';

class SceneBuilderWithStorageImpl extends SceneBuilderWithStorage {
  const SceneBuilderWithStorageImpl(ui.SceneBuilder delegate, {required EngineLayerStorage storage, required int index})
      : super.base(delegate, storage: storage, index: index);
}
