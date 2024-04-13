import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collevo_teacher/models/request.dart';
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

  Future<bool> editActivityPoints(String requestId, int newPoints) async {
    final String? batch = await PreferencesService().getBatch();
    try {
      final requestRef = FirebaseFirestore.instance
          .collection('students')
          .doc(batch)
          .collection('requests')
          .doc(requestId);

      final doc = await requestRef.get();
      if (!doc.exists) {
        // print('Request not found');
        return false;
      }

      Request request = Request.fromMap(doc.data()!);
      int originalPoints = request.awardedPoints ?? 0;
      int pointsToModifyBy = newPoints - originalPoints;

      final studentDocument = await FirebaseFirestore.instance
          .collection('students')
          .doc(batch)
          .collection('student_data')
          .doc(email)
          .get();

      if (!studentDocument.exists) {
        // print('Student not found');
        return false;
      }

      Map<String, dynamic> studentData = studentDocument.data()!;
      Map<String, dynamic> activityPoints = studentData['activity_points'];
      List<String> activityIdSplit = request.activityId.split('_');
      String activityType = activityIdSplit[0];
      String activity = activityIdSplit[1];

      // Update points in the student document
      studentData['total_activity_points'] += pointsToModifyBy;
      activityPoints[activityType] += pointsToModifyBy;
      String activityCombinedKey = '${activityType}_$activity';
      if (activityPoints.containsKey(activityCombinedKey)) {
        activityPoints[activityCombinedKey] += pointsToModifyBy;
      }

      // Update the student document
      studentDocument.reference.update({
        'total_activity_points': studentData['total_activity_points'],
        'activity_points': activityPoints
      });

      // Update the request document
      requestRef.update({'awarded_points': newPoints});
      return true;
    } catch (e) {
      // print('Error editing activity points: $e');
      return false;
    }
  }
}