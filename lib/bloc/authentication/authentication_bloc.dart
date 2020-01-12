import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:flutter_start_repo/bloc/authentication/bloc.dart';
import 'package:flutter_start_repo/models/User.dart';
import 'package:flutter_start_repo/repository/UserRepository.dart';
import 'package:flutter_start_repo/repository/dio_helper.dart';
import 'package:meta/meta.dart';

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  final UserRepository userRepository;
  User _userInfo;
  User get userInfo => _userInfo;

  AuthenticationBloc({@required this.userRepository})
      : assert(userRepository != null);
  @override
  AuthenticationState get initialState => AuthenticationUninitialized();

  @override
  Stream<AuthenticationState> mapEventToState(
    AuthenticationEvent event,
  ) async* {
    if (event is AppStarted) {
      final User user = await userRepository.getUserInfo();

      if (user != null) {
        dio.options.headers['Authorization'] = 'Bearer ${user.token}';
        yield AuthenticationAuthenticated();
      } else {
        yield AuthenticationUnauthenticated();
      }
    }

    if (event is LoggedIn) {
      await userRepository.persistUserInfo(event.user);
      dio.options.headers['Authorization'] = 'Bearer ${event.user.token}';
      yield AuthenticationAuthenticated();
    }

    if (event is LoggedOut) {
      yield AuthenticationLoading();
      await userRepository.deleteUserInfo();
      yield AuthenticationUnauthenticated();
    }
  }
}
