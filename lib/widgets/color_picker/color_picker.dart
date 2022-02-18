import 'package:flutter/widgets.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:game_15/widgets/color_picker/state/color_picker_state.dart';
import 'package:game_15/widgets/color_picker/view/color_picker_view.dart';

class ColorPicker extends HookWidget {
  const ColorPicker({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    final state = useColorPickerState();
    return ColorPickerView(state: state);
  }
}
