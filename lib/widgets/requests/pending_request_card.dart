import 'package:collevo_teacher/models/request.dart';
import 'package:flutter/material.dart';
import 'package:collevo_teacher/data/activity_assigned_points.dart';

class PendingRequestCard extends StatelessWidget {
  final Request request;
  final void Function(int)? onAccept;
  final VoidCallback? onReject;

  const PendingRequestCard({
    Key? key,
    required this.request,
    this.onAccept,
    this.onReject,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    int defaultActivityPoints = assignedPoints[request.activityId] ?? 0;
    int pointsGoingToBeAdded = defaultActivityPoints;
    final pointsController =
        TextEditingController(text: pointsGoingToBeAdded.toString());
    final isEditing = ValueNotifier<bool>(false);
    final isReset = ValueNotifier<bool>(false);
    final focusNode = FocusNode();
    var requestIdSplit = request.requestId.split('_');
    final studentName = requestIdSplit[1];
    double imageMaxSize = 900;
    double preferredSize = MediaQuery.of(context).size.width * 0.7;
    double imageSize =
        preferredSize > imageMaxSize ? imageMaxSize : preferredSize;
    double screenWidth = MediaQuery.of(context).size.width;
    double desiredWidth = screenWidth * 0.8;
    double maxWidth = 1400;
    double containerWidth = desiredWidth > maxWidth ? maxWidth : desiredWidth;
    return Align(
      alignment: Alignment.center,
      child: SizedBox(
        width: containerWidth,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Card(
            child: ExpansionTile(
              title: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  '$studentName: ${request.activity} - ${request.activityLevel}',
                ),
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
                      '${request.createdAt.day.toString().padLeft(2, '0')}:${request.createdAt.month.toString().padLeft(2, '0')}:${request.createdAt.year}    ${request.createdAt.hour.toString().padLeft(2, '0')}:${request.createdAt.minute.toString().padLeft(2, '0')}',
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
                                'Points to be awarded:',
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                              // TODO: Fix the focus issue when clicking edit icon
                              ValueListenableBuilder<bool>(
                                valueListenable: isEditing,
                                builder: (context, isEditingValue, child) {
                                  return Row(
                                    children: [
                                      Expanded(
                                        child: TextField(
                                          controller: pointsController,
                                          style: Theme.of(context)
                                              .textTheme
                                              .labelMedium,
                                          enabled: isEditingValue,
                                          focusNode: focusNode,
                                        ),
                                      ),
                                      IconButton(
                                        icon: Icon(isEditingValue
                                            ? Icons.check
                                            : Icons.edit),
                                        onPressed: () {
                                          if (isEditingValue) {
                                            pointsGoingToBeAdded =
                                                int.parse(pointsController.text);
                                          } else {
                                            // Request focus to the TextField
                                            focusNode.requestFocus();
                                          }
                                          isEditing.value = !isEditingValue;
                                        },
                                      ),
                                      ValueListenableBuilder<bool>(
                                        valueListenable: isReset,
                                        builder: (context, isResetValue, child) {
                                          return (pointsGoingToBeAdded !=
                                                  defaultActivityPoints)
                                              ? IconButton(
                                                  icon: const Icon(Icons.refresh),
                                                  onPressed: () {
                                                    pointsGoingToBeAdded =
                                                        defaultActivityPoints;
                                                    pointsController.text =
                                                        defaultActivityPoints
                                                            .toString();
                                                    // Trigger a rebuild
                                                    isReset.value = !isResetValue;
                                                  },
                                                )
                                              : Container();
                                        },
                                      ),
                                    ],
                                  );
                                },
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Default Points:',
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                              Text(
                                defaultActivityPoints.toString(),
                                style: Theme.of(context).textTheme.labelMedium,
                              ),
                              const SizedBox(height: 16),
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
                                'Year activity was done:',
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                              Text(
                                getYearString(request.yearActivityDoneIn),
                                style: Theme.of(context).textTheme.labelSmall,
                              ),
                              const SizedBox(height: 8),
                              Visibility(
                                visible: request.optionalMessage != "",
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Additional Comments:',
                                      style: Theme.of(context).textTheme.bodyMedium,
                                    ),
                                    Text(
                                      '${request.optionalMessage}',
                                      style: Theme.of(context).textTheme.labelSmall,
                                    ),
                                  ],
                                ),
                              ),

                              // For Debug purposes:
                              // Text(
                              //   'Activity ID:',
                              //   style: Theme.of(context).textTheme.bodyMedium,
                              // ),
                              // Text(
                              //   request.activityId,
                              //   style: Theme.of(context).textTheme.labelSmall,
                              // ),
                              const SizedBox(height: 16),
                              Center(
                                child: Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: OutlinedButton(
                                    onPressed: () async {
                                      Navigator.pushNamed(
                                        context,
                                        '/previous_requests/${request.requestId}',
                                      );
                                    },
                                    child: const Text('View Previous Requests'),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 16),
                              Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  ElevatedButton(
                                    onPressed: () =>
                                        onAccept?.call(pointsGoingToBeAdded),
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
                              ),
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
        ),
      ),
    );
  }
}

String getYearString(int year) {
  if (year == 1) {
    return 'First Year';
  } else if (year == 2) {
    return 'Second Year';
  } else if (year == 3) {
    return 'Third Year';
  } else if (year == 4) {
    return 'Fourth Year';
  } else {
    return 'Unknown';
  }
}