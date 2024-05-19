import 'package:collevo_teacher/enums/status_enum.dart';
import 'package:collevo_teacher/models/request.dart';
import 'package:collevo_teacher/services/cloud/requests_fetch_service.dart';
import 'package:collevo_teacher/utilities/dialogs/cannot_accept_request_dialog.dart';
import 'package:collevo_teacher/utilities/dialogs/reject_request_dialog.dart';
import 'package:collevo_teacher/widgets/requests/pending_request_card.dart';
import 'package:flutter/material.dart';

class PendingRequests extends StatefulWidget {
  const PendingRequests({super.key});

  @override
  State<PendingRequests> createState() => _PendingRequestsState();
}

class _PendingRequestsState extends State<PendingRequests> {
  Future<List<Request>>? _requestsFuture;
  final RequestsFetchService _requestsFetchService = RequestsFetchService();
  String _sortOption = 'Time';

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
    var radioWidth = 32.0;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Pending Requests'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    'Sort by:',
                    style: Theme.of(context).textTheme.labelLarge,
                  ),
                  SizedBox(width: radioWidth),
                  Row(
                    children: [
                      const Text('Time'),
                      Radio<String>(
                        value: 'Time',
                        groupValue: _sortOption,
                        onChanged: (String? value) {
                          setState(() {
                            _sortOption = value!;
                            _loadRequests();
                          });
                        },
                      ),
                    ],
                  ),
                  SizedBox(width: radioWidth / 4),
                  Row(
                    children: [
                      const Text('Name'),
                      Radio<String>(
                        value: 'Name',
                        groupValue: _sortOption,
                        onChanged: (String? value) {
                          setState(() {
                            _sortOption = value!;
                            _loadRequests();
                          });
                        },
                      ),
                    ],
                  ),
                ],
              ),
              Expanded(
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
                        requests.sort((a, b) {
                          if (_sortOption == 'Time') {
                            return a.createdAt.compareTo(b.createdAt);
                          } else {
                            String nameA = a.requestId.split('_')[1];
                            String nameB = b.requestId.split('_')[1];
                            return nameA.compareTo(nameB);
                          }
                        });

                        return ListView.builder(
                          itemCount: requests.length,
                          itemBuilder: (context, index) {
                            final request = requests[index];
                            return PendingRequestCard(
                              request: request,
                              onAccept: (int pointsToBeAdded) async {
                                bool canInsert = await _requestsFetchService
                                    .checkIfCanInsertActivityPoints(
                                  request.activityId,
                                  request.createdBy,
                                  pointsToBeAdded,
                                );
                                if (canInsert) {
                                  _requestsFetchService.insertActivityPoints(
                                    request.activityId,
                                    request.createdBy,
                                    pointsToBeAdded,
                                  );
                                  _requestsFetchService.setGivenActivityPoints(
                                    request.requestId,
                                    pointsToBeAdded,
                                  );
                                  _updateRequestStatus(
                                    request,
                                    Status.approved,
                                  );
                                } else {
                                  // ignore: use_build_context_synchronously
                                  showCannotAcceptRequestDialog(
                                    context,
                                    'The request cannot be accepted as it exceeds the maximum allowed points. Please reject the request.',
                                  );
                                }
                              },
                              onReject: () async {
                                String? reason =
                                    await showRejectRequestDialog(context);
                                if (reason != null && reason.isNotEmpty) {
                                  _updateRequestStatusWithRemark(
                                    request,
                                    Status.rejected,
                                    reason,
                                  );
                                }
                              },
                            );
                          },
                        );
                      }
                    }
                  },
                ),
              ),
            ],
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

  Future<void> _updateRequestStatusWithRemark(
      Request request, Status status, String remark) async {
    try {
      final requestsService = RequestsFetchService();
      await requestsService.updateRequestStatusWithRemark(
        request,
        status,
        remark,
      );
      _loadRequests();
    } catch (e) {
      // print("Error updating request status: $e");
    }
  }
}
