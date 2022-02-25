import 'package:flutter/material.dart';

import '../drawer.dart';

class DrawerAppBar extends StatelessWidget {
  final double toolbarHeight;
  final void Function() onMenuPressed;

  const DrawerAppBar({Key? key, required this.toolbarHeight, required this.onMenuPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: toolbarHeight,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            offset: const Offset(2, 2),
            blurRadius: 6,
            spreadRadius: 1,
          ),
        ],
      ),
      child: _buildIcon(toolbarHeight / 3),
    );
  }

  Widget _buildIcon(double size) {
    final color = CustomDrawer.color;
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: EdgeInsets.only(left: size),
        child: GestureDetector(
          onTap: onMenuPressed,
          child: Icon(
            Icons.menu,
            color: color.primary,
            size: size,
          ),
        ),
      ),
    );
  }
}
