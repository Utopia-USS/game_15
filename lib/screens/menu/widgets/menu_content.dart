import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:game_15/const/app_text.dart';

class MenuContent extends HookWidget {
  final Animation<double> animation;

  const MenuContent({
    Key? key,
    required this.animation,
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
        _buildItem("Color picker"),
        _buildItem("Drawer"),
        _buildItem("Game 3"),
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

  Widget _buildItem(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Text(
        text,
        style: AppText.menuItem,
      ),
    );
  }
}
