import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter_start_repo/bloc/authentication/bloc.dart';
import 'package:flutter_start_repo/bloc/login/bloc.dart';
import 'package:flutter_start_repo/repository/UserRepository.dart';
import 'package:flutter_start_repo/utils/error_helper.dart';
import 'package:meta/meta.dart';

import 'bloc.dart';

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
        yield LoginFailure(error: ErrorHelper.getErrorMessage(error));
      }
    }
  }
}
