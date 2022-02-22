import 'dart:ui' as ui;

import 'package:game_15/util/ui/engine_layer/keyed_engine_layer_storage.dart';
import 'package:game_15/util/ui/scene_builder/scene_builder_with_storage.dart';

class SceneBuilderWithStorageImpl extends SceneBuilderWithStorage {
  const SceneBuilderWithStorageImpl(
    ui.SceneBuilder delegate, {
    required KeyedEngineLayerStorage storage,
    required int index,
  }) : super.base(delegate, storage: storage, index: index);

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
