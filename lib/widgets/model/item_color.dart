import 'package:flutter/material.dart';

class ItemColor {
  final Color primaryColor;
  final Color accentColor;

  ItemColor._({
    required this.primaryColor,
    required this.accentColor,
  });

  static final teal = ItemColor._(
    primaryColor: const Color(0xff00E0C2),
    accentColor: const Color(0xff5EFFEA),
  );

  static final purple = ItemColor._(
    primaryColor: const Color(0xff930CFA),
    accentColor: const Color(0xffE75EFF),
  );
  static final blue = ItemColor._(
    primaryColor: const Color(0xff0079FA),
    accentColor: const Color(0xff5EACFF),
  );
  static final orange = ItemColor._(
    primaryColor: const Color(0xffFAAF05),
    accentColor: const Color(0xffFFCF5E),
  );
  static final red = ItemColor._(
    primaryColor: const Color(0xffFA4E00),
    accentColor: const Color(0xffFF7E44),
  );

  static final green = ItemColor._(
    primaryColor: const Color(0xff00AD62),
    accentColor: const Color(0xff19FF9C),
  );

  static final all = [blue, teal, green,  orange, red, purple];
}
