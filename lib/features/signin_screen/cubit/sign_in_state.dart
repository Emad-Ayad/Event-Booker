part of 'sign_in_cubit.dart';

@immutable
sealed class SignInState {}

final class SignInInitial extends SignInState {}

class SignInLoading extends SignInState {}

class SignInSuccess extends SignInState {
  final String message;

  SignInSuccess(this.message);
}

class SignInError extends SignInState {
  final String message;

  SignInError(this.message);
}

class SignInRememberedDataLoaded extends SignInState {
  final String email;
  final String password;
  final bool rememberMe;

  SignInRememberedDataLoaded({
    required this.email,
    required this.password,
    required this.rememberMe,
  });
}

class SignInPasswordVisibilityChanged extends SignInState {
  final bool isPasswordHidden;
  final bool rememberMe;

  SignInPasswordVisibilityChanged({
    required this.isPasswordHidden,
    required this.rememberMe,
  });
}

class SignInRememberMeChanged extends SignInState {
  final bool rememberMe;
  final bool isPasswordHidden;

  SignInRememberMeChanged({
    required this.rememberMe,
    required this.isPasswordHidden,
  });
}