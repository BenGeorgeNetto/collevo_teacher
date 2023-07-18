import 'package:collevo_teacher/bloc/route_bloc.dart';
import 'package:collevo_teacher/services/preferences/preferences_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
  Widget build(BuildContext context) {
    final routeBloc = BlocProvider.of<RouteBloc>(context);
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('collevo'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  ElevatedButton(
                    onPressed: () {
                      routeBloc.add(RouteEvent.about);
                    },
                    child: const Text('About'),
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
