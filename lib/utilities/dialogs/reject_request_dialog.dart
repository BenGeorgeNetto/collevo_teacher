import 'package:flutter/material.dart';

Future<String?> showRejectRequestDialog(BuildContext context) async {
  double screenWidth = MediaQuery.of(context).size.width;
  double desiredWidth = screenWidth * 0.5;
  double maxWidth = 640.0;
  double containerWidth = desiredWidth > maxWidth ? maxWidth : desiredWidth;
  final TextEditingController controller = TextEditingController();
  return showDialog<String>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        contentPadding: EdgeInsets.zero,
        title: Text(
          'Enter reason for rejection',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        content: SizedBox(
          width: containerWidth,
          child: Container(
            padding: const EdgeInsets.all(24),
            child: TextField(
              controller: controller,
              decoration: const InputDecoration(hintText: "Enter reason here"),
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
        ),
        actions: <Widget>[
          TextButton(
            style: TextButton.styleFrom(
              backgroundColor: Theme.of(context).primaryColor,
              foregroundColor: Colors.black,
            ),
            child: const Text('Cancel'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          TextButton(
            style: TextButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.black,
            ),
            child: const Text('Reject Request'),
            onPressed: () {
              Navigator.of(context).pop(controller.text);
            },
          ),
        ],
      );
    },
  );
}
