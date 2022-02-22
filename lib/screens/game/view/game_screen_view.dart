import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:game_15/game/game.dart';
import 'package:game_15/game/game_config.dart';
import 'package:game_15/model/item_color.dart';
import 'package:game_15/screens/game/state/game_screen_state.dart';
import 'package:game_15/widgets/color_picker/color_picker.dart';
import 'package:game_15/widgets/drawer/drawer.dart';
import 'package:game_15/widgets/ripple/ripple_widget.dart';

class GameScreenView extends HookWidget {
  final GameScreenState state;

  const GameScreenView({Key? key, required this.state}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final color = _getColorTheme();
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: GestureDetector(
          onTap: state.onMenuPressed,
          child: Icon(Icons.menu, color: Colors.white),
        ),
      ),
      body: Container(
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
      ),
    );
  }

  Widget _buildContent() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final size = constraints.biggest.shortestSide * 0.8;
        return HookBuilder(
          builder: (context) => Center(
            child: SizedBox(
              height: size,
              width: size,
              child: _buildGame(),
            ),
          ),
        );
      },
    );
  }

  Widget _buildGame() {
      return Game(
        controller: state.gameController,
        config: _buildConfig(),
        child: _buildGameChild(),
      );
  }

  ItemColor _getColorTheme() {
    switch (state.type) {
      case GameType.color_picker:
        return ItemColor.all[1];
      case GameType.menu:
        return ItemColor.lavender;
      case GameType.ripple:
        return ItemColor.orange;
    }
  }

  Widget _buildGameChild() {
    switch (state.type) {
      case GameType.color_picker:
        return const ColorPicker();
      case GameType.menu:
        return const DrawerWidget();
      case GameType.ripple:
        return const RippleWidget();
    }
  }

  GameConfig _buildConfig() {
    return GameConfig(
      moves: 3,
      initialAnimationDuration: const Duration(seconds: 2),
      initialAnimationCurve: Curves.elasticOut,
      decoration: BoxDecoration(
        color: _getColorTheme().accent,
        boxShadow: kElevationToShadow[3],
        borderRadius: BorderRadius.circular(20),
      ),
      foregroundDecoration: BoxDecoration(
        border: Border.fromBorderSide(
          BorderSide(
            width: 2,
            color: _getColorTheme().primary,
          ),
        ),
        borderRadius: BorderRadius.circular(20),
      ),
    );
  }
}
