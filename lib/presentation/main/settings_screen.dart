// ignore_for_file: use_build_context_synchronously

import 'package:collevo_teacher/landing.dart';
import 'package:collevo_teacher/services/auth/bloc/auth_bloc.dart';
import 'package:collevo_teacher/utilities/dialogs/logout_dialog.dart';
import 'package:collevo_teacher/widgets/settings/settings_element.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Settings"),
        ),
        body: Padding(
          padding: const EdgeInsets.all(32.0),
          child: SingleChildScrollView(
            child: SizedBox(
              width: MediaQuery.of(context).size.width,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SettingsElement(
                    element: "Profile",
                    onTap: () {
                      Navigator.pushNamed(context, '/profile');
                    },
                  ),
                  SettingsElement(
                    element: "About",
                    onTap: () {
                      Navigator.pushNamed(context, '/about');
                    },
                  ),
                  SettingsElement(
                    element: "Sign Out",
                    onTap: () async {
                      final shouldLogout = await showLogOutDialog(context);
                      if (shouldLogout) {
                        context.read<AuthBloc>().add(
                              const AuthEventLogOut(),
                            );
                        Future.delayed(const Duration(milliseconds: 1000));
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const Landing(),
                          ),
                        );
                      }
                    },
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