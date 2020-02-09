import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:flutter_start_repo/repository/UserRepository.dart';
import 'package:flutter_start_repo/utils/error_helper.dart';
import './bloc.dart';

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  final UserRepository userRepository;

  RegisterBloc(this.userRepository);
  @override
  RegisterState get initialState => InitialRegisterState();

  @override
  Stream<RegisterState> mapEventToState(
    RegisterEvent event,
  ) async* {
    if (event is RegisterUserEvent) {
      yield* _mapRegisterUserEventToState(event);
    }
  }

  Stream<RegisterState> _mapRegisterUserEventToState(
      RegisterUserEvent event) async* {
    yield RegisteringState();
    try {
      await userRepository.registerUser({});
      yield RegisterSuccess();
    } catch (error) {
      yield RegisterError(ErrorHelper.getErrorMessage(error));
    }
  }
}
