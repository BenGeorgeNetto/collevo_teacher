import 'package:collevo_teacher/enums/status_enum.dart';
import 'package:collevo_teacher/utilities/dialogs/edit_points_dialog.dart';
import 'package:collevo_teacher/widgets/requests/modify_accepted_request_card.dart';
import 'package:flutter/material.dart';
import 'package:collevo_teacher/models/request.dart';
import 'package:collevo_teacher/services/cloud/requests_fetch_service.dart';
import 'package:collevo_teacher/services/cloud/activity_points_service.dart';

class ModifyAcceptedRequestsStudentScreen extends StatefulWidget {
  final String uid;
  final String email;
  const ModifyAcceptedRequestsStudentScreen({
    super.key,
    required this.uid,
    required this.email,
  });

  @override
  State<ModifyAcceptedRequestsStudentScreen> createState() =>
      _ModifyAcceptedRequestsStudentScreenState();
}

class _ModifyAcceptedRequestsStudentScreenState
    extends State<ModifyAcceptedRequestsStudentScreen> {
  // Future<List<Request>>? _requestsFuture;
  List<Request> requests = [];

  @override
  void initState() {
    super.initState();
    _loadRequests();
  }

  Future<void> _loadRequests() async {
    final requestsService = RequestsFetchService();
    // _requestsFuture = requestsService.fetchRequestsByStatusAndUid(Status.approved, widget.uid);
    List<Request> fetchedRequests = await requestsService
        .fetchRequestsByStatusAndUid(Status.approved, widget.uid);
    setState(() {
      requests = fetchedRequests;
    });
  }

  void _editActivityPoints(Request request, int index) async {
    final newPoints = await showDialog<int>(
      context: context,
      builder: (context) =>
          EditPointsDialog(initialPoints: request.awardedPoints ?? 0),
    );
    if (newPoints != null && newPoints != request.awardedPoints) {
      final activityPointsService = ActivityPointsService(widget.email);
      bool updateSuccessful = await activityPointsService.editActivityPoints(
          request.requestId, newPoints);
      if (updateSuccessful) {
        setState(() {
          requests[index].awardedPoints = newPoints;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Modify Accepted Requests'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(32.0),
        child: requests.isEmpty
            ? const Center(child: Text("No accepted requests found."))
            : ListView.builder(
                itemCount: requests.length,
                itemBuilder: (context, index) {
                  final request = requests[index];
                  return ModifyAcceptedRequestCard(
                    request: request,
                    onEdit: () => _editActivityPoints(request, index),
                  );
                },
              ),
      ),
    );
  }
}
