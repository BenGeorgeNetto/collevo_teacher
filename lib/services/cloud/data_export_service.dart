// ignore_for_file: avoid_web_libraries_in_flutter

import 'package:collevo_teacher/services/preferences/preferences_service.dart';
import 'package:csv/csv.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:convert';
import 'dart:html' as html;

class DataExportService {
  static Future<void> exportStudentData() async {
    PreferencesService preferencesService = PreferencesService();
    String? batch = await preferencesService.getBatch();
    var studentsSnapshot = await FirebaseFirestore.instance
        .collection('students')
        .doc(batch)
        .collection('student_data')
        .where("batch", isEqualTo: batch)
        .get();

    List<List<dynamic>> rows = _prepareCsvData(studentsSnapshot);

    String csv = const ListToCsvConverter().convert(rows);
    final bytes = utf8.encode(csv);
    final blob = html.Blob([bytes]);
    final url = html.Url.createObjectUrlFromBlob(blob);
    final date = DateTime.now().toString().split(' ')[0];
    html.AnchorElement(href: url)
      ..setAttribute("download", "$batch Points ($date).csv")
      ..click();
    html.Url.revokeObjectUrl(url);
  }

  static List<List<dynamic>> _prepareCsvData(QuerySnapshot snapshot) {
    List<String> headers = [
      'Name',
      'Total Activity Points',
      'Communication Skills',
      'Communicative English',
      'Hardware Skills',
      'IEDC Lab',
      'Technical Skill Development',
      'Simulation Software',
      'SDP',
      'NSS/NCC',
      'Participation',
      'Outstanding Performance',
      'Best NSS Volunteer',
      'Participation in National Integration Camp',
      'Pre Republic Day Parade camp',
      'Participation in Republic Day parade camp',
      'International Youth Exchange Program',
      'Sports and Games',
      'Sports Participation',
      'Sports First Prize',
      'Sports Second Prize',
      'Sports Third Prize',
      'Games Participation',
      'Games First Prize',
      'Games Second Prize',
      'Games Third Prize',
      'Cultural Activities Participation',
      'Music Participation',
      'Music First Prize',
      'Music Second Prize',
      'Music Third Prize',
      'Performing Arts Participation',
      'Performing Arts First Prize',
      'Performing Arts Second Prize',
      'Performing Arts Third Prize',
      'Literary Arts Participation',
      'Literary Arts First Prize',
      'Literary Arts Second Prize',
      'Literary Arts Third Prize',
      'Leadership & Management',
      'Student Professional Bodies',
      'Department Association',
      'Festival/ Tech Event/ Sports',
      'Hobby Clubs',
      'Student Representative (Senate)',
      'Professional Self Initiatives',
      'Tech Fest and Tech Quiz',
      'MOOC with Certification',
      'Foreign Language Skills',
      'Competitions by Professional Societies',
      'Attending Seminar/Workshop other than tech fest',
      'Paper Presentation at IIT/NIT/ Other Reputed Institution',
      'Paper Publication in International/National Journals',
      'Paper Presentation at other places',
      'Poster Presentation at IIT/NIT/ Other Reputed Institution',
      'Poster Presentation at other places',
      'Industrial Training/ Internship',
      'IV / Exhibition Visit',
      'Entrepreneurship and Innovation',
      'Startup',
      'Patent',
      'Prototype developed and tested',
      'Awards for products developed',
      'Innovative Tech developed and used by industries or other stakeholders',
      'Received venture capital for funding innovative ideas/products',
      'Startup Employment',
      'Societal Innovation',
      'Community Outreach',
      'Community Outreach Activities',
    ];
    List<List<dynamic>> rows = [headers];

    for (var doc in snapshot.docs) {
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      Map<String, dynamic> activityPoints =
          data['activity_points'] as Map<String, dynamic>;

      List<dynamic> row = [
        data['s_name'],
        data['total_activity_points'],
        activityPoints['0'] ?? 0,
        activityPoints['0_0'] ?? 0,
        activityPoints['1'] ?? 0,
        activityPoints['1_0'] ?? 0,
        activityPoints['2'] ?? 0,
        activityPoints['2_0'] ?? 0,
        activityPoints['2_1'] ?? 0,
        activityPoints['3'] ?? 0,
        activityPoints['3_0'] ?? 0,
        activityPoints['3_1'] ?? 0,
        activityPoints['3_2'] ?? 0,
        activityPoints['3_3'] ?? 0,
        activityPoints['3_4'] ?? 0,
        activityPoints['3_5'] ?? 0,
        activityPoints['3_6'] ?? 0,
        activityPoints['4'] ?? 0,
        activityPoints['4_0'] ?? 0,
        activityPoints['4_1'] ?? 0,
        activityPoints['4_2'] ?? 0,
        activityPoints['4_3'] ?? 0,
        activityPoints['4_4'] ?? 0,
        activityPoints['4_5'] ?? 0,
        activityPoints['4_6'] ?? 0,
        activityPoints['4_7'] ?? 0,
        activityPoints['5'] ?? 0,
        activityPoints['5_0'] ?? 0,
        activityPoints['5_1'] ?? 0,
        activityPoints['5_2'] ?? 0,
        activityPoints['5_3'] ?? 0,
        activityPoints['5_4'] ?? 0,
        activityPoints['5_5'] ?? 0,
        activityPoints['5_6'] ?? 0,
        activityPoints['5_7'] ?? 0,
        activityPoints['5_8'] ?? 0,
        activityPoints['5_9'] ?? 0,
        activityPoints['5_10'] ?? 0,
        activityPoints['5_11'] ?? 0,
        activityPoints['6'] ?? 0,
        activityPoints['6_0'] ?? 0,
        activityPoints['6_1'] ?? 0,
        activityPoints['6_2'] ?? 0,
        activityPoints['6_3'] ?? 0,
        activityPoints['6_4'] ?? 0,
        activityPoints['7'] ?? 0,
        activityPoints['7_0'] ?? 0,
        activityPoints['7_1'] ?? 0,
        activityPoints['7_2'] ?? 0,
        activityPoints['7_3'] ?? 0,
        activityPoints['7_4'] ?? 0,
        activityPoints['7_5'] ?? 0,
        activityPoints['7_6'] ?? 0,
        activityPoints['7_7'] ?? 0,
        activityPoints['7_8'] ?? 0,
        activityPoints['7_9'] ?? 0,
        activityPoints['7_10'] ?? 0,
        activityPoints['7_11'] ?? 0,
        activityPoints['8'] ?? 0,
        activityPoints['8_0'] ?? 0,
        activityPoints['8_1'] ?? 0,
        activityPoints['8_2'] ?? 0,
        activityPoints['8_3'] ?? 0,
        activityPoints['8_4'] ?? 0,
        activityPoints['8_5'] ?? 0,
        activityPoints['8_6'] ?? 0,
        activityPoints['8_7'] ?? 0,
        activityPoints['9'] ?? 0,
        activityPoints['9_0'] ?? 0,
      ];
      rows.add(row);
    }

    return rows;
  }
}
