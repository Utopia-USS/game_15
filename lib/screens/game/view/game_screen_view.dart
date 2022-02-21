import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:game_15/model/item_color.dart';
import 'package:game_15/screens/game/state/game_screen_state.dart';
import 'package:game_15/screens/game/widgets/game/game.dart';
import 'package:game_15/widgets/color_picker/color_picker.dart';
import 'package:game_15/widgets/drawer/drawer.dart';
import 'package:game_15/widgets/ripple/ripple_widget.dart';

class GameScreenView extends StatelessWidget {
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
    return LayoutBuilder(builder: (context, constraints) {
      final height = constraints.maxHeight;
      final width = constraints.maxWidth;
      final smallerSide = height > width ? width : height;
      final size = smallerSide * 0.8;
      return Center(
        child: SizedBox(
          height: size,
          width: size,
          child: Game(
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: kElevationToShadow[30],
              borderRadius: BorderRadius.circular(20),
            ),
            foregroundDecoration: BoxDecoration(
              border: Border.fromBorderSide(
                BorderSide(
                  width: size / 55,
                  color: _getColorTheme().primary,
                ),
              ),
              borderRadius: BorderRadius.circular(20),
            ),
            child: _buildGame(),
          ),
        ),
      );
    });
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

  Color _getBorderColor() {
    switch (state.type) {
      case GameType.color_picker:
        return ItemColor.all[1].primary;
      case GameType.menu:
        return ItemColor.lavender.primary;
      case GameType.ripple:
        return ItemColor.blue.primary;
    }
  }

  Widget _buildGame() {
    switch (state.type) {
      case GameType.color_picker:
        return ColorPicker();
      case GameType.menu:
        return DrawerWidget();
      case GameType.ripple:
        return RippleWidget();
    }
  }
}
