import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:game_15/screens/game/state/game_screen_state.dart';
import 'package:game_15/screens/game/widgets/game/game.dart';
import 'package:game_15/widgets/color_picker/color_picker.dart';
import 'package:game_15/widgets/drawer/drawer.dart';
import 'package:game_15/model/item_color.dart';
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
        child: Center(
          child: SizedBox(
            height: 300,
            width: 300,
            child: Game(
              child: _buildGame(),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMock(){
    final color = ItemColor.lavender;
    return  Center(
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(20),
        elevation: 20,
        child: Container(
          height: 300,
          width: 300,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.white, width: 4),
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                color.accent,
                color.primary,
              ],
            ),
          ),
          child: Game(
            child: _buildGame(),
          ),
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
