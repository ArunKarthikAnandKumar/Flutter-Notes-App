import 'package:flutter/material.dart';
import 'package:mynotes_app/utilites/show_generic_dialog.dart';

Future<void> showCannotShareEmptyNoteDialog(BuildContext context) {
  return showGenericDialog<void>(
    context: context,
    title: 'sharing',
    content: 'You cannot share An EmptyNote',
    optionsBuilder: () => {
      'ok': null,
    },
  );
}