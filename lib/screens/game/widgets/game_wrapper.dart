import 'package:flutter/material.dart';
import 'package:game_15/const/app_colors.dart';

class GameWrapper extends StatelessWidget {
  final Widget game;
  GameWrapper({Key? key, required this.game}) : super(key: key);

  final _borderRadius = BorderRadius.circular(30);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
        borderRadius: _borderRadius,
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            AppColors.primary[100]!,
            AppColors.primary[400]!,
          ],
        ),
      ),
      child: ClipRRect(
        borderRadius: _borderRadius,
        child: game,
      ),
    );
  }
}
