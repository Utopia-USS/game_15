import 'package:flutter/cupertino.dart';

extension BoxConstraintsExt on BoxConstraints {
  get smallerDimension => maxHeight > maxWidth ? maxWidth : maxHeight;

  get biggerDimension => maxHeight < maxWidth ? maxWidth : maxHeight;
}
