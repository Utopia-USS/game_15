# Game of 15

Classic puzzle, reimagined using the power of Flutter. 

Flutter Puzzle Hack 2022 contest entry.

![Video](video.gif)

## What is it?

Given the task of reimagining the classic "game of 15" puzzle in Flutter, we decided to apply one of the key concepts in the framework - composability - to the game itself. 
You can make *literally* any piece of Flutter UI the content of the game without losing interactivity, animations or compromising performance.
Together with fun mechanics, beautiful visuals and 4 carefully selected levels, the game redefines
what's achievable in Flutter.

### Features

- Real-world-inspired puzzle physics (move several tiles at once, snapping, board drift)
- Procedurally-generated initial configurations
- Fully interactive puzzle content
- 4 levels of varying difficulty, selected to reflect some of the Flutter's unique capabilities:
  - Custom Drawer
  - Color Picker
  - Water Ripple
  - AR Cam (not available on web, [why?](#How it works?))

## How it works?

We started the development with simple question: can you create a puzzle which can use *any* flutter widget as a
content? As it turns out, with the right amount of digging around in the low-level flutter code, you can. The final
effect looks like this:

```dart
Widget build(BuildContext context) {
  return Game(
    controller: gameController, 
    child: const AnythingYouWant(),
  );
}
```

Where `Game` handles the whole puzzle's logic. Note that `child` can be *any* ordinary Flutter widget, and during the
game it can alter its state, perform animations, receive tap gestures(transformed according to current tile's positions)
. Below we'll discuss how this is possible.

### Kaleidoscope

The heart of the puzzle is our custom-built `Kaleidoscope` widget. Generally, it can display its child as an arbitrary
number of "shards". Each shard paints the child with different matrix transformations and clipping, as specified
by `KaleidoscopeDelegate`. Geometry of these shards can be changed without the need to trigger rebuilds - much like the
underappreciated `Flow` widget, but instead of painting multiple children once, we paint one child many times.

### Game

### Engine

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://flutter.dev/docs/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://flutter.dev/docs/cookbook)

For help getting started with Flutter, view our
[online documentation](https://flutter.dev/docs), which offers tutorials, samples, guidance on mobile development, and a
full API reference.
''''