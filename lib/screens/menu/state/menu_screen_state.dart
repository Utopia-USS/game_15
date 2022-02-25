import 'package:flutter/cupertino.dart';
import 'package:game_15/screens/menu/menu_screen.dart';
import 'package:game_15/state/game_type_state.dart';
import 'package:game_15/widgets/camera/camera.dart';
import 'package:game_15/widgets/camera/widget/no_camera_permissions_snackbar.dart';
import 'package:utopia_hooks/utopia_hooks.dart';

class MenuScreenState {
  final void Function(GameType, BuildContext context) onTypeChanged;

  const MenuScreenState({
    required this.onTypeChanged,
  });
}

MenuScreenState useMenuScreenState() {
  final typeState = useProvided<GameTypeState>();

  void changeAndPop(GameType type, BuildContext context) {
    typeState.onTypeChanged(type);
    Navigator.pop(context, MenuScreenResult.game_changed);
  }

  void onCameraTapped(GameType type, BuildContext context) async {
    final permissions = await ArCam.checkPermissions();
    if (permissions) {
      changeAndPop(type, context);
    } else {
      NoCameraPermissionsSnackbar.show(context);
    }
  }

  return MenuScreenState(
    onTypeChanged: (type, context) async {
      if (type != GameType.camera) {
        changeAndPop(type, context);
      } else {
        onCameraTapped(type, context);
      }
    },
  );
}
