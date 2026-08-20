part of 'auth_bloc.dart';

abstract class AuthState {}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class RegisterSuccess extends AuthState {
  final RegisterResponseModel registerResponseModel;

  RegisterSuccess({required this.registerResponseModel});
}

class Authenticated extends AuthState {
  final String token;
  final String refreshToken;
  final int userId;

  Authenticated({
    required this.refreshToken,
    required this.token,
    required this.userId,
  });
}

class Unauthenticated extends AuthState {}

class AuthFailure extends AuthState {
  final String message;

  AuthFailure({required this.message});
}
