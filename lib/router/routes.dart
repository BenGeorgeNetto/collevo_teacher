import 'package:collevo_teacher/presentation/main/home_screen.dart';
import 'package:fluro/fluro.dart';

void defineRoutes(FluroRouter router) {
  router.define(
    '/',
    handler: Handler(
      handlerFunc: (context, params) {
        return const HomeScreen();
      },
    ),
  );
}

List<String> validRoutes = [
  '/',
  '/signin',
  '/signup',
  '/profile',
];
