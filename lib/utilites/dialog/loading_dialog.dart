import 'package:flutter/material.dart';

typedef ClosedDialog = void Function();

ClosedDialog showLoadingDialog({
  required BuildContext context,
  required String text,
}) {
  final dialog = AlertDialog(
    content: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const CircularProgressIndicator(),
        const SizedBox(
          height: 10,
        ),
        Text(text),
      ],
    ),
  );
  showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => dialog);
  return () => Navigator.of(context).pop();
}
