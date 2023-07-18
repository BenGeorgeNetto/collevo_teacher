import 'package:collevo_teacher/data/activity_assigned_points.dart';
import 'package:collevo_teacher/enums/status_enum.dart';
import 'package:collevo_teacher/models/request.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collevo_teacher/services/preferences/preferences_service.dart';

class RequestsFetchService {
  Map<String, int> activityPoints = {};
  Map<String, int> activityPointsToBeAdded = assignedPoints;
  Future<List<Request>> fetchMyRequestsByStatus(Status status) async {
    try {
      final String? currentUserUID = await PreferencesService().getUid();

      final querySnapshot = await FirebaseFirestore.instance
          .collection('requests')
          .where('assigned_to', isEqualTo: currentUserUID)
          .where('status', isEqualTo: status.index)
          .get();

      final List<Request> myRequests = querySnapshot.docs.map((doc) {
        return Request(
          requestId: doc['request_id'],
          activityId: doc['activity_id'],
          createdBy: doc['created_by'],
          createdAt: doc['created_at'].toDate(),
          imageUrl: doc['image_url'],
          assignedTo: doc['assigned_to'],
          status: Status.values[doc['status']],
          activityType: doc['activity_type'],
          activity: doc['activity'],
          activityLevel: doc['activity_level'],
        );
      }).toList();

      return myRequests;
    } catch (e) {
      // print('Error fetching requests: $e');
      return [];
    }
  }

  Future<List<Request>> fetchApprovedRequests() async {
    return fetchMyRequestsByStatus(Status.approved);
  }

  Future<List<Request>> fetchPendingRequests() async {
    return fetchMyRequestsByStatus(Status.pending);
  }

  Future<List<Request>> fetchRejectedRequests() async {
    return fetchMyRequestsByStatus(Status.rejected);
  }

  Future<void> updateRequestStatus(Request request, Status status) async {
    try {
      final requestRef = FirebaseFirestore.instance
          .collection('requests')
          .doc(request.requestId);

      int statusIndex = status.index;
      await requestRef.update({'status': statusIndex});
    } catch (e) {
      print('Error updating request status: $e');
    }
  }

  Future<Map<String, int>> getActivityPoints() async {
    final PreferencesService preferencesService = PreferencesService();
    final String? email = await preferencesService.getEmail();
    try {
      FirebaseFirestore firestore = FirebaseFirestore.instance;

      DocumentSnapshot<Map<String, dynamic>> studentDocument =
          await firestore.collection('students').doc(email).get();

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

  Future<void> insertActivityPoints(String activityId, String uid) async {
    var activityIdSplit = activityId.split('_');
    var activityType = activityIdSplit[0];
    var activity = activityIdSplit[1];
    // var activityLevel = activityIdSplit[2];

    var activityPartialId = '${activityType}_$activity';

    try {
      final querySnapshot = await FirebaseFirestore.instance
          .collection('students')
          .where('uid', isEqualTo: uid)
          .limit(1)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        final studentDocument = querySnapshot.docs.first;
        final activityPointsData = studentDocument['activity_points'];

        int newActivityPointsValue = activityPointsData[activityType]! +
            activityPointsToBeAdded[activityId]!;
        int newActivityPartialPointsValue =
            activityPointsData[activityPartialId]! +
                activityPointsToBeAdded[activityId]!;

        Map<String, int> updatedActivityPoints = Map.from(activityPointsData);
        updatedActivityPoints[activityType] = newActivityPointsValue;
        updatedActivityPoints[activityPartialId] =
            newActivityPartialPointsValue;

        await studentDocument.reference.update({
          'activity_points': updatedActivityPoints,
        });
      } else {
        print('No student document found with UID: $uid');
      }
    } catch (e) {
      print('Error updating activity points: $e');
    }
  }
}
