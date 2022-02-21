import 'package:flutter/cupertino.dart';
import 'package:flutter/rendering.dart';

import 'kaleidoscope_delegate.dart';
import 'kaleidoscope_layer.dart';

class Kaleidoscope extends SingleChildRenderObjectWidget {
  final KaleidoscopeDelegate delegate;

  Kaleidoscope({Key? key, required this.delegate, required Widget child})
      : super(key: key, child: RepaintBoundary.wrap(child, 0));

  @override
  RenderObject createRenderObject(BuildContext context) => _RenderKaleidoscope(delegate);

  @override
  void updateRenderObject(BuildContext context, _RenderKaleidoscope renderObject) {
    renderObject.delegate = delegate;
  }
}

class _RenderKaleidoscope extends RenderProxyBox {
  KaleidoscopeDelegate _delegate;

  _RenderKaleidoscope(this._delegate) : super();

  final _kaleidoscopeLayerHandle = LayerHandle(KaleidoscopeLayer());

  KaleidoscopeLayer get _kaleidoscopeLayer => _kaleidoscopeLayerHandle.layer!;

  set delegate(KaleidoscopeDelegate delegate) {
    if (delegate == _delegate) return;

    if (delegate.runtimeType != _delegate.runtimeType || delegate.shouldRepaint(_delegate)) markNeedsPaint();

    _delegate.repaint?.removeListener(markNeedsPaint);
    delegate.repaint?.addListener(markNeedsPaint);
    _delegate = delegate;
  }

  @override
  void attach(covariant PipelineOwner owner) {
    super.attach(owner);
    _delegate.repaint?.addListener(markNeedsPaint);
  }

  @override
  void detach() {
    _delegate.repaint?.removeListener(markNeedsPaint);
    super.detach();
  }

  @override
  void dispose() {
    _kaleidoscopeLayerHandle.layer = null;
    super.dispose();
  }

  @override
  bool get isRepaintBoundary => true;

  @override
  bool get alwaysNeedsCompositing => true;

  @override
  bool hitTestChildren(BoxHitTestResult result, {required Offset position}) => false;

  @override
  void paint(PaintingContext context, Offset offset) {
    final shardCount = _delegate.shardCount;
    final layerModel = [
      for (int index = 0; index < shardCount; index++) _delegate.getShard(size, index).translate(offset),
    ];
    _kaleidoscopeLayer.model = layerModel;
    context.pushLayer(_kaleidoscopeLayer, super.paint, offset);
  }
}
