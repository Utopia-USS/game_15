import 'package:flutter/material.dart';
import 'package:game_15/widgets/camera/state/use_camera_screen_state.dart';

class CameraTopOptions extends StatelessWidget {
  final CameraScreenState state;
  final double layoutSize;

  const CameraTopOptions({Key? key, required this.state, required this.layoutSize}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = layoutSize / 15;
    return Positioned(
      top: size,
      right: size,
      child: _buildIcon(size),
    );
  }

  Widget _buildIcon(double size) {
    return GestureDetector(
      onTap: state.switchCamera,
      behavior: HitTestBehavior.opaque,
      child: Container(
        width: size,
        height: size,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.4),
              spreadRadius: size / 6,
              blurRadius: size,
              offset: const Offset(0, 0), // changes position of shadow
            ),
          ],
        ),
        child: const Icon(Icons.flip_camera_android_sharp, color: Colors.white),
      ),
    );
  }
}
