import 'package:collevo_teacher/enums/status_enum.dart';
import 'package:collevo_teacher/models/request.dart';
import 'package:collevo_teacher/services/cloud/requests_fetch_service.dart';
import 'package:collevo_teacher/widgets/pending_request_card.dart';
import 'package:flutter/material.dart';

class PendingRequests extends StatefulWidget {
  const PendingRequests({super.key});

  @override
  State<PendingRequests> createState() => _PendingRequestsState();
}

class _PendingRequestsState extends State<PendingRequests> {
  Future<List<Request>>? _requestsFuture;
  final RequestsFetchService _requestsFetchService = RequestsFetchService();

  @override
  void initState() {
    super.initState();
    _loadRequests();
  }

  Future<void> _loadRequests() async {
    final requestsService = RequestsFetchService();
    _requestsFuture = requestsService.fetchPendingRequests();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Pending Requests'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Center(
            child: FutureBuilder<List<Request>>(
              future: _requestsFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text("Error: ${snapshot.error}"));
                } else {
                  final requests = snapshot.data;
                  if (requests == null || requests.isEmpty) {
                    return const Center(
                      child: Text("No pending requests found."),
                    );
                  } else {
                    return ListView.builder(
                      itemCount: requests.length,
                      itemBuilder: (context, index) {
                        final request = requests[index];
                        return PendingRequestCard(
                          request: request,
                          onAccept: (int pointsToBeAdded) {
                            _requestsFetchService.insertActivityPoints(
                                request.activityId, request.createdBy, pointsToBeAdded);
                            _updateRequestStatus(request, Status.approved);
                          },
                          onReject: () {
                            _updateRequestStatus(request, Status.rejected);
                          },
                        );
                      },
                    );
                  }
                }
              },
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _updateRequestStatus(Request request, Status status) async {
    try {
      final requestsService = RequestsFetchService();
      await requestsService.updateRequestStatus(request, status);
      _loadRequests();
    } catch (e) {
      // print("Error updating request status: $e");
    }
  }
}
