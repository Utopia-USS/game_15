import 'package:flutter/material.dart';

class AppText {
  AppText._();

  static const menuTitle = TextStyle(
    fontFamily: "Ugly Byte",
    fontSize: 80,
    fontWeight: FontWeight.w600,
    color: Colors.white,
  );
  static const menuItem = TextStyle(
    fontFamily: "Ugly Byte",
    fontSize: 34,
    fontWeight: FontWeight.w300,
    color: Colors.white,
  );

  static const menuCaption = TextStyle(
      fontFamily: "Ugly Byte",
      fontSize: 24,
      fontWeight: FontWeight.w300,
      color: Colors.white,
      fontStyle: FontStyle.italic);

  static final snackbar = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w700,
    color: Colors.black.withOpacity(0.75),
  );
}
