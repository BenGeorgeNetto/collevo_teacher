import 'package:flutter/material.dart';

class EditPointsDialog extends StatefulWidget {
  final int initialPoints;

  const EditPointsDialog({Key? key, required this.initialPoints})
      : super(key: key);

  @override
  State<EditPointsDialog> createState() => _EditPointsDialogState();
}

class _EditPointsDialogState extends State<EditPointsDialog> {
  late TextEditingController _pointsController;

  @override
  void initState() {
    super.initState();
    _pointsController =
        TextEditingController(text: widget.initialPoints.toString());
  }

  @override
  void dispose() {
    _pointsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double desiredWidth = screenWidth * 0.5;
    double maxWidth = 640.0;
    double containerWidth = desiredWidth > maxWidth ? maxWidth : desiredWidth;

    return AlertDialog(
      title: Text(
        'Edit Activity Points',
        style: Theme.of(context).textTheme.headlineSmall,
      ),
      content: SizedBox(
        width: containerWidth,
        child: TextFormField(
          controller: _pointsController,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
            hintText: 'Enter new points',
            border: OutlineInputBorder(),
          ),
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      ),
      actions: <Widget>[
        TextButton(
          child: const Text('Cancel'),
          onPressed: () => Navigator.of(context).pop(),
        ),
        TextButton(
          child: const Text('Save'),
          onPressed: () {
            if (_pointsController.text.isNotEmpty) {
              Navigator.of(context).pop(int.parse(_pointsController.text));
            }
          },
        ),
      ],
    );
  }
}
