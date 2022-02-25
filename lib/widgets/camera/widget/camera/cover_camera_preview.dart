import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';

class CoverCameraPreview extends StatelessWidget {
  final CameraController controller;

  const CoverCameraPreview({required this.controller});

  @override
  Widget build(BuildContext context) {
    return AspectRatio(aspectRatio: 1, child: CameraPreview(controller));
  }
}
