import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../../../data/repo/AuthRepository.dart';
import '../../../data/repo/SessionRepository.dart';

part 'sign_in_state.dart';

class SignInCubit extends Cubit<SignInState> {
  final AuthRepository authRepository;
  final SessionRepository sessionRepository;

  SignInCubit({required this.authRepository, required this.sessionRepository})
    : super(SignInInitial());

  String email = '';
  String password = '';
  bool rememberMe = false;
  bool isPasswordHidden = true;

  void onEmailChanged(String value) {
    email = value;
  }

  void onPasswordChanged(String value) {
    password = value;
  }

  Future<void> loadRememberedData() async {
    rememberMe = await sessionRepository.getRememberMe();
    final rememberedData = await sessionRepository.getRememberedCredentials();

    email = rememberedData['email'] ?? '';
    password = rememberedData['password'] ?? '';

    emit(
      SignInRememberedDataLoaded(
        email: email,
        password: password,
        rememberMe: rememberMe,
      ),
    );
  }

  void toggleRememberMe(bool value) {
    rememberMe = value;
    emit(
      SignInRememberMeChanged(
        rememberMe: rememberMe,
        isPasswordHidden: isPasswordHidden,
      ),
    );
  }

  void togglePasswordVisibility() {
    isPasswordHidden = !isPasswordHidden;
    emit(
      SignInPasswordVisibilityChanged(
        isPasswordHidden: isPasswordHidden,
        rememberMe: rememberMe,
      ),
    );
  }

  Future<void> signIn() async {
    emit(SignInLoading());

    try {
      final user = await authRepository.signIn(email.trim(), password.trim());

      if (user == null) {
        emit(SignInError('Invalid email or password'));
        return;
      }

      await sessionRepository.setLoggedIn(isLoggedIn: true, email: user.email);

      await sessionRepository.saveRememberMe(
        rememberMe: rememberMe,
        email: email.trim(),
        password: password.trim(),
      );

      emit(SignInSuccess('Login successful'));
    } catch (e) {
      emit(SignInError('Sign in failed: $e'));
    }
  }
}
