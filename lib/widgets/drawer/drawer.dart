import 'package:flutter/widgets.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:game_15/widgets/drawer/state/drawer_state.dart';
import 'package:game_15/widgets/drawer/view/drawer_view.dart';
import 'package:game_15/model/item_color.dart';

class DrawerWidget extends HookWidget {
  const DrawerWidget({Key? key}) : super(key: key);

  static final color = ItemColor.lavender;

  @override
  Widget build(BuildContext context) {
    final state = useDrawerState();
    return DrawerView(state: state);
  }
}
