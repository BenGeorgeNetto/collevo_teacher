// ignore_for_file: use_build_context_synchronously

import 'package:collevo_teacher/services/cloud/data_export_service.dart';
import 'package:collevo_teacher/utilities/dialogs/error_dialog.dart';
import 'package:collevo_teacher/utilities/dialogs/successful_export_dialog.dart';
import 'package:flutter/material.dart';

class ExportStudentDataScreen extends StatefulWidget {
  const ExportStudentDataScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<ExportStudentDataScreen> createState() =>
      _ExportStudentDataScreenState();
}

class _ExportStudentDataScreenState extends State<ExportStudentDataScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double desiredWidth = screenWidth * 0.75;
    double maxWidth = 750.0;
    double containerWidth = desiredWidth > maxWidth ? maxWidth : desiredWidth;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Export Student Data'),
      ),
      body: Align(
        alignment: Alignment.topCenter,
        child: SingleChildScrollView(
          child: SizedBox(
            width: containerWidth,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Text(
                    'Export activity points obtained by the students',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.05 / 2,
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      try {
                        await DataExportService.exportStudentData();
                        await showSuccessDialog(
                            context, 'Data successfully exported!');
                      } catch (error) {
                        await showErrorDialog(
                            context, 'Failed to export data: $error');
                      }
                    },
                    child: const Text('Download CSV'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
