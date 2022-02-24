import 'package:flutter/material.dart';
import 'package:game_15/widgets/drawer/drawer.dart';

class DrawerMockItem extends StatelessWidget {
  const DrawerMockItem({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const double radius = 10;
    final color = DrawerWidget.color;
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 36, 24, 0),
        child: PhysicalModel(
          color: Colors.transparent,
          shadowColor: color.primary,
          borderRadius: BorderRadius.circular(radius),
          elevation: 16,
          child: ClipRRect(
            borderRadius: const BorderRadius.only(topRight: Radius.circular(radius), topLeft: Radius.circular(radius)),
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.centerRight,
                  end: Alignment.centerLeft,
                  colors: [color.accent, color.primary],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
