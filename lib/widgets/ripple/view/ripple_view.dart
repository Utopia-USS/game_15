import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:game_15/const/app_text.dart';
import 'package:game_15/util/kaleidoscope/kaleidoscope_delegate.dart';
import 'package:game_15/util/kaleidoscope/kaleidoscope_shard.dart';
import 'package:game_15/widgets/ripple/state/ripple_state.dart';
import 'package:game_15/widgets/ripple/widgets/single_ripple.dart';

import '../ripple_widget.dart';

class RippleView extends StatelessWidget {
  final RippleState state;

  const RippleView({Key? key, required this.state}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      child: AnimatedBuilder(
        animation: state.animationController,
        builder: (context, _) {
          return SingleRipple(
            center: Offset(100,200),
            radius: state.animationController.value,
            child: Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.white, Colors.white70],
                ),
              ),
              child: _buildContent(),
            ),
          );
        },
      ),
    );
  }

  Widget _buildContent() {
    return Column(
      children: [
        for (int i = 0; i < 4; i++) _buildRowSection(),
      ],
    );
  }

  Widget _buildRowSection() {
    return Expanded(
      child: Row(
        children: [
          for (int i = 0; i < 4; i++) _buildItem(),
        ],
      ),
    );
  }

  Widget _buildItem() {
    return Expanded(
      child: Center(
        child: Text(
          "Tap me",
          style: AppText.menuItem.copyWith(
            color: RippleWidget.color.primary,
            fontSize: 18,
            fontWeight: FontWeight.w600,
            letterSpacing: 1,
          ),
        ),
      ),
    );
  }
}

class _RippleKaleidoscopeDelegate extends KaleidoscopeDelegate {

  @override
  KaleidoscopeShard getShard(Size size, int index) {
    // TODO: implement getShard
    throw UnimplementedError();
  }

  @override
  // TODO: implement shardCount
  int get shardCount => throw UnimplementedError();

  @override
  bool shouldRepaint(covariant KaleidoscopeDelegate other) {
    // TODO: implement shouldRepaint
    throw UnimplementedError();
  }

}
