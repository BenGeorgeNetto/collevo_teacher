import 'package:collevo_teacher/colors.dart';
import 'package:flutter/material.dart';

class HomeCard extends StatelessWidget {
  final String cardText;
  final String routeName;

  const HomeCard({
    super.key,
    required this.cardText,
    required this.routeName,
  });

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double desiredWidth = screenWidth * 0.5;
    double maxWidth = 400.0;

    double containerWidth = desiredWidth > maxWidth ? maxWidth : desiredWidth;

    return Padding(
      padding: const EdgeInsets.all(.0),
      child: InkWell(
        onTap: () {
          Navigator.pushNamed(context, routeName);
        },
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12.0),
            color: CustomColors.blueGray,
          ),
          width: containerWidth,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Center(
              child: Text(
                cardText,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
