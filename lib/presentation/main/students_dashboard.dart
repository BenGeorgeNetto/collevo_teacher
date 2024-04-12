import 'package:collevo_teacher/models/category.dart';
import 'package:collevo_teacher/models/student_info.dart';
import 'package:collevo_teacher/services/preferences/preferences_service.dart';
import 'package:collevo_teacher/widgets/student_dashboard/category_tile.dart';
import 'package:flutter/material.dart';
import 'package:charts_flutter_new/flutter.dart' as charts;
import 'package:cloud_firestore/cloud_firestore.dart';

class StudentsDashboard extends StatefulWidget {
  const StudentsDashboard({Key? key}) : super(key: key);

  @override
  State<StudentsDashboard> createState() => _StudentsDashboardState();
}

class _StudentsDashboardState extends State<StudentsDashboard> {
  late List<charts.Series<Category, String>> seriesList = [];
  Map<String, List<StudentInfo>> studentsByCategory = {};

  @override
  void initState() {
    super.initState();
    fetchAndCategorizeStudents();
  }

  void fetchAndCategorizeStudents() async {
    PreferencesService preferencesService = PreferencesService();
    String? batch = await preferencesService.getBatch();
    var studentsSnapshot = await FirebaseFirestore.instance
        .collection('students')
        .doc(batch)
        .collection('student_data')
        .get();
    Map<String, List<StudentInfo>> tempStudentsByCategory = {
      '0 - 25': [],
      '26 - 50': [],
      '51 - 75': [],
      '76 - 99': [],
      '100 and above': [],
    };

    List<Category> chartData = [];
    int totalStudents = studentsSnapshot.docs.length;

    for (var doc in studentsSnapshot.docs) {
      final student = doc.data();
      final totalPoints = student['total_activity_points'] ?? 0;
      final name = student['s_name'];
      final email = student['email'];

      String categoryLabel = getCategoryLabel(totalPoints);
      tempStudentsByCategory[categoryLabel]?.add(StudentInfo(name, email));
    }

    tempStudentsByCategory.forEach((key, value) {
      double percentage = (value.length / totalStudents) * 100;
      chartData.add(Category(key, value.length, percentage));
    });

    setState(() {
      studentsByCategory = tempStudentsByCategory;
      seriesList = [
        charts.Series<Category, String>(
          id: 'Activity Points',
          domainFn: (Category category, _) => category.label,
          measureFn: (Category category, _) => category.value,
          colorFn: (Category category, _) {
            switch (category.label) {
              case '0 - 25':
                return const charts.Color(r: 215, g: 53, b: 51, a: 180);
              case '26 - 50':
                return const charts.Color(r: 245, g: 127, b: 48, a: 255);
              case '51 - 75':
                return charts.MaterialPalette.yellow.shadeDefault;
              case '76 - 99':
                return charts.MaterialPalette.lime.shadeDefault;
              case '100 and above':
                return charts.MaterialPalette.green.shadeDefault;
              default:
                return charts.MaterialPalette.gray.shadeDefault;
            }
          },
          data: chartData,
          labelAccessorFn: (Category row, _) =>
              '${row.label}: ${row.value} (${row.percentage.toStringAsFixed(1)}%)',
        ),
      ];
    });
  }

  String getCategoryLabel(int totalPoints) {
    if (totalPoints <= 25) return '0 - 25';
    if (totalPoints <= 50) return '26 - 50';
    if (totalPoints <= 75) return '51 - 75';
    if (totalPoints <= 99) return '76 - 99';
    return '100 and above';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Student Activity Points Dashboard'),
      ),
      body: seriesList.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : SafeArea(
              child: Column(
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.01,
                  ),
                  Expanded(
                    flex: 1,
                    child: SizedBox(
                      // height: MediaQuery.of(context).size.height * 0.2,
                      width: MediaQuery.of(context).size.width,
                      child: charts.PieChart<String>(
                        seriesList,
                        animate: true,
                        defaultRenderer: charts.ArcRendererConfig(
                          arcWidth: 75,
                          startAngle: 0,
                          arcRendererDecorators: [
                            charts.ArcLabelDecorator(
                              labelPosition: charts.ArcLabelPosition.outside,
                              insideLabelStyleSpec: const charts.TextStyleSpec(
                                fontSize: 16,
                                color: charts.MaterialPalette.white,
                              ),
                              outsideLabelStyleSpec: const charts.TextStyleSpec(
                                fontSize: 16,
                                color: charts.MaterialPalette.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: ListView.builder(
                        itemCount: studentsByCategory.keys.length,
                        itemBuilder: (context, index) {
                          String category =
                              studentsByCategory.keys.elementAt(index);
                          List<StudentInfo> students =
                              studentsByCategory[category]!;
                          return CategoryTile(
                            category: category,
                            students: students,
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
