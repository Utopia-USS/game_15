import 'package:flutter/material.dart';
import 'package:game_15/const/app_colors.dart';

import 'menu_background_item.dart';

class MenuBackground extends StatelessWidget {
  final Animation<double> animation;

  const MenuBackground({
    Key? key,
    required this.animation,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        MenuBackgroundItem(
          initialOffsetX: 1,
          intervalStart: 0.0,
          intervalEnd: 0.2,
          gradientBegin: AppColors.primary[100]!,
          gradientEnd: AppColors.primary[200]!,
          animation: animation,
        ),
        MenuBackgroundItem(
          initialOffsetX: -1,
          intervalStart: 0.2,
          intervalEnd: 0.4,
          gradientBegin: AppColors.primary[200]!,
          gradientEnd: AppColors.primary[300]!,
          animation: animation,
        ),
        MenuBackgroundItem(
          initialOffsetY: 1,
          intervalStart: 0.4,
          intervalEnd: 0.6,
          gradientBegin: AppColors.primary[300]!,
          gradientEnd: AppColors.primary[400]!,
          animation: animation,
        ),
      ],
    );
  }
}
