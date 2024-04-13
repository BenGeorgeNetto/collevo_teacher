import 'package:collevo_teacher/colors.dart';
import 'package:collevo_teacher/models/student_uid_info.dart';
import 'package:flutter/material.dart';

class StudentTile extends StatelessWidget {
  final StudentUidInfo studentInfo;

  const StudentTile({
    super.key,
    required this.studentInfo,
  });

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double desiredWidth = screenWidth * 0.5;
    double maxWidth = 700.0;
    double containerWidth = desiredWidth > maxWidth ? maxWidth : desiredWidth;

    return SizedBox(
      width: containerWidth,
      child: Column(
        children: [
          ListTile(
            title: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                studentInfo.name,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
            onTap: () {
              Navigator.of(context).pushNamed(
                  '/modify_accepted_request_student/${studentInfo.uid}/${studentInfo.email}');
            },
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
