import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:game_15/screens/game/state/game_screen_state.dart';
import 'package:utopia_hooks/utopia_hooks.dart';

class CameraScreenState {
  final CameraController? cameraController;
  final bool initialized;

  final Future<void> Function() switchCamera;
  final void Function(double) onZoomChange;

  const CameraScreenState({
    required this.switchCamera,
    required this.cameraController,
    required this.initialized,
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
  final initializedState = useState<bool>(false);

  final cameraController = useCameraController(description: cameraDescriptionState.value);

  final cameraMaxZoomState = useState<double?>(null);
  final cameraZoomState = useState<double>(1);

  useSimpleEffect(() {
    if (cameras.data != null) cameraDescriptionState.value = cameras.data!.last;
  }, [cameras.hasData]);

  useSimpleEffect(() {
    if (cameraController != null) {
      cameraController.getMaxZoomLevel().then((value) {
        cameraMaxZoomState.value = value;
      });
    }
  }, [cameraController == null]);

  Future<void> changeCamera(CameraDescription description) async {
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
        await Future.delayed(const Duration(milliseconds: 1000));
        initializedState.value = true;
        await Future.delayed(gameState.initialDuration);
        gameState.gameController.perform?.call();
      });
    }
  }, [cameraController != null]);

  return CameraScreenState(
    cameraController: cameraController,
    initialized: initializedState.value,
    switchCamera: () async => await changeCamera(findNextCamera()),
    onZoomChange: (value) => cameraZoomState.value = value,
  );
}
