import 'package:flutter/material.dart';

class DisplayData {
  MediaQueryData? _mediaData;
  static double? displayWidth;
  static double? displayHeight;

  void init(BuildContext aContext) {
    _mediaData = MediaQuery.of(aContext);
    displayHeight = _mediaData!.size.height;
    displayWidth = _mediaData!.size.width;
  }

  Size get screenSize => _mediaData!.size;
}

double? displayWidth() => DisplayData.displayWidth;
double? displayHeight() => DisplayData.displayHeight;
Size displaySize() => DisplayData().screenSize;
