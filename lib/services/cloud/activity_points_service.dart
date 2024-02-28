import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collevo_teacher/services/preferences/preferences_service.dart';

class ActivityPointsService {
  final String email;
  Map<String, int> activityPoints = {};

  ActivityPointsService(this.email);

  Future<int?> getTotalActivityPoints() async {
    try {
      FirebaseFirestore firestore = FirebaseFirestore.instance;
      final String? batch = await PreferencesService().getBatch();

      DocumentSnapshot<Map<String, dynamic>> studentDocument = await firestore
          .collection('students')
          .doc(batch)
          .collection('student_data')
          .doc(email)
          .get();

      if (studentDocument.exists) {
        // print('Document data: ${studentDocument.data()}');
        Map<String, dynamic> data = studentDocument.data()!;
        int totalActivityPoints = data['total_activity_points'] as int;

        return totalActivityPoints;
      } else {
        // print('Document does not exist on the database');
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  Future<Map<String, int>> getActivityPoints() async {
    try {
      FirebaseFirestore firestore = FirebaseFirestore.instance;
      final String? batch = await PreferencesService().getBatch();

      DocumentSnapshot<Map<String, dynamic>> studentDocument = await firestore
          .collection('students')
          .doc(batch)
          .collection('student_data')
          .doc(email)
          .get();

      if (studentDocument.exists) {
        // print('Document data: ${studentDocument.data()}');
        Map<String, dynamic> data = studentDocument.data()!;
        data['activity_points'].forEach((key, value) {
          activityPoints[key] = value as int;
        });

        return activityPoints;
      } else {
        // print('Document does not exist on the database');
        return {};
      }
    } catch (e) {
      // print('Error getting activityPoints: $e');
      return {};
    }
  }

  Future<String> getStudentName() async {
    try {
      FirebaseFirestore firestore = FirebaseFirestore.instance;
      final String? batch = await PreferencesService().getBatch();

      DocumentSnapshot<Map<String, dynamic>> studentDocument = await firestore
          .collection('students')
          .doc(batch)
          .collection('student_data')
          .doc(email)
          .get();

      if (studentDocument.exists) {
        // print('Document data: ${studentDocument.data()}');
        Map<String, dynamic> data = studentDocument.data()!;
        String studentName = data['s_name'] as String;

        return studentName;
      } else {
        // print('Document does not exist on the database');
        return '';
      }
    } catch (e) {
      // print('Error getting studentName: $e');
      return '';
    }
  }
}