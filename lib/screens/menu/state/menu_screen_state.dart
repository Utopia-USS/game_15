import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:game_15/const/app_values.dart';
import 'package:game_15/screens/menu/menu_screen.dart';
import 'package:game_15/state/game_type_state.dart';
import 'package:game_15/widgets/camera/camera.dart';
import 'package:game_15/widgets/camera/widget/no_camera_permissions_snackbar.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:utopia_hooks/utopia_hooks.dart';

class MenuScreenState {
  final void Function(GameType, BuildContext context) onTypeChanged;
  final void Function() onGithubPressed;

  const MenuScreenState({
    required this.onTypeChanged,
    required this.onGithubPressed,
  });
}

MenuScreenState useMenuScreenState() {
  final typeState = useProvided<GameTypeState>();

  void changeAndPop(GameType type, BuildContext context) {
    typeState.onTypeChanged(type);
    Navigator.pop(context, MenuScreenResult.game_changed);
  }

  void onCameraTapped(GameType type, BuildContext context) async {
    if (kIsWeb) return AppSnackbar.showCameraWeb(context);
    final permissions = await ArCam.checkPermissions();
    if (permissions) {
      changeAndPop(type, context);
    } else {
      AppSnackbar.showNoPermissions(context);
    }
  }

  void onTypeChanged(GameType type, BuildContext context) async {
    if (type != GameType.camera) {
      changeAndPop(type, context);
    } else {
      onCameraTapped(type, context);
    }
  }

  void launchGithub() => launch(AppValues.githubUrl);

  return MenuScreenState(
    onTypeChanged: onTypeChanged,
    onGithubPressed: launchGithub,
  );
}
