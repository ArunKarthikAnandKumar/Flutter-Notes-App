import 'package:flutter/material.dart';

import '../show_generic_dialog.dart';

Future<void> showPasswordResetSentDialog(BuildContext context) {
  return showGenericDialog<void>(
    context: context,
    title: 'Password Reset',
    content: 'We have sent password Reset Link Please check your Email.',
    optionsBuilder: () => {
      'OK': null,
    },
  );
}