import 'package:flutter/material.dart';

class TextStyles {
  static TextStyle styleSize30 = TextStyle(fontSize: 30);
  static TextStyle styleSize24 = TextStyle(fontSize: 24);
  static TextStyle styleSize20 = TextStyle(fontSize: 20);
  static TextStyle styleSize16 = TextStyle(fontSize: 16);
  static TextStyle styleSize15 = TextStyle(fontSize: 15);

  static TextStyle styleSize10 = TextStyle(fontSize: 10);
  static TextStyle get styleSize12 => TextStyle(
    fontSize: 12,
    color: Colors.grey[600], // Replace with theme color if needed
  );

  static TextStyle get styleSize14 => TextStyle(
    fontSize: 14,
    color: Colors.grey[800], // Replace with theme color if needed
  );

  static TextStyle get styleSize18 => TextStyle(
    fontSize: 18,
    color: Colors.black, // This will be overridden in the widget
  );

  // Make styles theme-aware by accepting BuildContext
  static TextStyle styleSize12WithContext(BuildContext context) =>
      TextStyle(fontSize: 12, color: Theme.of(context).colorScheme.onSurface);

  static TextStyle styleSize14WithContext(BuildContext context) =>
      TextStyle(fontSize: 14, color: Theme.of(context).colorScheme.onSurface);
}
