import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:game_15/const/app_text.dart';
import 'package:game_15/game/game.dart';
import 'package:game_15/game/game_config.dart';
import 'package:game_15/widgets/game_square/game_square.dart';
import 'package:game_15/widgets/game_square/state/game_square_state.dart';

class GameSquareView extends HookWidget {
  final GameSquareState state;

  GameSquareView({Key? key, required this.state}) : super(key: key);

  final color = GameSquare.color;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            color.accent,
            color.primary,
          ],
        ),
      ),
      child: _buildContent(),
    );
  }

  Widget _buildContent() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final size = constraints.biggest.shortestSide * 0.8;
        return Center(
          child: _buildGame(size),
        );
      },
    );
  }

  Widget _buildGame(double size) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: SizedBox(
        height: size,
        width: size,
        child: Game(
          controller: state.gameController,
          config: _buildConfig(size / 50),
          child: ClipRect(
            child: _buildGameContent(size / 18),
          ),
        ),
      ),
    );
  }

  Widget _buildGameContent(double fontSize) {
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          for (int i = 0; i < 4; i++) _buildRowSection(i, fontSize),
        ],
      ),
    );
  }

  Widget _buildRowSection(int column, double fontSize) {
    return Expanded(
      child: Row(
        children: [
          for (int i = 0; i < 4; i++) _buildItem(i, column, fontSize),
        ],
      ),
    );
  }

  Widget _buildItem(int row, int column, double fontSize) {
    final fixedRow = row + 1;
    return Expanded(
      child: Center(
        child: Text(
          "${fixedRow + column* 4}",
          style: AppText.menuItem.copyWith(
            color: color.primary,
            fontSize: fontSize,
            fontWeight: FontWeight.w600,
            letterSpacing: 1,
          ),
        ),
      ),
    );
  }

  GameConfig _buildConfig(double borderWidth) {
    return GameConfig(
      moves: 30,
      animationDuration: const Duration(milliseconds: 2500),
      animationCurve: Curves.elasticOut,
      decoration: BoxDecoration(
        color: color.accent,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.20),
            offset: const Offset(12, 12),
            blurRadius: 20,
            spreadRadius: 10,
          )
        ],
        borderRadius: BorderRadius.circular(20),
      ),
      foregroundDecoration: BoxDecoration(
        border: Border.fromBorderSide(
          BorderSide(
            width: borderWidth,
              color: Colors.grey.shade800,
          ),
        ),
        borderRadius: BorderRadius.circular(20),
      ),
    );
  }
}
