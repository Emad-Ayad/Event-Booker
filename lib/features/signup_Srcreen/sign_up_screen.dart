import 'package:event_hub/features/services/navigation/AppRoutes.dart';
import 'package:event_hub/utill/auth_button.dart';
import 'package:event_hub/utill/auth_text_field.dart';
import 'package:event_hub/utill/social_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'cubit/sign_up_cubit.dart';


class SignUpScreen extends StatelessWidget {
  SignUpScreen({super.key});

  final formKey = GlobalKey<FormState>();

  String? validateRequired(String? value, String fieldName) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName is required';
    }
    return null;
  }

  String? validateConfirmPassword(String? value, SignUpCubit cubit) {
    if (value == null || value.trim().isEmpty) {
      return 'Confirm password is required';
    }
    if (value != cubit.password) {
      return 'Passwords do not match';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<SignUpCubit>();

    return BlocConsumer<SignUpCubit, SignUpState>(
      listener: (context, state) {
        if (state is SignUpSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
          Navigator.pushReplacementNamed(context, AppRoutes.signIn);
        } else if (state is SignUpError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
        }
      },
      builder: (context, state) {
        bool isLoading = state is SignUpLoading;
        bool isPasswordHidden = cubit.isPasswordHidden;
        bool isConfirmPasswordHidden = cubit.isConfirmPasswordHidden;

        return Scaffold(
          backgroundColor: Colors.white,
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: SingleChildScrollView(
                child: Form(
                  key: formKey,
                  child: Column(
                    children: [
                      const SizedBox(height: 10),
                      const Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Sign up',
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      AuthTextField(
                        hintText: 'Full name',
                        prefixIcon: Icons.person_outline,
                        validator: (value) => validateRequired(value, 'Full name'),
                        onChanged: cubit.onFullNameChanged,
                      ),
                      const SizedBox(height: 16),
                      AuthTextField(
                        hintText: 'abc@email.com',
                        prefixIcon: Icons.email_outlined,
                        validator: (value) => validateRequired(value, 'Email'),
                        onChanged: cubit.onEmailChanged,
                      ),
                      const SizedBox(height: 16),
                      AuthTextField(
                        hintText: 'Your password',
                        prefixIcon: Icons.lock_outline,
                        obscureText: isPasswordHidden,
                        validator: (value) => validateRequired(value, 'Password'),
                        onChanged: cubit.onPasswordChanged,
                        suffixIcon: IconButton(
                          onPressed: cubit.togglePasswordVisibility,
                          icon: Icon(
                            isPasswordHidden
                                ? Icons.visibility_off_outlined
                                : Icons.visibility_outlined,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      AuthTextField(
                        hintText: 'Confirm password',
                        prefixIcon: Icons.lock_outline,
                        obscureText: isConfirmPasswordHidden,
                        validator: (value) =>
                            validateConfirmPassword(value, cubit),
                        onChanged: cubit.onConfirmPasswordChanged,
                        suffixIcon: IconButton(
                          onPressed: cubit.toggleConfirmPasswordVisibility,
                          icon: Icon(
                            isConfirmPasswordHidden
                                ? Icons.visibility_off_outlined
                                : Icons.visibility_outlined,
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      AuthButton(
                        text: isLoading ? 'LOADING...' : 'SIGN UP',
                        onTap: () {
                          if (formKey.currentState!.validate()) {
                            cubit.signUp();
                          }
                        },
                      ),
                      const SizedBox(height: 16),
                      const Text('OR'),
                      const SizedBox(height: 16),
                      SocialButton(
                        text: 'Login with Google',
                        image: 'assets/images/google.png',
                        onTap: () {},
                      ),
                      const SizedBox(height: 12),
                      SocialButton(
                        text: 'Login with Facebook',
                        image: 'assets/images/facebook.png',
                        onTap: () {},
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text('Already have an account? '),
                          TextButton(
                            onPressed: () {
                              Navigator.pushNamed(context, AppRoutes.signIn);
                            },
                            child: const Text('Sign in'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
