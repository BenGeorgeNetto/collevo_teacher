// ignore_for_file: use_build_context_synchronously

import 'package:collevo_teacher/colors.dart';
import 'package:collevo_teacher/landing.dart';
import 'package:collevo_teacher/services/auth/bloc/auth_bloc.dart';
import 'package:collevo_teacher/utilities/dialogs/logout_dialog.dart';
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

class SettingsElement extends StatelessWidget {
  final String element;
  final void Function() onTap;

  const SettingsElement({
    super.key,
    required this.element,
    required this.onTap,
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
            title: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                element,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
            onTap: onTap,
          ),
          const Divider(
            color: CustomColors.blueGray,
            thickness: 1.0,
            indent: 16.0,
            endIndent: 16.0,
          )
        ],
      ),
    );
  }
}
