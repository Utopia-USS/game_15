import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:game_15/screens/game/state/game_screen_state.dart';
import 'package:utopia_hooks/utopia_hooks.dart';

enum CameraFileType { IMAGE, VIDEO }
enum CameraState { INITIALIZING, INITIALIZED }

class CameraScreenState {
  final CameraController? cameraController;
  final CameraState cameraState;

  final Function() switchCamera;
  final Function(double) onZoomChange;

  const CameraScreenState({
    required this.switchCamera,
    required this.cameraController,
    required this.cameraState,
    required this.onZoomChange,
  });
}

CameraController? useCameraController({required CameraDescription? description, FlashMode flashMode = FlashMode.off}) {
  final controllerState = useState<CameraController?>(null);
  final isPendingReinitializationState = useState<bool>(false);

  useEffect(() {
    controllerState.value = null;
    if (description != null) {
      final controller = CameraController(
        description,
        ResolutionPreset.high,
      );
      () async {
        try {
          await Future.delayed(Duration(seconds: 1));
          await controller.initialize();
          await controller.lockCaptureOrientation(DeviceOrientation.portraitUp);
          controllerState.value = controller;
        } catch (e, s) {
          print('camera initialization error: \n' + e.toString() + '\n' + s.toString());
        }
      }();
      return () => controller.dispose();
    }
  }, [description, isPendingReinitializationState.value]);

  useSimpleEffect(() {
    if (controllerState.value != null) {
      controllerState.value!.setFlashMode(flashMode);
    }
  }, [controllerState.value, flashMode]);

  useAppLifecycleStateCallbacks(
    onPaused: () {
      controllerState.value?.dispose();
      controllerState.value = null;
    },
    onResumed: () => isPendingReinitializationState.value = !isPendingReinitializationState.value,
  );

  return controllerState.value;
}

CameraScreenState useCameraScreenState() {
  final gameState = useProvided<GameScreenState>();
  final cameras = useFuture(useMemoized(() async => await availableCameras()), initialData: null);

  final cameraDescriptionState = useState<CameraDescription?>(null);
  final cameraState = useState<CameraState>(CameraState.INITIALIZING);

  FlashMode obtainFlashMode() => FlashMode.off;

  final cameraController = useCameraController(
    description: cameraDescriptionState.value,
    flashMode: obtainFlashMode(),
  );

  final cameraMaxZoomState = useState<double?>(null);
  final cameraZoomState = useState<double>(1);

  useSimpleEffect(() {
    if (cameras.data != null) cameraDescriptionState.value = cameras.data![0];
  }, [cameras.hasData]);

  useSimpleEffect(() {
    if (cameraController != null) {
      cameraController.getMaxZoomLevel().then((value) {
        cameraMaxZoomState.value = value;
      });
    }
  }, [cameraController == null]);

  changeCamera(CameraDescription description) async {
    cameraDescriptionState.value = description;
    cameraZoomState.value = 1;
  }

  CameraDescription findNextCamera() {
    final currentDirection = cameraController!.description.lensDirection;
    final nextDirection =
        currentDirection == CameraLensDirection.back ? CameraLensDirection.front : CameraLensDirection.back;
    return cameras.data!.firstWhere((element) => element.lensDirection == nextDirection);
  }

  useSimpleEffect(() async {
    await cameraController?.setZoomLevel(cameraZoomState.value.clamp(1, cameraMaxZoomState.value ?? 1));
  }, [cameraZoomState.value]);

  useSimpleEffect(() {
    if (cameraController != null) {
      WidgetsBinding.instance!.addPostFrameCallback((_) async {
        await Future.delayed(gameState.initialDuration);
        await Future.delayed(const Duration(milliseconds: 500));
        await Future.delayed(const Duration(milliseconds: 500));
        gameState.gameController.perform?.call();
      });
    }
  }, [cameraController]);

  return CameraScreenState(
    cameraController: cameraController,
    cameraState: cameraState.value,
    switchCamera: () async => await changeCamera(findNextCamera()),
    onZoomChange: (value) => cameraZoomState.value = value,
  );
}
