import 'package:collevo_teacher/services/preferences/preferences_service.dart';
import 'package:collevo_teacher/widgets/home_card.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final preferencesService = PreferencesService();

  String? name;
  String? email;

  @override
  void initState() {
    super.initState();
    fetchUserDetails();
  }

  Future<void> fetchUserDetails() async {
    name = await preferencesService.getName();
    email = await preferencesService.getEmail();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(title: const Text('collevo'), actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: IconButton(
              icon: const Icon(Icons.settings),
              onPressed: () {
                Navigator.pushNamed(context, '/settings');
              },
            ),
          ),
        ]),
        body: Padding(
          padding: const EdgeInsets.all(32.0),
          child: SingleChildScrollView(
            child: SizedBox(
              width: MediaQuery.of(context).size.width,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Welcome, $name",
                    style: const TextStyle(fontSize: 32.0),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.05,
                  ),
                  const HomeCard(
                    cardText: "Students Dashboard",
                    routeName: '/students_dashboard',
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.05 / 4,
                  ),
                  const HomeCard(
                    cardText: "Export Student Data",
                    routeName: '/export_student_data',
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.05 / 2,
                  ),
                  const HomeCard(
                    cardText: "Pending Requests",
                    routeName: '/pending_requests',
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.05 / 4,
                  ),
                  const HomeCard(
                    cardText: "Accepted Requests",
                    routeName: '/accepted_requests',
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.05 / 4,
                  ),
                  const HomeCard(
                    cardText: "Rejected Requests",
                    routeName: '/rejected_requests',
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.05 / 4,
                  ),
                  const HomeCard(
                    cardText: "Modify Accepted Requests",
                    routeName: '/modify_accepted_request',
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.05 / 2,
                  ),
                  const HomeCard(
                    cardText: "My Profile",
                    routeName: '/profile',
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.05 / 4,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
