import 'package:flutter/material.dart';
import 'package:game_15/screens/game/game_screen.dart';
import 'package:game_15/state/game_type_state.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        GameTypeStateProvider(),
      ],
      child: const MaterialApp(
        debugShowCheckedModeBanner: false,
        home: GameScreen(),
      ),
    ),
  );
}
