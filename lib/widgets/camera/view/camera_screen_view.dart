import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:game_15/widgets/camera/state/use_camera_screen_state.dart';
import 'package:game_15/widgets/camera/widget/camera/cover_camera_preview.dart';
import 'package:matrix_gesture_detector/matrix_gesture_detector.dart';

class CameraScreenView extends StatelessWidget {
  final CameraScreenState state;

  const CameraScreenView({required this.state});

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        _buildCameraPreview(context),
        _buildGradient(),
      ],
    );
  }

  Widget _buildCameraPreview(BuildContext context) {
    if (state.cameraController == null) return Container(color: Colors.transparent);
    return CoverCameraPreview(controller: state.cameraController!);
  }

  Widget _buildGradient() {
    final key = [state.cameraController?.description.lensDirection].toString();
    return MatrixGestureDetector(
      key: Key(key),
      shouldRotate: false,
      shouldTranslate: false,
      onMatrixUpdate: (Matrix4 m, Matrix4 tm, Matrix4 sm, Matrix4 rm) {
        final scale = MatrixGestureDetector.decomposeToValues(m).scale;
        state.onZoomChange(scale);
      },
      child: GestureDetector(
        onTap: () {
          if (state.cameraController != null) state.switchCamera();
        },
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: AlignmentDirectional.topCenter,
              end: AlignmentDirectional.bottomCenter,
              colors: [
                Colors.black.withOpacity(0.4),
                for (var i = 0; i < 9; i++) Colors.transparent,
                Colors.black.withOpacity(0.4),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
