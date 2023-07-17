import 'package:collevo_teacher/router/routes.dart';
import 'package:flutter/material.dart';
import 'package:fluro/fluro.dart';

class AppRouteInformationParser extends RouteInformationParser<String> {
  FluroRouter router;

  AppRouteInformationParser(this.router);

  @override
  Future<String> parseRouteInformation(
      RouteInformation routeInformation) async {
    String routePath = routeInformation.location ?? '/';
    if (validRoutes.contains(routePath)) {
      return routePath;
    } else {
      return '/';
    }
  }

  @override
  RouteInformation restoreRouteInformation(String configuration) {
    if (validRoutes.contains(configuration)) {
      return RouteInformation(location: configuration);
    } else {
      return const RouteInformation(location: '/');
    }
  }
}
