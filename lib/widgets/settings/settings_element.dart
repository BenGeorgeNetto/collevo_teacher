import 'package:collevo_teacher/colors.dart';
import 'package:flutter/material.dart';

class SettingsElement extends StatelessWidget {
  final String element;
  final void Function() onTap;

  const SettingsElement({
    super.key,
    required this.element,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double desiredWidth = screenWidth * 0.5;
    double maxWidth = 500.0;
    double containerWidth = desiredWidth > maxWidth ? maxWidth : desiredWidth;

    return SizedBox(
      width: containerWidth,
      child: Column(
        children: [
          ListTile(
            title: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                element,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
            onTap: onTap,
          ),
          const Divider(
            color: CustomColors.blueGray,
            thickness: 1.0,
            indent: 16.0,
            endIndent: 16.0,
          )
        ],
      ),
    );
  }
}
