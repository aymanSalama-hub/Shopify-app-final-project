import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

pushTo(BuildContext context, String path, {Object? extra,}) {
  var result = context.push(path, extra: extra);
  return result;
}

pushReplacementTo(BuildContext context, String path, {Object? extra}) {
  context.pushReplacement(path, extra: extra);
}

pushAndRemoveUntil(BuildContext context, String path, {Object? extra}) {
  context.go(path, extra: extra);
}

pop(BuildContext context) {
  context.pop();
}

showdialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (context) => const Center(child: CircularProgressIndicator()),
  );
}
