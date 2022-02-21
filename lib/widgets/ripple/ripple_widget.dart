import 'package:flutter/widgets.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:game_15/model/item_color.dart';
import 'package:game_15/widgets/ripple/state/ripple_state.dart';
import 'package:game_15/widgets/ripple/view/ripple_view.dart';

class RippleWidget extends HookWidget {
  const RippleWidget({required GlobalKey key}) : super(key: key);

  static final color = ItemColor.orange;


  @override
  Widget build(BuildContext context) {
    final state = useRippleState(widgetKey: key as GlobalKey);
    return RippleView(state: state);
  }
}
