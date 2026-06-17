part of 'sign_up_cubit.dart';

@immutable
sealed class SignUpState {}

final class SignUpInitial extends SignUpState {}


class SignUpLoading extends SignUpState {}

class SignUpSuccess extends SignUpState {
  final String message;

  SignUpSuccess(this.message);
}

class SignUpError extends SignUpState {
  final String message;

  SignUpError(this.message);
}

class SignUpPasswordVisibilityChanged extends SignUpState {
  final bool isPasswordHidden;
  final bool isConfirmPasswordHidden;

  SignUpPasswordVisibilityChanged({
    required this.isPasswordHidden,
    required this.isConfirmPasswordHidden,
  });
}