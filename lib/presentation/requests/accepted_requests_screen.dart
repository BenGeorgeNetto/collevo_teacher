import 'package:collevo_teacher/models/request.dart';
import 'package:collevo_teacher/services/cloud/requests_fetch_service.dart';
import 'package:collevo_teacher/widgets/requests/accepted_request_card.dart';
import 'package:flutter/material.dart';

class AcceptedRequests extends StatefulWidget {
  const AcceptedRequests({Key? key}) : super(key: key);

  @override
  State<AcceptedRequests> createState() => _AcceptedRequestsState();
}

class _AcceptedRequestsState extends State<AcceptedRequests> {
  Future<List<Request>>? _requestsFuture;
  String _sortOption = 'Time';
  var radioWidth = 32.0;

  @override
  void initState() {
    super.initState();
    _loadRequests();
  }

  Future<void> _loadRequests() async {
    final requestsService = RequestsFetchService();
    _requestsFuture = requestsService.fetchApprovedRequests();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Accepted Requests'),
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
                          child: Text("No accepted requests found."),
                        );
                      } else {
                        requests.sort((b, a) {
                          if (_sortOption == 'Time') {
                            return a.createdAt.compareTo(b.createdAt);
                          } else {
                            return a.createdBy.compareTo(b.createdBy);
                          }
                        });
                        return ListView.builder(
                          itemCount: requests.length,
                          itemBuilder: (context, index) {
                            final request = requests[index];
                            return AcceptedRequestCard(request: request);
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
}
