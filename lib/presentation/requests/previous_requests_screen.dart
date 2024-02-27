import 'package:collevo_teacher/widgets/requests/previous_request_card.dart';
import 'package:flutter/material.dart';
import 'package:collevo_teacher/models/request.dart';
import 'package:collevo_teacher/services/cloud/requests_fetch_service.dart';

class PreviousRequests extends StatefulWidget {
  final String requestId;

  const PreviousRequests({
    Key? key,
    required this.requestId,
  }) : super(key: key);

  @override
  State<PreviousRequests> createState() => _PreviousRequestsState();
}

class _PreviousRequestsState extends State<PreviousRequests> {
  late Future<List<Request>> previousRequestsFuture;

  @override
  void initState() {
    super.initState();
    String decodedRequestId = Uri.decodeComponent(widget.requestId);
    previousRequestsFuture = _fetchPreviousRequests(decodedRequestId);
  }

  Future<List<Request>> _fetchPreviousRequests(String requestId) async {
    try {
      final request = await RequestsFetchService().fetchRequestById(requestId);
      if (request != null) {
        return RequestsFetchService()
            .fetchPreviousAcceptedRequestsOfThatTypeByThatUser(
          request.createdBy,
          request.activityType,
        );
      } else {
        return [];
      }
    } catch (e) {
      throw Exception('Failed to fetch data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Previous Requests'),
          actions: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: IconButton(
                icon: const Icon(Icons.settings),
                onPressed: () {
                  Navigator.pushNamed(context, '/settings');
                },
              ),
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(32.0),
          child: FutureBuilder<List<Request>>(
            future: previousRequestsFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(
                  child: Text(
                    'Error encountered while fetching previous requests: ${snapshot.error}',
                  ),
                );
              } else if (snapshot.hasData) {
                final previousRequests = snapshot.data!;
                if (previousRequests.isEmpty) {
                  return const Center(
                    child: Text('No previous requests found.'),
                  );
                } else {
                  return ListView.builder(
                    itemCount: previousRequests.length,
                    itemBuilder: (context, index) {
                      final previousRequest = previousRequests[index];
                      return PreviousRequestCard(request: previousRequest);
                    },
                  );
                }
              } else {
                return const Center(
                  child: Text('No request found with the given ID.'),
                );
              }
            },
          ),
        ),
      ),
    );
  }
}
