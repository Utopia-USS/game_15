import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:game_15/game/game.dart';
import 'package:game_15/game/game_config.dart';
import 'package:game_15/model/item_color.dart';
import 'package:game_15/screens/game/state/game_screen_state.dart';
import 'package:game_15/screens/game/widgets/lock_game_icon.dart';
import 'package:game_15/state/game_type_state.dart';
import 'package:game_15/widgets/camera/camera.dart';
import 'package:game_15/widgets/color_picker/color_picker.dart';
import 'package:game_15/widgets/drawer/drawer.dart';
import 'package:game_15/widgets/game_square/game_square.dart';
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
        leading: _buildMenuButton(),
        actions: [if (state.isResetVisible) _buildResetButton()],
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
              child: _buildGameWithLock(size),
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

  Widget _buildGameWithLock(double size) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        _buildGameWithWin(size),
        if (state.type == GameType.square)
          LockGameIcon(
            isLocked: state.isLocked,
            onLockChanged: state.onLockChanged,
          ),
      ],
    );
  }

  Widget _buildGameWithWin(double size){
    return Stack(
      clipBehavior: Clip.none,
      children: [
        _buildGame(size),
        if (state.isWon) _buildWinIcon(size),
      ],
    );
  }

  Widget _buildGame(double size) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: SizedBox(
        height: size,
        width: size,
        child: Game(
          isLocked: state.type == GameType.square && state.isLocked,
          key: ValueKey(state.type),
          controller: state.gameController,
          config: _buildConfig(size / 50),
          child: ClipRect(
            child: IgnorePointer(
              ignoring: state.stage == GameScreenStage.demo,
              child: _buildGameChild(),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMenuButton() {
    return GestureDetector(
      onTap: state.onMenuPressed,
      child: const MouseRegion(
        cursor: SystemMouseCursors.click,
        child: Icon(Icons.menu, color: Colors.white),
      ),
    );
  }

  Widget _buildResetButton() {
    return GestureDetector(
      onTap: state.onResetPressed,
      child: const MouseRegion(
        cursor: SystemMouseCursors.click,
        child: Padding(
          padding: EdgeInsets.only(right: 12),
          child: Icon(Icons.replay, color: Colors.white),
        ),
      ),
    );
  }

  ItemColor _getColorTheme() {
    switch (state.type) {
      case GameType.color_picker:
        return ItemColor.all[1];
      case GameType.menu:
        return CustomDrawer.color;
      case GameType.ripple:
        return RippleWidget.color;
      case GameType.camera:
        return ArCam.color;
      case GameType.square:
        return GameSquare.color;
    }
  }

  Color _getGameBackground() {
    switch (state.type) {
      case GameType.color_picker:
        return Colors.grey.shade50;
      case GameType.menu:
        return Colors.grey.shade800;
      case GameType.ripple:
        return RippleWidget.color.accent;
      case GameType.camera:
        return ArCam.color.primary;
      case GameType.square:
        return Colors.grey.shade800;
    }
  }

  Widget _buildGameChild() {
    final key = useMemoized<GlobalKey>(() => GlobalKey());
    switch (state.type) {
      case GameType.color_picker:
        return ColorPicker(key: key);
      case GameType.menu:
        return CustomDrawer(key: key);
      case GameType.ripple:
        return RippleWidget(key: key);
      case GameType.camera:
        return ArCam(key: key);
      case GameType.square:
        return GameSquare(key: key);
    }
  }

  GameConfig _buildConfig(double borderWidth) {
    return GameConfig(
      moves: 30,
      animationDuration: const Duration(milliseconds: 2500),
      animationCurve: const ElasticOutCurve(0.6),
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
