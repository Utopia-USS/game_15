import 'package:flutter/material.dart';
import 'package:game_15/widgets/drawer/drawer.dart';

class DrawerMockItem extends StatelessWidget {
  const DrawerMockItem({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final color = DrawerWidget.color;
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 36, 24, 8),
      child: PhysicalModel(
        color: Colors.transparent,
        shadowColor: color.primary,
        borderRadius: BorderRadius.circular(10),
        elevation: 16,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Container(
            height: 200,
            width: double.infinity,
            decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.centerRight,
              end: Alignment.centerLeft,
              colors: [color.accent, color.primary],
            ),),
          ),
        ),
      ),
    );
  }
}
