import 'package:flutter/cupertino.dart';
import 'package:game_15/widgets/ripple/widgets/ripple_circle_clip.dart';

class SingleRipple extends StatelessWidget {
  final Offset center;
  final double width;
  final double radius;
  final Widget child;
  final Offset Function(Offset)? globalToLocalOffset;

  const SingleRipple({
    Key? key,
    required this.radius,
    required this.child,
    required this.center,
    required this.globalToLocalOffset,
    this.width = 18,
  }) :  assert(width >= 10),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    final layerNum = (width / 2).ceil();
    final internalRadius = radius - width;
    final localOffset = globalToLocalOffset != null ? globalToLocalOffset!(center) : null;
    return localOffset != null
        ? Stack(
      children: <Widget>[
        child,
        for(int i in Iterable<int>.generate(layerNum))
          _getLayer(i, layerNum, child, localOffset),
        ClipPath(
          clipper: CircleClip(
            center: localOffset,
            radius: internalRadius,
          ),
          child: child,
          clipBehavior: Clip.hardEdge,
        ),
      ],
    )
        : child;
  }

  Widget _getLayer(int i, int layerNum, Widget child, Offset center) {
    final currentRadius = radius - i/layerNum * width;
    const alphaCoef = 0.15;
    final scaleCoef = 0.006 * radius / 100;
    return ClipPath(
      clipper: CircleClip(
        center: center,
        radius: currentRadius,
      ),
      clipBehavior: Clip.hardEdge,
      child: Stack(
          children: [
            Transform.scale(
              scale: i <= layerNum/2
                  ? 1 + scaleCoef - scaleCoef * i/layerNum * 2
                  : 1 - scaleCoef + scaleCoef * (i/layerNum - 0.5) *2,
              child: child,
              origin: center,
            ),
            Positioned.fill(
              child: Container(
                color: i <= layerNum/2
                    ? Color.fromRGBO(255, 255, 255, alphaCoef * (0.0 + i/layerNum * 2))
                    : Color.fromRGBO(0, 0, 0, alphaCoef * (-1.0 + i/layerNum * 2)),
              ),
            ),
          ]
      ),
    );
  }
}