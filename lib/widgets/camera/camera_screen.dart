import 'package:flutter/widgets.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:permission_handler/permission_handler.dart';
import './state/use_camera_screen_state.dart';
import './view/camera_screen_view.dart';

class CameraWidget extends HookWidget {
  const CameraWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final state = useCameraScreenState();
    return CameraScreenView(state: state);
  }

  static Future<bool> checkPermissions() async {
    var cameraStatus = await Permission.camera.status;
    if (!cameraStatus.isGranted) {
      cameraStatus = await Permission.camera.request();
    }
    if (!cameraStatus.isGranted) return false;

    var microphoneStatus = await Permission.microphone.status;
    if (!microphoneStatus.isGranted) {
      microphoneStatus = await Permission.microphone.request();
    }
    if (!microphoneStatus.isGranted) return false;

    return true;
  }
}
