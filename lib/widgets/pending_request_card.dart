import 'package:collevo_teacher/models/request.dart';
import 'package:flutter/material.dart';

class PendingRequestCard extends StatelessWidget {
  final Request request;
  final VoidCallback? onAccept;
  final VoidCallback? onReject;

  const PendingRequestCard({
    Key? key,
    required this.request,
    this.onAccept,
    this.onReject,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var requestIdSplit = request.requestId.split('_');
    final studentName = requestIdSplit[1];
    double imageMaxSize = 800;
    double preferredSize = MediaQuery.of(context).size.width * 0.5;
    double imageSize =
        preferredSize > imageMaxSize ? imageMaxSize : preferredSize;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Card(
        child: ExpansionTile(
          title: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
                '$studentName: ${request.activity} - ${request.activityLevel}'),
          ),
          subtitle: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Created At:',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                Text(
                  request.createdAt.toString(),
                  style: Theme.of(context).textTheme.labelSmall,
                ),
              ],
            ),
          ),
          collapsedShape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          backgroundColor: Colors.black87,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: double.infinity,
                    child: Center(
                      child: SizedBox(
                        width: imageSize,
                        child: Image.network(
                          request.imageUrl,
                          fit: BoxFit.fitWidth,
                          errorBuilder: (context, error, stackTrace) {
                            // print(stackTrace);
                            // print(error);
                            return const Icon(Icons.error);
                          },
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: SizedBox(
                      width: double.infinity,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Created at:',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                          Text(
                            '${request.createdAt}',
                            style: Theme.of(context).textTheme.labelSmall,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Activity Type:',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                          Text(
                            request.activityType,
                            style: Theme.of(context).textTheme.labelSmall,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Activity:',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                          Text(
                            request.activity,
                            style: Theme.of(context).textTheme.labelSmall,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Activity Level:',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                          Text(
                            request.activityLevel,
                            style: Theme.of(context).textTheme.labelSmall,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Activity ID:',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                          Text(
                            request.activityId,
                            style: Theme.of(context).textTheme.labelSmall,
                          ),
                          const SizedBox(height: 16),
                          Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              ElevatedButton(
                                onPressed: onAccept,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.green,
                                ),
                                child: const Text('Accept'),
                              ),
                              ElevatedButton(
                                onPressed: onReject,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.red,
                                ),
                                child: const Text('Reject'),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
