import 'package:flutter/material.dart';

class WindowSize {
  BuildContext context;
  WindowSize(this.context);

  double get width => MediaQuery.of(context).size.width;
  double get height => MediaQuery.of(context).size.height;
}
