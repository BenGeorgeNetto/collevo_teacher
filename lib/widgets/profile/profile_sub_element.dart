import 'package:flutter/material.dart';

class ProfileSubElement extends StatelessWidget {
  final String text;

  const ProfileSubElement({
    super.key,
    required this.text,
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
            title: Text(
              text,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
        ],
      ),
    );
  }
}
