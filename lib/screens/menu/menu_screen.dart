import 'package:flutter/widgets.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:game_15/screens/menu/state/menu_screen_state.dart';
import 'package:game_15/screens/menu/view/menu_screen_view.dart';
import 'package:provider/provider.dart';

class MenuScreen extends HookWidget {

  const MenuScreen( {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final state = useMenuScreenState();
    return MenuScreenView(state: state);
  }

  static Future<void> show(BuildContext context) async {
    Navigator.of(context).push(
      PageRouteBuilder(
        opaque: false,
        pageBuilder: (context, animation, secondaryAnimation) {
          return ListenableProvider(
            create: (context) => animation,
            child: MenuScreen(),
          );
        },
        transitionDuration: const Duration(milliseconds: 2000),
      ),
    );
  }
}
