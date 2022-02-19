import 'package:flutter/material.dart';
import 'package:game_15/widgets/drawer/state/drawer_state.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';

import '../drawer.dart';

class DrawerContent extends StatelessWidget {
  final DrawerState state;

  const DrawerContent({Key? key, required this.state}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controllerValue = state.animationController.value;
    final double slideContent = -DrawerWidget.contentSlideValue * (1 - state.animationController.value);
    final scale = 1 - 0.22 * (1 - state.animation);
    final opacity = controllerValue < 0.6 ? 0.0 : 1.0 - 2.5 * (1 - controllerValue);
    return Transform(
      transform: Matrix4.identity()
        ..translate(slideContent)
        ..scale(scale),
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.only(left: 30.0),
        child: Opacity(
          opacity: opacity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildItem(LineAwesomeIcons.font_awesome),
              _buildItem(LineAwesomeIcons.user),
              _buildItem(LineAwesomeIcons.fire),
              _buildItem(LineAwesomeIcons.dropbox),
              _buildItem(LineAwesomeIcons.file),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildItem(IconData data) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 14.0),
      child: Icon(
        data,
        size: 32,
        color: Colors.white,
      ),
    );
  }
}
