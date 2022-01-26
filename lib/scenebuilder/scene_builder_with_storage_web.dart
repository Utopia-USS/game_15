import 'dart:ui' as ui;

import 'package:game_15/main.dart';
import 'package:game_15/scenebuilder/base_scene_builder_with_storage.dart';

class SceneBuilderWithStorage extends BaseSceneBuilderWithStorage {
  const SceneBuilderWithStorage(ui.SceneBuilder delegate, {required EngineLayerStorage storage, required int run})
      : super(delegate, storage: storage, run: run);

  @override
  void setProperties(
    double width,
    double height,
    double insetTop,
    double insetRight,
    double insetBottom,
    double insetLeft,
    bool focusable,
  ) =>
      delegate.setProperties(width, height, insetTop, insetRight, insetBottom, insetLeft, focusable);
}
