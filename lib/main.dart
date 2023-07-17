import 'package:collevo_teacher/bloc/route_bloc.dart';
import 'package:collevo_teacher/router/app_route_information_parser.dart';
import 'package:collevo_teacher/router/app_router_delegate.dart';
import 'package:collevo_teacher/router/routes.dart';
import 'package:collevo_teacher/services/auth/bloc/auth_bloc.dart';
import 'package:collevo_teacher/services/auth/firebase_auth_provider.dart';
import 'package:collevo_teacher/theme.dart';
import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  final router = FluroRouter();
  defineRoutes(router);
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp(
    router: router,
  ));
}

class MyApp extends StatelessWidget {
  final FluroRouter router;

  const MyApp({
    Key? key,
    required this.router,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<RouteBloc>(
          create: (context) => RouteBloc(),
        ),
        BlocProvider<AuthBloc>(
          create: (context) => AuthBloc(FirebaseAuthProvider()),
        ),
      ],
      child: MultiBlocListener(
        listeners: [
          BlocListener<RouteBloc, String>(
            listener: (context, state) {
              router.navigateTo(context, state, replace: true);
            },
          ),
        ],
        child: MaterialApp.router(
          routerDelegate: AppRouterDelegate(router),
          routeInformationParser: AppRouteInformationParser(router),
          title: 'Collevo',
          theme: CustomTheme.getThemeData(),
          debugShowCheckedModeBanner: false,
        ),
      ),
    );
  }
}
