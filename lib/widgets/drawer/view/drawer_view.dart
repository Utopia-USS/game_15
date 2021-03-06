import 'package:flutter/material.dart';
import 'package:game_15/widgets/drawer/state/drawer_state.dart';
import 'package:game_15/widgets/drawer/widgets/drawer_content.dart';
import 'package:game_15/widgets/drawer/widgets/drawer_gesture_wrapper.dart';
import 'package:game_15/widgets/drawer/widgets/drawer_screen.dart';

import '../drawer.dart';

class DrawerView extends StatelessWidget {
  final DrawerState state;

  const DrawerView({Key? key, required this.state}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final color = CustomDrawer.color;
    return Material(
      child: LayoutBuilder(builder: (context, constraints) {
        final size = constraints.maxHeight;
        final slideValue = size / 1.75;
        return AnimatedBuilder(
          animation: state.animationController,
          builder: (context, animation) {
            return Container(
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                  colors: [color.accent, color.primary],
                ),
              ),
              child: DrawerGestureWrapper(
                animationController: state.animationController,
                offsetController: state.offsetState,
                slideValue: slideValue,
                child: Stack(
                  children: [
                    DrawerContent(state: state, size: size),
                    DrawerScreen(state: state, size: size, slideValue: slideValue),
                  ],
                ),
              ),
            );
          },
        );
      }),
    );
  }
}
