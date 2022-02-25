import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:game_15/const/app_text.dart';

class NoCameraPermissionsSnackbar {
  static void show(BuildContext context) {
    Scaffold.of(context).showSnackBar(_buildSnackBar());
  }

  static SnackBar _buildSnackBar() {
    return SnackBar(
      elevation: 0,
      behavior: SnackBarBehavior.floating,
      duration: const Duration(milliseconds: 3000),
      backgroundColor: Colors.transparent,
      content: Container(
        height: 80,
        margin: const EdgeInsets.symmetric(horizontal: 34),
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(220),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.15),
              offset: const Offset(6, 6),
              blurRadius: 10,
              spreadRadius: 5,
            )
          ],
        ),
        child: Center(
          child: Text(
            "No camera permissions",
            style: AppText.menuCaption.copyWith(color: Colors.black87),
          ),
        ),
      ),
    );
  }
}
