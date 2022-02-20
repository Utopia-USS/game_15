import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:game_15/const/app_text.dart';
import 'package:game_15/screens/game/state/game_screen_state.dart';

class MenuContent extends HookWidget {
  final Animation<double> animation;
  final void Function(GameType) onItemPressed;

  const MenuContent({
    Key? key,
    required this.animation,
    required this.onItemPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: Tween<Offset>(
        begin: const Offset(0, -1),
        end: const Offset(0, 0),
      ).animate(
        CurvedAnimation(
          curve: const Interval(
            0.6,
            1,
            curve: Curves.easeOutCubic,
          ),
          parent: animation,
        ),
      ),
      child: Opacity(
        opacity: animation.value,
        child: Stack(
          children: [
            _buildContent(),
            _buildExit(context),
          ],
        ),
      ),
    );
  }

  Widget _buildContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        _buildTitle(),
        _buildItem("Color picker", GameType.color_picker),
        _buildItem("Drawer", GameType.menu),
        _buildItem("Ripple", GameType.ripple),
        const Spacer(),
      ],
    );
  }

  Widget _buildTitle() {
    return const Expanded(
      child: Center(
        child: Text(
          "Menu",
          style: AppText.menuTitle,
        ),
      ),
    );
  }

  Widget _buildExit(BuildContext context) {
    return Positioned(
      left: 18,
      top: 18,
      child: SafeArea(
        child: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Icon(Icons.close, color: Colors.white),
        ),
      ),
    );
  }

  Widget _buildItem(String text, GameType type) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: GestureDetector(
        onTap: () => onItemPressed(type),
        child: Text(
          text,
          style: AppText.menuItem,
        ),
      ),
    );
  }
}
