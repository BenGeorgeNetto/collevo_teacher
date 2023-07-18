// ignore_for_file: use_build_context_synchronously

import 'package:collevo_teacher/services/preferences/preferences_service.dart';
import 'package:flutter/material.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final preferencesService = PreferencesService();
  String? name;
  String? batch;
  String? dept;
  String? email;

  @override
  void initState() {
    super.initState();
    fetchUserDetails();
  }

  Future<void> fetchUserDetails() async {
    email = await preferencesService.getEmail();
    name = await preferencesService.getName();
    batch = await preferencesService.getBatch();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Profile"),
        ),
        body: Padding(
          padding: const EdgeInsets.all(32.0),
          child: SingleChildScrollView(
            child: SizedBox(
              width: MediaQuery.of(context).size.width,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const ProfileElement(text: "Name"),
                  ProfileSubElement(text: name!),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.05 / 2,
                  ),
                  const ProfileElement(text: "Email"),
                  ProfileSubElement(text: email!),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.05 / 2,
                  ),
                  const ProfileElement(text: "Batch"),
                  ProfileSubElement(text: batch!),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.05 / 2,
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

class ProfileElement extends StatelessWidget {
  final String text;

  const ProfileElement({
    super.key,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double desiredWidth = screenWidth * 0.5;
    double maxWidth = 500.0;
    double containerWidth = desiredWidth > maxWidth ? maxWidth : desiredWidth;

    return SizedBox(
      width: containerWidth,
      child: Column(
        children: [
          ListTile(
            title: Text(
              text,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ),
        ],
      ),
    );
  }
}

class ProfileSubElement extends StatelessWidget {
  final String text;

  const ProfileSubElement({
    super.key,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double desiredWidth = screenWidth * 0.5;
    double maxWidth = 500.0;
    double containerWidth = desiredWidth > maxWidth ? maxWidth : desiredWidth;

    return SizedBox(
      width: containerWidth,
      child: Column(
        children: [
          ListTile(
            title: Text(
              text,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
        ],
      ),
    );
  }
}
