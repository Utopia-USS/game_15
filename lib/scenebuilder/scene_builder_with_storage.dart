import 'dart:ui' as ui;

import 'package:game_15/main.dart';
import 'package:game_15/scenebuilder/base_scene_builder_with_storage.dart';

class SceneBuilderWithStorage extends BaseSceneBuilderWithStorage {
  const SceneBuilderWithStorage(ui.SceneBuilder delegate, {required EngineLayerStorage storage, required int run})
      : super(delegate, storage: storage, run: run);
}
