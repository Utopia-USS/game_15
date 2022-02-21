import 'package:flutter/material.dart';
import 'package:game_15/model/item_color.dart';

class ColorPickerItem extends StatelessWidget {
  final Function() onPressed;
  final ItemColor color;
  final double size;

  const ColorPickerItem({Key? key, required this.color, required this.onPressed, required this.size}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: _buildContainer(),
    );
  }

  Widget _buildContainer() {
    return PhysicalModel(
      color: Colors.transparent,
      elevation: 40,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 1000),
        curve: Curves.bounceOut,
        height: size,
        width: size,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(size / 12),
          border: Border.all(color: Colors.white, width: 2.5),
          gradient: LinearGradient(
            end: Alignment.topRight,
            begin: Alignment.bottomLeft,
            colors: [
              color.primary,
              color.accent,
            ],
          ),
        ),
      ),
    );
  }
}
