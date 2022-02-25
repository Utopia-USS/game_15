import 'package:flutter/material.dart';
import 'package:game_15/widgets/drawer/state/drawer_state.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';

class DrawerContent extends StatelessWidget {
  final DrawerState state;
  final double size;

  const DrawerContent({Key? key, required this.state, required this.size}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final slideValue = size / 14 * 3;
    final iconSize = size / 12;
    final controllerValue = state.animationController.value;
    final double slideContent = -slideValue * (1 - state.animationController.value);
    final scale = 1 - 0.5 * (1 - state.animation);
    final opacity = controllerValue < 0.6 ? 0.0 : 1.0 - 2.5 * (1 - controllerValue);
    return Transform(
      transform: Matrix4.identity()
        ..translate(slideContent)
        ..scale(scale),
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: EdgeInsets.only(left: slideValue),
        child: Opacity(
          opacity: opacity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildItem(LineAwesomeIcons.font_awesome, iconSize),
              _buildItem(LineAwesomeIcons.user, iconSize),
              _buildItem(LineAwesomeIcons.fire, iconSize),
              _buildItem(LineAwesomeIcons.alternate_money_bill, iconSize),
              _buildItem(LineAwesomeIcons.file, iconSize),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildItem(IconData data, double size) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: size / 2),
      child: Icon(
        data,
        size: size,
        color: Colors.white,
      ),
    );
  }
}
