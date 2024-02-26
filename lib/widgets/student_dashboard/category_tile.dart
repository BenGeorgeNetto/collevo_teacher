import 'package:flutter/material.dart';

import 'student_element.dart';

class CategoryTile extends StatelessWidget {
  final String category;
  final List<String> students;

  const CategoryTile({
    Key? key,
    required this.category,
    required this.students,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double desiredWidth = screenWidth * 0.5;
    double maxWidth = 750.0;
    double containerWidth = desiredWidth > maxWidth ? maxWidth : desiredWidth;

    return Align(
      alignment: Alignment.center,
      child: SizedBox(
        width: containerWidth,
        child: ExpansionTile(
          title: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              '$category: ${students.length} Students',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
          children:
          students.map((name) => StudentElement(element: name)).toList(),
        ),
      ),
    );
  }
}
