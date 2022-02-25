import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:game_15/screens/menu/state/menu_screen_state.dart';
import 'package:game_15/screens/menu/widgets/menu_background.dart';
import 'package:game_15/screens/menu/widgets/menu_content.dart';
import 'package:provider/provider.dart';

class MenuScreenView extends StatelessWidget {
  final MenuScreenState state;

  const MenuScreenView({Key? key, required this.state}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final animation = Provider.of<Animation<double>>(context, listen: false);
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: AnimatedBuilder(
        animation: animation,
        builder: (context, child) {
          return Stack(
            children: [
              MenuBackground(animation: animation),
              MenuContent(
                animation: animation,
                onItemPressed: state.onTypeChanged,
              ),
            ],
          );
        },
      ),
    );
  }
}
