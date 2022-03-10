import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:game_15/const/app_text.dart';
import 'package:game_15/screens/menu/menu_screen.dart';
import 'package:game_15/state/game_type_state.dart';

class MenuContent extends HookWidget {
  final Animation<double> animation;
  final void Function(GameType, BuildContext) onItemPressed;

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
        _buildItem("Custom Drawer", GameType.menu),
        _buildItem("Water Ripple", GameType.ripple),
        _buildItem("AR Cam", GameType.camera),
        _buildBottom(),
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

  Widget _buildBottom() {
    return const Expanded(
      child: Align(
        alignment: Alignment(0, 0.7),
        child: MouseRegion(
          cursor: SystemMouseCursors.click,
          child: Text(
            "visit our GITHUB",
            style: AppText.menuCaption,
          ),
        ),
      ),
    );
  }

  Widget _buildExit(BuildContext context) {
    return Positioned(
      left: 18,
      top: 18,
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: SafeArea(
          child: GestureDetector(
            onTap: () => Navigator.pop(context, MenuScreenResult.none),
            child: const Icon(Icons.close, color: Colors.white, size: 30),
          ),
        ),
      ),
    );
  }

  Widget _buildItem(String text, GameType type) {
    return Builder(builder: (context) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: MouseRegion(
          cursor: SystemMouseCursors.click,
          child: GestureDetector(
            onTap: () => onItemPressed(type, context),
            child: Text(
              text,
              style: AppText.menuItem,
            ),
          ),
        ),
      );
    });
  }
}
