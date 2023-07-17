import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Home'),
        ),
        body: const Padding(
          padding: EdgeInsets.all(32.0),
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                children: [],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
