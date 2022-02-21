import 'dart:ui';

import 'package:flutter/cupertino.dart';

class CircleClip extends CustomClipper<Path> {
  final double radius;
  final Offset center;

  CircleClip({
    required this.radius,
    required this.center,
  });

  @override
  Path getClip(Size size) {
    final path = Path();
    path.addOval(Rect.fromCircle(center: center, radius: radius));
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => true;

}