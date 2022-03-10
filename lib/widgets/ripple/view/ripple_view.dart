import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:game_15/const/app_text.dart';
import 'package:game_15/util/extensions/box_constraints_ext.dart';
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
        builder: (context, animation) {
          return LayoutBuilder(builder: (context, constraints) {
            return SingleRipple(
              center: state.offset,
              width: constraints.biggerDimension / 20,
              radius: constraints.biggerDimension * 1.5 * state.animation,
              child: Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Colors.white, Colors.white70],
                  ),
                ),
                child: _buildContent(context, constraints),
              ),
            );
          });
        },
      ),
    );
  }

  Widget _buildContent(BuildContext context, BoxConstraints constraints) {
    return Column(
      children: [
        for (int i = 0; i < 4; i++) _buildRowSection(context, constraints, i),
      ],
    );
  }

  Widget _buildRowSection(BuildContext context, BoxConstraints constraints, int column) {
    return Expanded(
      child: Row(
        children: [
          for (int i = 0; i < 4; i++) _buildItem(context, constraints, i, column),
        ],
      ),
    );
  }

  Widget _buildItem(BuildContext context, BoxConstraints constraints, int row, int column) {
    return Expanded(
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTapUp: (details) => state.triggerAnimation(
          context: context,
          details: details,
          constraints: constraints,
          row: row,
          column: column,
        ),
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
      ),
    );
  }
}
