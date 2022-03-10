import 'package:flutter/material.dart';
import 'package:game_15/const/app_theme.dart';
import 'package:game_15/screens/game/game_screen.dart';
import 'package:game_15/state/game_type_state.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        GameTypeStateProvider(),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: AppTheme.data,
        home: const GameScreen(),
      ),
    ),
  );
}
