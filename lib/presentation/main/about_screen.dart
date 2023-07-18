// ignore_for_file: use_build_context_synchronously

import 'package:collevo_teacher/utilities/communication/mail_util.dart';
import 'package:flutter/material.dart';

class About extends StatefulWidget {
  const About({super.key});

  @override
  State<About> createState() => _AboutState();
}

class _AboutState extends State<About> {
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double desiredWidth = screenWidth * 0.5;
    double maxWidth = 500.0;
    double containerWidth = desiredWidth > maxWidth ? maxWidth : desiredWidth;
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
                  const AboutElement(text: "App Name"),
                  const AboutSubElement(text: "Collevo"),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.05 / 2,
                  ),
                  const AboutElement(text: "Version"),
                  const AboutSubElement(text: "1.0.0-alpha"),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.05 / 2,
                  ),
                  const AboutElement(text: "Contact Developer"),
                  SizedBox(
                    width: containerWidth,
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12.0),
                          child: OutlinedButton(
                            onPressed: () {
                              EmailUtils.sendEmail(
                                  emailAddress:
                                      'bengeorgenetto.work@gmail.com');
                            },
                            child: const Row(
                              children: [
                                Icon(Icons.email),
                                SizedBox(
                                  width: 16.0,
                                ),
                                Text("Contact via Email"),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
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

class AboutElement extends StatelessWidget {
  final String text;

  const AboutElement({
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

class AboutSubElement extends StatelessWidget {
  final String text;

  const AboutSubElement({
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
