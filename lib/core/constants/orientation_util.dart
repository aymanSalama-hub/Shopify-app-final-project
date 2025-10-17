import 'package:flutter/material.dart';

class OrientationUtil {
  static bool isPortrait(BuildContext context) {
    return MediaQuery.of(context).orientation == Orientation.portrait;
  }
}