import 'package:equatable/equatable.dart';

abstract class RegisterEvent extends Equatable {
  const RegisterEvent();
}

class RegisterUserEvent extends RegisterEvent {

  RegisterUserEvent();

  @override
  List<Object> get props => [];
}
