import 'package:flutter/material.dart';
import 'package:game_15/widgets/drawer/drawer.dart';
import 'package:game_15/widgets/drawer/state/drawer_state.dart';
import 'package:game_15/widgets/drawer/widgets/drawer_mock_item.dart';

class DrawerScreen extends StatelessWidget {
  final DrawerState state;

  const DrawerScreen({Key? key, required this.state}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const backgroundColor = Color(0xffF2F6FB);
    final controllerValue = state.animationController.value;
    final double slideContent = DrawerWidget.slideValue * controllerValue;
    final scale = 1 - (0.25 * controllerValue);
    final borderRadius = BorderRadius.circular(34 * controllerValue);
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
            appBar: _buildAppbar(),
            body: ListView.builder(
              itemCount: 10,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (_, __) {
                return const DrawerMockItem();
              },
            ),
          ),
        ),
      ),
    );
  }

  AppBar _buildAppbar() {
    const backgroundColor = Colors.white;
    final color = DrawerWidget.color;
    return AppBar(
      toolbarHeight: 80,
      backgroundColor: backgroundColor,
      elevation: 8,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          bottom: Radius.circular(10),
        ),
      ),
      leading: Padding(
        padding: const EdgeInsets.only(left: 16.0),
        child: Center(
          child: GestureDetector(
            onTap: state.triggerAnimation,
            child: Icon(Icons.menu, color: color.primary, size: 28,),
          ),
        ),
      ),
    );
  }
}
