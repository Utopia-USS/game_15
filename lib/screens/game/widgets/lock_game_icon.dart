
import 'package:flutter/material.dart';
import 'package:game_15/const/app_text.dart';

class LockGameIcon extends StatelessWidget {
  final bool isLocked;
  final Function(bool) onLockChanged;

  const LockGameIcon({Key? key, required this.isLocked, required this.onLockChanged})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 32.0),
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () => onLockChanged(!isLocked),
          child:   AnimatedSwitcher(
            duration: const Duration(milliseconds: 400),
            reverseDuration: const Duration(milliseconds: 400),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  isLocked ? Icons.lock : Icons.lock_open,
                  color: Colors.white,
                ),
                const SizedBox(width: 12),
               Text(
                    isLocked ? "Unlock game" : "Lock game",
                    key: ValueKey(isLocked),
                    style: AppText.menuItem,
                  ),

              ],
            ),
          ),
        ),
      ),
    );
  }
}
