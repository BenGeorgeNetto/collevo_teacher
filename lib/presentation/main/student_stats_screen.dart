import 'package:collevo_teacher/data/activities_lists.dart';
import 'package:collevo_teacher/services/cloud/activity_points_service.dart';
import 'package:flutter/material.dart';

class StudentStatsScreen extends StatefulWidget {
  final String email;

  const StudentStatsScreen({
    Key? key,
    required this.email,
  }) : super(key: key);

  @override
  State<StudentStatsScreen> createState() => _StudentStatsScreenState();
}

class _StudentStatsScreenState extends State<StudentStatsScreen> {
  Map<String, int> activityPointsData = {};
  Map<String, dynamic> activityTypesData = {};
  int totalActivityPoints = 0;
  String name = '';

  @override
  void initState() {
    super.initState();
    fetchStats();
  }

  Future<void> fetchStats() async {
    final activityPointsService = ActivityPointsService(widget.email);
    activityPointsService.getActivityPoints().then((value) {
      activityPointsData = value;
      setState(() {});
    });
    totalActivityPoints =
        await activityPointsService.getTotalActivityPoints() ?? 0;
    name = await activityPointsService.getStudentName();
    activityTypesData = dropdownItems2;
    setState(() {});
  }
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double desiredWidth = screenWidth * 0.75;
    double maxWidth = 750.0;
    double containerWidth = desiredWidth > maxWidth ? maxWidth : desiredWidth;

    return Scaffold(
      appBar: AppBar(
        title: Text('STATS: $name'),
      ),
      body: Align(
        alignment: Alignment.center,
        child: SizedBox(
          width: containerWidth,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  'Total Activity Points: $totalActivityPoints',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: activityTypesData.length,
                  itemBuilder: (context, index) {
                    String activityType = activityTypesData.keys.elementAt(index);
                    List<String> activities = activityTypesData[activityType]!;

                    int totalPoints = 0;
                    for (var activity in activities) {
                      String activityKey =
                          '${index}_${activities.indexOf(activity)}';
                      int points = activityPointsData[activityKey] ?? 0;
                      totalPoints += points;
                    }

                    if (totalPoints == 0) {
                      return const SizedBox.shrink();
                    }

                    return ExpansionTile(
                      title: Text(activityType),
                      subtitle: Text(
                        'Total Points: $totalPoints',
                      ),
                      children: activities.map((activity) {
                        String activityKey =
                            '${index}_${activities.indexOf(activity)}';
                        int points = activityPointsData[activityKey] ?? 0;

                        if (points == 0) {
                          return const SizedBox.shrink();
                        }
                        return ListTile(
                          title: Text(activity),
                          subtitle: Text('Points: $points'),
                        );
                      }).toList(),
                    );
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