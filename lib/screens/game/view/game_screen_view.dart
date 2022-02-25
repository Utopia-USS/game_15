import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:game_15/game/game.dart';
import 'package:game_15/game/game_config.dart';
import 'package:game_15/model/item_color.dart';
import 'package:game_15/screens/game/state/game_screen_state.dart';
import 'package:game_15/widgets/camera/camera_screen.dart';
import 'package:game_15/widgets/color_picker/color_picker.dart';
import 'package:game_15/widgets/drawer/drawer.dart';
import 'package:game_15/widgets/ripple/ripple_widget.dart';
import 'package:provider/provider.dart';

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
          child: const Icon(Icons.menu, color: Colors.white),
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
          builder: (context) => Provider<GameScreenState>.value(
            value: state,
            child: Center(
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  _buildGame(size),
                  if (state.isWon) _buildWinIcon(size),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildWinIcon(double size) {
    final iconSize = size / 5;
    return Positioned(
      right: -iconSize / 3,
      bottom: -iconSize / 3,
      child: SvgPicture.asset(
        "assets/win_icon.svg",
        height: iconSize,
        width: iconSize,
      ),
    );
  }

  Widget _buildGame(double size) {
    return SizedBox(
      height: size,
      width: size,
      child: Game(
        key: ValueKey(state.type),
        controller: state.gameController,
        config: _buildConfig(size / 50),
        child: ClipRect(
          child: _buildGameChild(),
        ),
      ),
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

  Color _getGameBackground() {
    switch (state.type) {
      case GameType.color_picker:
        return Colors.grey.shade50;
      case GameType.menu:
        return Colors.grey.shade800;
      case GameType.ripple:
        return ItemColor.orange.accent;
    }
  }

  Widget _buildGameChild() {
    final key = useMemoized<GlobalKey>(() => GlobalKey());
    switch (state.type) {
      case GameType.color_picker:
        return ColorPicker(key: key);
      case GameType.menu:
        return DrawerWidget(key: key);
      case GameType.ripple:
        return CameraWidget(key: key);
    }
  }

  GameConfig _buildConfig(double borderWidth) {
    return GameConfig(
      moves: 20,
      initialAnimationDuration: const Duration(milliseconds: 2500),
      initialAnimationCurve: Curves.elasticOut,
      decoration: BoxDecoration(
        color: _getGameBackground(),
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
            color: _getColorTheme().primary,
          ),
        ),
        borderRadius: BorderRadius.circular(20),
      ),
    );
  }
}
