import 'package:flutter_bloc/flutter_bloc.dart';

part 'route_event.dart';

class RouteBloc extends Bloc<RouteEvent, String> {
  RouteBloc() : super('/') {
    on<RouteEvent>((event, emit) {
      switch (event) {
        case RouteEvent.home:
          emit('/home');
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
        case RouteEvent.pendingRequests:
          emit('/pending_requests');
          break;
        case RouteEvent.acceptedRequests:
          emit('/accepted_requests');
          break;
        case RouteEvent.rejectedRequests:
          emit('/rejected_requests');
          break;
        case RouteEvent.forgotPassword:
          emit('/forgot_password');
          break;
        default:
          emit('/');
      }
    });
  }
}
