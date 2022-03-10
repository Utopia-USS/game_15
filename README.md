# Game of 15

Classic puzzle, reimagined using the power of Flutter. 

Flutter Puzzle Hack 2022 contest entry.

![Video](video.gif)

## What is it?

Given the task of reimagining the classic "game of 15" puzzle in Flutter, we decided to apply one of the key concepts in
the framework - composability - to the game itself.  
You can make *literally* any piece of Flutter UI the content of the game without losing interactivity, animations or
compromising performance. Together with fun mechanics, beautiful visuals and 4 carefully selected levels, the game
redefines what's achievable in Flutter.

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
content? As it turns out, with the right amount of digging around in the low-level flutter code, you can.  
The final effect looks like this:

```dart
Widget build(BuildContext context) {
  return Game(
    controller: gameController,
    child: const YourAwesomeFlutterWidget(),
  );
}
```

Where `Game` handles the whole puzzle's logic.  
Note that `child` can be *any* ordinary Flutter widget, and during the game it can alter its state, perform animations,
receive tap gestures (transformed according to current tile's positions). Below we'll discuss how is this possible.

### Kaleidoscope

The heart of the puzzle is our custom-built `Kaleidoscope` widget. Generally speaking, it can display its child as an
arbitrary number of "shards". Each shard paints the child with different matrix transformations and clipping, as
specified by `KaleidoscopeDelegate`. Geometry of these shards can be changed without the need to trigger rebuilds - much
like the underappreciated `Flow` widget, but instead of painting multiple children once, we paint one child many
times.  
Apart from [limitations](#Limitations), there are no requirements on the child widget. It participates in layout and
lifecycle as usual. Additionally, it's available for hit testing (first matching shard "receives" the transformed
position).

#### Under the hood

It turns out that Flutter really doesn't expect anybody to paint one widget multiple times.  
Long story short, painting in Flutter is carried out by the `Layer` tree, which is directly influenced by the shape of
current widget tree. Apart from sending the actual drawing commands, it's also responsible for managing hardware
resources allocated by the engine - `EngineLayer`s.  
One `Layer` can hold on to at most one `EngineLayer`. The problem arises when you want to draw a `Layer` more than once
per frame (`EngineLayer`s cannot be reused during a single frame, so you need one of them for every shard).  
To overcome this, `KaleidoscopeLayer` hooks into the low-level `SceneBuilder` API. Each of the child's `Layer`s is "
tricked into thinking" that it manages a single, fake, `EngineLayer`, when it actually corresponds to as
many `EngineLayer`s as needed.  
See the `KeyedEngineLayerStorage` and `SceneBuilderWithStorage` classes for more details.

#### Limitations

Currently, there are some limitations on how the `Kaleidoscope` may be used, some of which can be removed in the future:

- Platform views are not supported - they are managed by the underlying platform, so we can't magically create multiple
  instances of them (on the other side, platform textures used by e.g. the `camera` package, do not cause such problems)
- On the Web, only CanvasKit renderer is supported - seems to cause subtle errors in the HTML renderer, more research
  needed
- Child widget can't be repositioned outside the `Kaleidoscope` using `GlobalKey` - fake `EngineLayer`s do not work
  without custom `SceneBuilder`; may be fixed by rewriting the fake `EngineLayer` substitution logic

### Engine

Game mechanics during solving the puzzle are provided by the `Engine` class. It implements real-world-inspired physics
by allowing bodies (tiles and the whole board) to move in both axes, while handling snapping, collisions and other
features.

### Game

`Game` manages the whole puzzle lifecycle (initialization, demo, shuffling, solving and winning). It acts as a bridge
between `Engine` and `Kaleidoscope`, scheduling physics updates and displaying tiles' state on every frame. Most of the
changes does not require rebuilding the widget tree which allows in to stay blazing-fast.
