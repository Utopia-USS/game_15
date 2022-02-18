import 'package:flutter/cupertino.dart';

extension PageControllerExtension on PageController{
  int get fixedCurrentPage => !hasClients ? 1 : page?.round() ?? 1;
}