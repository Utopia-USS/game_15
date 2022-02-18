import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:game_15/util/extension/page_controller_extension.dart';
import 'package:game_15/widgets/color_picker/state/color_picker_state.dart';
import 'package:game_15/widgets/color_picker/widget/color_picker_item.dart';
import 'package:game_15/widgets/model/item_color.dart';

class ColorPickerCarousel extends HookWidget {
  final ColorPickerState state;
  final BoxConstraints constraints;

  const ColorPickerCarousel({Key? key, required this.constraints, required this.state}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    useListenable(state.pageController);
    final height = constraints.maxHeight;
    final width = constraints.maxWidth;
    final smallerDimension = width > height ? height : width;
    return SizedBox(
      height: height / 3,
      child: PageView.builder(
        physics: const BouncingScrollPhysics(),
        controller: state.pageController,
        itemCount: ItemColor.all.length,
        itemBuilder: (context, index) {
          final item = ItemColor.all[index];
          final isSelected = state.foregroundColor == item;
          return Center(
            child: ColorPickerItem(
              color: item,
              size: isSelected ? smallerDimension / 3 : smallerDimension / 4,
              onPressed: () => state.onItemPressed(color: item, index: index),
            ),
          );
        },
      ),
    );
  }
}
