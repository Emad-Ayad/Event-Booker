import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../../../data/model/UserModel.dart';
import '../../../data/repo/AuthRepository.dart';

part 'sign_up_state.dart';


class SignUpCubit extends Cubit<SignUpState> {
  final AuthRepository authRepository;

  SignUpCubit(this.authRepository) : super(SignUpInitial());

  String fullName = '';
  String email = '';
  String password = '';
  String confirmPassword = '';

  bool isPasswordHidden = true;
  bool isConfirmPasswordHidden = true;

  void onFullNameChanged(String value) {
    fullName = value;
  }

  void onEmailChanged(String value) {
    email = value;
  }

  void onPasswordChanged(String value) {
    password = value;
  }

  void onConfirmPasswordChanged(String value) {
    confirmPassword = value;
  }

  void togglePasswordVisibility() {
    isPasswordHidden = !isPasswordHidden;
    emit(
      SignUpPasswordVisibilityChanged(
        isPasswordHidden: isPasswordHidden,
        isConfirmPasswordHidden: isConfirmPasswordHidden,
      ),
    );
  }

  void toggleConfirmPasswordVisibility() {
    isConfirmPasswordHidden = !isConfirmPasswordHidden;
    emit(
      SignUpPasswordVisibilityChanged(
        isPasswordHidden: isPasswordHidden,
        isConfirmPasswordHidden: isConfirmPasswordHidden,
      ),
    );
  }

  Future<void> signUp() async {
    emit(SignUpLoading());

    try {
      final existingUser = await authRepository.getUserByEmail(email.trim());

      if (existingUser != null) {
        emit(SignUpError('This email is already registered'));
        return;
      }

      final user = UserModel(
        fullName: fullName.trim(),
        email: email.trim(),
        password: password.trim(),
      );

      await authRepository.signUp(user);
      emit(SignUpSuccess('Account created successfully'));
    } catch (e) {
      emit(SignUpError('Sign up failed: $e'));
    }
  }
}