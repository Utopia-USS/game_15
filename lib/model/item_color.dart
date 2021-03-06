import 'package:flutter/material.dart';

class ItemColor {
  final Color primary;
  final Color accent;

  ItemColor._({
    required this.primary,
    required this.accent,
  });

  static final teal = ItemColor._(
    primary: const Color(0xff00E0C2),
    accent: const Color(0xff7BFFED),
  );

  static final purple = ItemColor._(
    primary: const Color(0xff930CFA),
    accent: const Color(0xffE75EFF),
  );

  static final lavender = ItemColor._(
    primary: const Color(0xff6E68F2),
    accent: const Color(0xff869AE3),
  );

  static final deepBlue = ItemColor._(
    primary: const Color(0xff4CA1AF),
    accent: const Color(0xff2C3E50),
  );

  static final blue = ItemColor._(
    primary: const Color(0xff0079FA),
    accent: const Color(0xff5EACFF),
  );
  static final orange = ItemColor._(
    primary: const Color(0xffFAAF05),
    accent: const Color(0xffFFCF5E),
  );
  static final red = ItemColor._(
    primary: const Color(0xffFA4E00),
    accent: const Color(0xffFF7E44),
  );

  static final green = ItemColor._(
    primary: const Color(0xff00AD62),
    accent: const Color(0xff19FF9C),
  );

  static final all = [blue, teal, green, orange, red, purple, lavender, deepBlue];
}
