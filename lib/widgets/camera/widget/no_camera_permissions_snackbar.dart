import 'package:flutter/material.dart';
import 'package:game_15/const/app_colors.dart';
import 'package:game_15/const/app_text.dart';

class AppSnackbar {
  static void showNoPermissions(BuildContext context) {
    Scaffold.of(context).showSnackBar(_buildSnackBar("No camera permissions"));
  }

  static void showCameraWeb(BuildContext context) {
    Scaffold.of(context)
        .showSnackBar(_buildSnackBar("AR Mode currently is supported on mobile only due to camera web limitations"));
  }

  static SnackBar _buildSnackBar(String text) {
    return SnackBar(
      elevation: 0,
      behavior: SnackBarBehavior.fixed,
      duration: const Duration(milliseconds: 3000),
      backgroundColor: Colors.transparent,
      dismissDirection: DismissDirection.horizontal,
      content: Align(
        alignment: Alignment.bottomCenter,
        heightFactor: 1,
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 18),
          padding: const EdgeInsets.all(18),
          decoration: _buildDecoration(),
          child: _buildContent(text),
        ),
      ),
    );
  }

  static BoxDecoration _buildDecoration() {
    return BoxDecoration(
      borderRadius: BorderRadius.circular(16),
      color: Colors.white,
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.25),
          offset: const Offset(6, 6),
          blurRadius: 10,
          spreadRadius: 5,
        )
      ],
    );
  }

  static Widget _buildContent(String text) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          height: 12,
          width: 12,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4),
            color: AppColors.primary,
          ),
        ),
        const SizedBox(width: 8),
        Text(
          text,
          textAlign: TextAlign.center,
          style: AppText.snackbar,
        ),
      ],
    );
  }
}
