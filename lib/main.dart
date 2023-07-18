import 'package:collevo_teacher/presentation/main/error_screen.dart';
import 'package:collevo_teacher/router/routes.dart';
import 'package:collevo_teacher/services/auth/bloc/auth_bloc.dart';
import 'package:collevo_teacher/services/auth/firebase_auth_provider.dart';
import 'package:collevo_teacher/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_strategy/url_strategy.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  setPathUrlStrategy();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    Routes.defineRoutes();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(
          create: (context) => AuthBloc(FirebaseAuthProvider()),
        ),
      ],
      child: MaterialApp(
        title: 'Collevo',
        theme: CustomTheme.getThemeData(),
        debugShowCheckedModeBanner: false,
        initialRoute: '/',
        onGenerateRoute: Routes.router.generator,
        onUnknownRoute: (unknownRoutes) {
          return MaterialPageRoute(
            builder: (context) => const ErrorScreen(),
          );
        },
      ),
    );
  }
}
