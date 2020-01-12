import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter_start_repo/bloc/authentication/bloc.dart';
import 'package:flutter_start_repo/bloc/login/bloc.dart';
import 'package:flutter_start_repo/repository/UserRepository.dart';
import 'package:meta/meta.dart';
import 'package:bloc/bloc.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final UserRepository userRepository;
  final AuthenticationBloc authenticationBloc;

  LoginBloc({
    @required this.userRepository,
    @required this.authenticationBloc,
  })  : assert(userRepository != null),
        assert(authenticationBloc != null);

  LoginState get initialState => LoginInitial();

  @override
  Stream<LoginState> mapEventToState(LoginEvent event) async* {
    if (event is LoginButtonPressed) {
      yield LoginLoading();

      try {
        final userInfo = await userRepository.authenticateUser(
          event.username,
          event.password,
        );
        print("loginbloc === ${userInfo.toJson()}");
        authenticationBloc.add(LoggedIn(user: userInfo));
      } catch (error) {
        print(error);
        if (error is DioError) {
          yield LoginFailure(error: error.response.data['message']);
          return;
        }
        yield LoginFailure(error: error.toString());
      }
    }
  }
}
