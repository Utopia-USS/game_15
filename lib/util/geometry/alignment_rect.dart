import 'package:flutter/cupertino.dart';

class AlignmentRect {
  final Alignment topLeft;
  final Alignment bottomRight;

  const AlignmentRect.fromPoints(this.topLeft, this.bottomRight);

  AlignmentRect.fromSize(this.topLeft, FractionalOffset size)
      : bottomRight = Alignment(topLeft.x + size.dx * 2, topLeft.y + size.dy * 2);

  bool contains(Alignment position) =>
      position.x >= topLeft.x && position.y >= topLeft.y && position.x <= bottomRight.x && position.y <= bottomRight.y;

  Alignment clamp(Alignment position) =>
      Alignment(position.x.clamp(topLeft.x, bottomRight.x), position.y.clamp(topLeft.y, bottomRight.y));

  AlignmentRect operator /(double scalar) => AlignmentRect.fromPoints(topLeft / scalar, bottomRight / scalar);

  Rect toRect(Size size) => Rect.fromPoints(topLeft.alongSize(size), bottomRight.alongSize(size));
}
