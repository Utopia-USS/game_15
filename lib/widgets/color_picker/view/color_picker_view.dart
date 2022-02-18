import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:game_15/widgets/color_picker/state/color_picker_state.dart';
import 'package:game_15/widgets/color_picker/widget/color_picker_background.dart';
import 'package:game_15/widgets/color_picker/widget/color_picker_carousel.dart';

class ColorPickerView extends StatelessWidget {
  final ColorPickerState state;

  const ColorPickerView({Key? key, required this.state}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      child: LayoutBuilder(
        builder: (context, constraints) {
          return ColorPickerBackground(
            constraints: constraints,
            state: state,
            child: ColorPickerCarousel(
              constraints: constraints,
              state: state,
            ),
          );
        },
      ),
    );
  }
}
