import 'package:flutter/material.dart';
import 'package:game_15/widgets/drawer/state/drawer_state.dart';
import 'package:game_15/widgets/drawer/widgets/drawer_appbar.dart';
import 'package:game_15/widgets/drawer/widgets/drawer_mock_item.dart';

class DrawerScreen extends StatelessWidget {
  final double size;
  final double slideValue;
  final DrawerState state;

  const DrawerScreen({Key? key, required this.state, required this.size, required this.slideValue}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const backgroundColor = Color(0xffF2F6FB);
    final controllerValue = state.animationController.value;
    final double slideContent = slideValue * controllerValue;
    final scale = 1 - (0.25 * controllerValue);
    final borderRadius = BorderRadius.circular(10 + 24 * controllerValue);
    return Transform(
      transform: Matrix4.identity()
        ..translate(slideContent)
        ..scale(scale),
      alignment: Alignment.centerLeft,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.black87,
          borderRadius: borderRadius,
          boxShadow: [
            BoxShadow(
              color: Colors.black38.withOpacity(0.4 * state.animation),
              spreadRadius: 12,
              blurRadius: 90,
              offset: const Offset(-12, 24),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: borderRadius,
          child: Scaffold(
            backgroundColor: backgroundColor,
            body: Column(
              children: [
                DrawerAppBar(
                  toolbarHeight: size / 3,
                  onMenuPressed: () => state.triggerAnimation(slideValue),
                ),
                const DrawerMockItem(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
