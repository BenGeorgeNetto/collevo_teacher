import 'package:flutter_bloc/flutter_bloc.dart';

part 'route_event.dart';

class RouteBloc extends Bloc<RouteEvent, String> {
  RouteBloc() : super('/') {
    on<RouteEvent>((event, emit) {
      switch (event) {
        case RouteEvent.home:
          emit('/');
          break;
        case RouteEvent.signin:
          emit('/signin');
          break;
        case RouteEvent.signup:
          emit('/signup');
          break;
        case RouteEvent.profile:
          emit('/profile');
          break;
        case RouteEvent.settings:
          emit('/settings');
          break;
        case RouteEvent.about:
          emit('/about');
          break;
      }
    });
  }
}
