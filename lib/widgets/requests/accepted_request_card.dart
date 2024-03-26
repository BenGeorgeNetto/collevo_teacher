import 'package:collevo_teacher/models/request.dart';
import 'package:flutter/material.dart';

class AcceptedRequestCard extends StatelessWidget {
  final Request request;

  const AcceptedRequestCard({
    Key? key,
    required this.request,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
                    '$studentName: ${request.activity} - ${request.activityLevel}'),
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
                                '${request.createdAt.day.toString().padLeft(2, '0')}:${request.createdAt.month.toString().padLeft(2, '0')}:${request.createdAt.year}    ${request.createdAt.hour.toString().padLeft(2, '0')}:${request.createdAt.minute.toString().padLeft(2, '0')}',
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
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium,
                                    ),
                                    Text(
                                      '${request.optionalMessage}',
                                      style: Theme.of(context)
                                          .textTheme
                                          .labelSmall,
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 8),
                              Visibility(
                                visible: request.awardedPoints != null ||
                                    request.awardedPoints != -1,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Awarded Points:',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium,
                                    ),
                                    Text(
                                      '${request.awardedPoints}',
                                      style: Theme.of(context)
                                          .textTheme
                                          .labelSmall,
                                    ),
                                    const SizedBox(height: 8),
                                  ],
                                ),
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
