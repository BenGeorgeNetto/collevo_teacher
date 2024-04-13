import 'package:collevo_teacher/data/activity_max_points.dart';
import 'package:collevo_teacher/enums/status_enum.dart';
import 'package:collevo_teacher/models/request.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collevo_teacher/services/preferences/preferences_service.dart';

class RequestsFetchService {
  Map<String, int> activityPoints = {};

  // Map<String, int> activityPointsToBeAdded = assignedPoints;
  Future<List<Request>> fetchMyRequestsByStatus(Status status) async {
    try {
      final String? batch = await PreferencesService().getBatch();

      final querySnapshot = await FirebaseFirestore.instance
          .collection('students')
          .doc(batch)
          .collection('requests')
          .where('status', isEqualTo: status.index)
          .get();

      final List<Request> myRequests = querySnapshot.docs.map((doc) {
        final data = doc.data();
        return Request(
          requestId: data['request_id'],
          activityId: data['activity_id'],
          createdBy: data['created_by'],
          createdAt: data['created_at'].toDate(),
          imageUrl: data['image_url'],
          status: Status.values[data['status']],
          activityType: data['activity_type'],
          activity: data['activity'],
          activityLevel: data['activity_level'],
          batch: data['batch'],
          yearActivityDoneIn: data['year_activity_done_in'],
          optionalMessage: data['optional_message'],
          awardedPoints: data['awarded_points'] ?? -1,
          optionalRemark: data['optional_remark'] ?? '',
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
    final String? batch = await PreferencesService().getBatch();
    try {
      final requestRef = FirebaseFirestore.instance
          .collection('students')
          .doc(batch)
          .collection('requests')
          .doc(request.requestId);

      // print(requestRef);

      int statusIndex = status.index;
      await requestRef.update({'status': statusIndex});
    } catch (e) {
      // print('Error updating request status: $e');
    }
  }

  Future<Map<String, int>> getActivityPoints(String uid) async {
    final PreferencesService preferencesService = PreferencesService();
    final String? batch = await preferencesService.getBatch();
    try {
      FirebaseFirestore firestore = FirebaseFirestore.instance;

      DocumentSnapshot<Map<String, dynamic>> studentDocument = await firestore
          .collection('students')
          .doc(batch)
          .collection('student_data')
          .where('uid', isEqualTo: uid)
          .limit(1)
          .get()
          .then((value) => value.docs.first);

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

  Future<void> insertActivityPoints(
      String activityId, String uid, int pointsToBeAdded) async {
    final String? batch = await PreferencesService().getBatch();
    var activityIdSplit = activityId.split('_');
    var activityType = activityIdSplit[0];
    var activity = activityIdSplit[1];
    // var activityLevel = activityIdSplit[2];

    var activityPartialId = '${activityType}_$activity';

    try {
      final querySnapshot = await FirebaseFirestore.instance
          .collection('students')
          .doc(batch)
          .collection("student_data")
          .where('uid', isEqualTo: uid)
          .limit(1)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        final studentDocument = querySnapshot.docs.first;
        final activityPointsData = studentDocument['activity_points'];

        int totalActivityPoints =
            studentDocument.data().containsKey('total_activity_points')
                ? studentDocument['total_activity_points']
                : 0;

        // int newActivityPointsValue = activityPointsData[activityType]! +
        //     activityPointsToBeAdded[activityId]!;
        // int newActivityPartialPointsValue =
        //     activityPointsData[activityPartialId]! +
        //         activityPointsToBeAdded[activityId]!;

        int newActivityPointsValue =
            activityPointsData[activityType]! + pointsToBeAdded;
        int newActivityPartialPointsValue =
            activityPointsData[activityPartialId]! + pointsToBeAdded;

        totalActivityPoints += pointsToBeAdded;

        Map<String, int> updatedActivityPoints = Map.from(activityPointsData);
        updatedActivityPoints[activityType] = newActivityPointsValue;
        updatedActivityPoints[activityPartialId] =
            newActivityPartialPointsValue;

        await studentDocument.reference.update({
          'activity_points': updatedActivityPoints,
          'total_activity_points': totalActivityPoints,
        });
      } else {
        // print('No student document found with UID: $uid');
      }
    } catch (e) {
      // print('Error updating activity points: $e');
    }
  }

  Future<void> setGivenActivityPoints(
      String requestId, int pointsToBeAdded) async {
    try {
      FirebaseFirestore firestore = FirebaseFirestore.instance;
      final String? batch = await PreferencesService().getBatch();

      firestore
          .collection('students')
          .doc(batch)
          .collection('requests')
          .doc(requestId)
          .update({
        'awarded_points': pointsToBeAdded,
      });
    } catch (e) {
      // print('Error setting given activity points: $e');
    }
  }

  Future<List<Request>> fetchPreviousAcceptedRequestsOfThatTypeByThatUser(
      String userId, String activityType) async {
    final String? batch = await PreferencesService().getBatch();

    try {
      final querySnapshot = await FirebaseFirestore.instance
          .collection('students')
          .doc(batch)
          .collection('requests')
          .where('created_by', isEqualTo: userId)
          .where('status', isEqualTo: Status.approved.index)
          .where('activity_type', isEqualTo: activityType)
          .get();

      final List<Request> acceptedRequests = querySnapshot.docs.map((doc) {
        return Request(
          requestId: doc['request_id'],
          activityId: doc['activity_id'],
          createdBy: doc['created_by'],
          createdAt: doc['created_at'].toDate(),
          imageUrl: doc['image_url'],
          status: Status.values[doc['status']],
          activityType: doc['activity_type'],
          activity: doc['activity'],
          activityLevel: doc['activity_level'],
          batch: doc['batch'],
          yearActivityDoneIn: doc['year_activity_done_in'],
          awardedPoints: doc['awarded_points'] ?? -1,
          optionalMessage: doc['optional_message'] ?? '',
        );
      }).toList();

      return acceptedRequests;
    } catch (e) {
      // print('Error fetching requests: $e');
      return [];
    }
  }

  Future<Request?> fetchRequestById(String requestId) async {
    final String? batch = await PreferencesService().getBatch();

    try {
      final docSnapshot = await FirebaseFirestore.instance
          .collection('students')
          .doc(batch)
          .collection('requests')
          .doc(requestId)
          .get();

      if (docSnapshot.exists) {
        return Request(
          requestId: docSnapshot['request_id'],
          activityId: docSnapshot['activity_id'],
          createdBy: docSnapshot['created_by'],
          createdAt: docSnapshot['created_at'].toDate(),
          imageUrl: docSnapshot['image_url'],
          status: Status.values[docSnapshot['status']],
          activityType: docSnapshot['activity_type'],
          activity: docSnapshot['activity'],
          activityLevel: docSnapshot['activity_level'],
          batch: docSnapshot['batch'],
          yearActivityDoneIn: docSnapshot['year_activity_done_in'],
          optionalMessage: docSnapshot['optional_message'] ?? '',
          optionalRemark: docSnapshot['optional_remark'] ?? '',
          awardedPoints: docSnapshot['awarded_points'] ?? -1,
        );
      } else {
        // print('No request found with ID: $requestId');
        return null;
      }
    } catch (e) {
      // print('Error fetching request: $e');
      return null;
    }
  }

  Future<bool> checkIfCanInsertActivityPoints(
      String activityId, String uid, int pointsToBeAdded) async {
    var activityIdSplit = activityId.split('_');
    var activityType = activityIdSplit[0];
    var activity = activityIdSplit[1];

    var activityPartialId = '${activityType}_$activity';

    Map<String, int> activityPoints = await getActivityPoints(uid);

    if (activityPoints[activityType]! + pointsToBeAdded <=
        maxPoints[activityType]!) {
      if (activityPoints[activityPartialId]! + pointsToBeAdded <=
          maxPoints[activityPartialId]!) {
        return true;
      }
    }
    return false;
  }

  Future<void> updateRequestStatusWithRemark(
      Request request, Status status, String remark) async {
    final String? batch = await PreferencesService().getBatch();
    try {
      final requestRef = FirebaseFirestore.instance
          .collection('students')
          .doc(batch)
          .collection('requests')
          .doc(request.requestId);

      int statusIndex = status.index;
      await requestRef.update({
        'status': statusIndex,
        'optional_remark': remark,
      });
    } catch (e) {
      // print('Error updating request status: $e');
    }
  }

  Future<List<Request>> fetchRequestsByStatusAndUid(
      Status status, String uid) async {
    try {
      final String? batch = await PreferencesService().getBatch();

      final querySnapshot = await FirebaseFirestore.instance
          .collection('students')
          .doc(batch)
          .collection('requests')
          .where('status', isEqualTo: status.index)
          .where('created_by', isEqualTo: uid)
          .get();

      final List<Request> myRequests = querySnapshot.docs.map((doc) {
        final data = doc.data();
        return Request(
          requestId: data['request_id'],
          activityId: data['activity_id'],
          createdBy: data['created_by'],
          createdAt: data['created_at'].toDate(),
          imageUrl: data['image_url'],
          status: Status.values[data['status']],
          activityType: data['activity_type'],
          activity: data['activity'],
          activityLevel: data['activity_level'],
          batch: data['batch'],
          yearActivityDoneIn: data['year_activity_done_in'],
          optionalMessage: data['optional_message'],
          awardedPoints: data['awarded_points'] ?? -1,
          optionalRemark: data['optional_remark'] ?? '',
        );
      }).toList();

      return myRequests;
    } catch (e) {
      // print('Error fetching requests: $e');
      return [];
    }
  }
}
