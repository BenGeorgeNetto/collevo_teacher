import 'package:collevo_teacher/utilities/dialogs/generic_dialog.dart';
import 'package:flutter/material.dart';

Future<void> showCannotAcceptRequestDialog(
  BuildContext context,
  String text,
) {
  return showGenericDialog<void>(
    context: context,
    title:
        'Reject the request',
    content: text,
    optionsBuilder: () => {
      'OK': null,
    },
  );
}
