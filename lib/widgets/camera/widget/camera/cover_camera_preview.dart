import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:game_15/widgets/camera/widget/camera/cover_fullscreen_wrapper.dart';

class CoverCameraPreview extends StatelessWidget {
  final CameraController controller;

  const CoverCameraPreview({required this.controller});

  @override
  Widget build(BuildContext context) {
    return CoverFullscreenWrapper(
      aspectRatio: controller.value.aspectRatio,
      child: CameraPreview(controller),
    );
  }
}
