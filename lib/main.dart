import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:game_15/game/game.dart';
import 'package:game_15/screens/menu/menu_screen.dart';
import 'package:game_15/widgets/color_picker/color_picker.dart';
import 'package:game_15/widgets/drawer/drawer.dart';

void main() {
  runApp(const MaterialApp(home: MyHomePage()));
}

class MyHomePage extends HookWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => MenuScreen.show(context),
      child: Scaffold(
        appBar: AppBar(),
        body: Center(
          child: SizedBox(
            width: 300,
            height: 300,
            child: Game(
              child: ColorPicker(),
            ),
          ),
        ),
      ),
    );
  }
}

class MyAnimatedSomething extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final controller = useAnimationController(duration: Duration(seconds: 2));
    
    useEffect(() {
      Future.microtask(() => controller.repeat(reverse: true));
    }, []);

    return AnimatedBuilder(
      animation: controller,
      builder: (context, value) => DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color.lerp(Colors.amber, Colors.blue, controller.value)!,
              Color.lerp(Colors.black, Colors.green, controller.value)!,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
      ),
    );
  }
}
