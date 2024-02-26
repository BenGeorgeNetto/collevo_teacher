import 'package:collevo_teacher/landing.dart';
import 'package:collevo_teacher/presentation/main/about_screen.dart';
import 'package:collevo_teacher/presentation/main/students_dashboard.dart';
import 'package:collevo_teacher/presentation/requests/accepted_requests_screen.dart';
import 'package:collevo_teacher/presentation/main/error_screen.dart';
import 'package:collevo_teacher/presentation/main/home_screen.dart';
import 'package:collevo_teacher/presentation/requests/pending_requests_screen.dart';
import 'package:collevo_teacher/presentation/main/profile_screen.dart';
import 'package:collevo_teacher/presentation/requests/previous_requests_screen.dart';
import 'package:collevo_teacher/presentation/requests/rejected_requests_screen.dart';
import 'package:collevo_teacher/presentation/main/settings_screen.dart';
import 'package:flutter/material.dart';
import 'package:fluro/fluro.dart';

class Routes {
  static final router = FluroRouter();

  static var landingHandler = Handler(
    handlerFunc: (BuildContext? context, Map<String, dynamic> params) {
      return const Landing();
    },
  );

  static final Handler _homeHandler = Handler(
    handlerFunc: (BuildContext? context, Map<String, dynamic> params) {
      return const HomeScreen();
    },
  );

  static final Handler _aboutHandler = Handler(
    handlerFunc: (BuildContext? context, Map<String, dynamic> params) {
      return const About();
    },
  );

  static final Handler _pendingRequestsHandler = Handler(
    handlerFunc: (BuildContext? context, Map<String, dynamic> params) {
      return const PendingRequests();
    },
  );

  static final Handler _acceptedRequestsHandler = Handler(
    handlerFunc: (BuildContext? context, Map<String, dynamic> params) {
      return const AcceptedRequests();
    },
  );

  static final Handler _rejectedRequestsHandler = Handler(
    handlerFunc: (BuildContext? context, Map<String, dynamic> params) {
      return const RejectedRequests();
    },
  );

  static final Handler _previousRequestsHandler = Handler(
      handlerFunc: (BuildContext? context, Map<String, dynamic> params) {
    String requestId = params["request_id"]?.first;
    return PreviousRequests(requestId: requestId);
  });

  static final Handler _profile = Handler(
    handlerFunc: (BuildContext? context, Map<String, dynamic> params) {
      return const Profile();
    },
  );

  static final Handler _settings = Handler(
    handlerFunc: (BuildContext? context, Map<String, dynamic> params) {
      return const Settings();
    },
  );

  static final Handler _studentsDashboard = Handler(
    handlerFunc: (BuildContext? context, Map<String, dynamic> params) {
      return const StudentsDashboard();
    },
  );

  static final Handler _errorHandler = Handler(
    handlerFunc: (BuildContext? context, Map<String, dynamic> params) {
      return const ErrorScreen();
    },
  );

  static void defineRoutes() {
    router.define(
      '/',
      handler: landingHandler,
      transitionType: TransitionType.fadeIn,
    );
    router.define(
      '/home',
      handler: _homeHandler,
      transitionType: TransitionType.fadeIn,
    );
    router.define(
      '/about',
      handler: _aboutHandler,
      transitionType: TransitionType.fadeIn,
    );
    router.define(
      '/pending_requests',
      handler: _pendingRequestsHandler,
      transitionType: TransitionType.fadeIn,
    );
    router.define(
      '/accepted_requests',
      handler: _acceptedRequestsHandler,
      transitionType: TransitionType.fadeIn,
    );
    router.define(
      '/rejected_requests',
      handler: _rejectedRequestsHandler,
      transitionType: TransitionType.fadeIn,
    );
    router.define(
      "/previous_requests/:request_id",
      handler: _previousRequestsHandler,
      transitionType: TransitionType.fadeIn,
    );
    router.define(
      '/profile',
      handler: _profile,
      transitionType: TransitionType.fadeIn,
    );
    router.define(
      '/students_dashboard',
      handler: _studentsDashboard,
      transitionType: TransitionType.fadeIn,
    );
    router.define(
      '/settings',
      handler: _settings,
      transitionType: TransitionType.fadeIn,
    );
    router.define(
      '/error',
      handler: _errorHandler,
      transitionType: TransitionType.fadeIn,
    );

    router.notFoundHandler = _errorHandler;
  }
}
