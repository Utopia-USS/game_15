import 'package:flutter/widgets.dart';

// copy of _DecorationClipper from SDK
class DecorationClipper extends CustomClipper<Path> {
  final TextDirection textDirection;
  final Decoration decoration;

  const DecorationClipper({
    this.textDirection = TextDirection.ltr,
    required this.decoration,
  });

  @override
  Path getClip(Size size) {
    return decoration.getClipPath(Offset.zero & size, textDirection);
  }

  @override
  bool shouldReclip(DecorationClipper oldClipper) {
    return oldClipper.decoration != decoration
        || oldClipper.textDirection != textDirection;
  }
}