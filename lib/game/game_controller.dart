class GameController {
  Future<void> Function()? reset;
  Future<void> Function()? shuffle;
  Future<void> Function()? perform;

  bool get isAttached => reset != null;
}
