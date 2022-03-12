# Hack of 15

Unleash full Flutter potential in the classic puzzle. Interactively.

[Flutter Puzzle Hack](https://flutterhack.devpost.com) contest entry.

<center>
<img src="video.gif" height="500px"/>
</center>

## What it is

Given the task of reimagining the classic "game of 15" puzzle in Flutter, we decided to apply one of the key concepts in
the framework - composability - to the game itself.  
You can make *literally* any piece of Flutter UI the content of the game without losing interactivity, animations or
compromising performance. Along with fun mechanics, beautiful visuals and 5 carefully selected levels, the game
redefines what's achievable in Flutter.

### Features

- Real-world-inspired puzzle physics (moving several tiles at once, snapping, board drifting)
- Procedurally-generated initial configurations
- Fully interactive puzzle content
- 5 levels of various difficulties, selected to reflect some of the Flutter's unique capabilities:
    - [Color Picker](#Color-Picker)
    - [Custom Drawer](#Custom-Drawer)
    - [Water Ripple](#Water-Ripple)
    - [AR Cam](#AR-Cam) (not available on web, [why?](#Limitations))
    - [Game x Game](#Game-x-Game)

## How it works

We started the development with a simple question: could you possibly create a puzzle which would be able to use *any*
flutter widget as a content? As it turns out, with the right amount of digging around in the low-level flutter code, you
can.  
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
Note that `child` can be *any* ordinary Flutter widget, which during the game can alter its state, perform animations
and receive tap gestures (transformed according to current tile's positions). Below we discuss how this is possible.

### Kaleidoscope

The heart of the puzzle is our custom-built `Kaleidoscope` widget. Generally speaking, it can display its child as an
arbitrary number of "shards". Each shard paints the child with different matrix transformations and clipping, as
specified by `KaleidoscopeDelegate`. Geometry of these shards can be changed without the need to trigger rebuilds - much
like the underappreciated `Flow` widget, but instead of painting multiple children once, we paint one child many
times.  
Apart from [limitations](#Limitations), there are no requirements for the child widget. It participates in layout and
lifecycle as usual. Additionally, it's available for hit testing (first matching shard receives the transformed
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

Currently, there are some limitations on how the `Kaleidoscope` may be used, some of which can be resolved in the
future:

- Platform views are not supported - they are managed by the underlying platform, so we can't magically create multiple
  instances of them (on the other side, platform textures used by e.g. the `camera` package, do not cause such problems)
- On the Web, only CanvasKit renderer is supported - seems to cause subtle errors in the HTML renderer, more research
  needed
- Child widget can't be repositioned outside the `Kaleidoscope` using `GlobalKey` - fake `EngineLayer`s do not work
  without custom `SceneBuilder`; may be fixed by rewriting the fake `EngineLayer` substitution logic

### Engine

Game mechanics during the puzzle solving are provided by the `Engine` class. It implements real-world-inspired physics
by allowing bodies (tiles and the whole board) to move in both axes, while handling snapping, collisions and other
features.

### Game

`Game` manages the whole puzzle lifecycle (initialization, demo, shuffling, solving and winning). It acts as a bridge
between `Engine` and `Kaleidoscope`, scheduling physics updates and displaying tiles' state in every frame. Most of the
changes do not require rebuilding the widget tree which allows staying blazing-fast.

### Game modes

There are 5 built-in interactive puzzles included to demonstrate endless creative possibilities of the `Kaleidoscope`.

#### Color Picker

The easiest yet one of the most satisfying modes to play. We've come across this idea in the Briefly app a while ago and
after a few adjustments it turned out to be a perfect fit to showcase our game's capabilities. It's an efficiently
implemented, elegant picker.

#### Custom Drawer

Inspired by Marcin Szalek's "Implementing complex UI" talk, was one of first "outside the box" widgets we've ever
created. It redefines the approach to basic, well known components and shows the simplicity of creating eye-catching
layouts using basic Flutter features.

#### Water Ripple

The result of an experiment in which we used several layered widgets, modified with scaling and colored overlays to
imitate the lensing effect of water ripples. Due to the puzzle transformations the level is not only extremely hard but
can also make you dizzy - you're welcome and be careful.

#### AR Cam

That's the point where we really started to push boundaries. We wanted to include some sort of media widget, for
instance a video player, but we decided to give the `camera` package a go. As straightforward as the widget is, it's
still a hell of a lot of fun solving the puzzle made of your best bud's messed up face (or cat's if you don't like
humans).

#### Game x Game

Since we are able to use any widget as the game's content, we decided to use the `Game` widget itself. You must
translate between two boards in order to complete the puzzle. Taking into account an additional degree of freedom, it's
the hardest mode to play and might not be solvable in a reasonable amount of time. If that's the case, why did we even
bother creating it?  **Because we could.**  
