import 'package:collevo_teacher/landing.dart';
import 'package:collevo_teacher/presentation/auth/forgot_password_screen.dart';
import 'package:collevo_teacher/presentation/auth/signin_screen.dart';
import 'package:collevo_teacher/presentation/auth/signup_screen.dart';
import 'package:collevo_teacher/presentation/auth/verify_email_screen.dart';
import 'package:collevo_teacher/presentation/main/home_screen.dart';
import 'package:collevo_teacher/presentation/main/profile_screen.dart';
import 'package:collevo_teacher/router/routes.dart';
import 'package:flutter/material.dart';
import 'package:fluro/fluro.dart';

class AppRouterDelegate extends RouterDelegate<String>
    with ChangeNotifier, PopNavigatorRouterDelegateMixin<String> {
  @override
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  FluroRouter router;

  AppRouterDelegate(this.router);

  String _currentRoute = '/';

  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: navigatorKey,
      pages: [
        if (_currentRoute == '/') const MaterialPage(child: Landing()),
        if (_currentRoute == '/home') const MaterialPage(child: HomeScreen()),
        if (_currentRoute == '/signin') const MaterialPage(child: SignIn()),
        if (_currentRoute == '/signup') const MaterialPage(child: SignUp()),
        if (_currentRoute == '/forgot_password')
          const MaterialPage(child: ForgotPassword()),
        if (_currentRoute == '/verify_email')
          const MaterialPage(child: VerifyEmail()),
        if (_currentRoute == '/profile')
          const MaterialPage(child: ProfileScreen()),
      ],
      onPopPage: (route, result) {
        // Handle pop events
        if (!route.didPop(result)) {
          return false;
        }
        _currentRoute = '/';
        notifyListeners();
        return true;
      },
    );
  }

  @override
  Future<void> setNewRoutePath(String configuration) async {
    if (validRoutes.contains(configuration)) {
      _currentRoute = configuration;
    } else {
      _currentRoute = '/';
    }
    notifyListeners();
  }
}
