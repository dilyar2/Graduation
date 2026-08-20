part of 'auth_bloc.dart';

abstract class AuthEvent {}

class RegisterRequestedEvent extends AuthEvent {
  final RegisterRequestModel request;

  RegisterRequestedEvent({required this.request});
}

class LoginRequestedEvent extends AuthEvent {
  final LoginRequestModel request;

  LoginRequestedEvent({required this.request});
}

class LogoutRequested extends AuthEvent {}
