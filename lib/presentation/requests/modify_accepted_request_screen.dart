import 'package:collevo_teacher/models/student_uid_info.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collevo_teacher/services/preferences/preferences_service.dart';
import 'package:collevo_teacher/widgets/requests/student_tile.dart';

class ModifyAcceptedRequestScreen extends StatefulWidget {
  const ModifyAcceptedRequestScreen({super.key});

  @override
  State<ModifyAcceptedRequestScreen> createState() =>
      _ModifyAcceptedRequestScreenState();
}

class _ModifyAcceptedRequestScreenState
    extends State<ModifyAcceptedRequestScreen> {
  List<StudentUidInfo> students = [];

  @override
  void initState() {
    super.initState();
    fetchStudents();
  }

  Future<void> fetchStudents() async {
    PreferencesService preferencesService = PreferencesService();
    String? batch = await preferencesService.getBatch();
    var studentsSnapshot = await FirebaseFirestore.instance
        .collection('students')
        .doc(batch)
        .collection('student_data')
        .get();

    List<StudentUidInfo> loadedStudents = studentsSnapshot.docs.map((doc) {
      Map<String, dynamic> data = doc.data();
      return StudentUidInfo(
        data['s_name'],
        data['uid'] ?? 'accnotcreatedyet',
        data['email'],
      );
    }).toList();

    setState(() {
      students = loadedStudents;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Modify Accepted Requests'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(32.0),
          child: students.isEmpty
              ? const Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: students.map((student) {
                        return StudentTile(studentInfo: student);
                      }).toList(),
                    ),
                  ),
                ),
        ),
      ),
    );
  }
}
