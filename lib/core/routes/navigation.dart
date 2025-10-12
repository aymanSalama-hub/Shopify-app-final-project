import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

pushTo(BuildContext context, String path, {Object? extra}) {
  context.push(path, extra: extra);
}

pushReplacementTo(BuildContext context, String path, {Object? extra}) {
  context.pushReplacement(path);
}

pushAndRemoveUntil(BuildContext context, String path, {Object? extra}) {
  context.go(path);
}

pop(BuildContext context) {
  context.pop();
}
