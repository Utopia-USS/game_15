import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
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
    final color = DrawerWidget.color;
    return Material(
      child: AnimatedBuilder(
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
              child: Stack(
                children: [
                  DrawerContent(state: state),
                  DrawerScreen(state: state),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
