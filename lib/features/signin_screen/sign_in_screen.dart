import 'package:event_hub/utill/auth_button.dart';
import 'package:event_hub/utill/auth_text_field.dart';
import 'package:event_hub/utill/social_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/local/AppDatabase.dart';
import '../../data/local/SessionManager.dart';
import '../../data/local/auth_local_data_source.dart';
import '../services/navigation/AppRoutes.dart';
import 'cubit/sign_in_cubit.dart';


class SignInScreen extends StatelessWidget {
  SignInScreen({super.key});

  final formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  String? validateRequired(String? value, String fieldName) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName is required';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<SignInCubit>();

    return BlocConsumer<SignInCubit, SignInState>(
      listener: (context, state) {
        if (state is SignInRememberedDataLoaded) {
          emailController.text = state.email;
          passwordController.text = state.password;
        } else if (state is SignInSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
          Navigator.pushReplacementNamed(context, AppRoutes.home);
        } else if (state is SignInError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
        }
      },
      builder: (context, state) {
        bool isLoading = state is SignInLoading;
        bool rememberMe = cubit.rememberMe;
        bool isPasswordHidden = cubit.isPasswordHidden;

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
                      Image.asset(
                        'assets/images/sign_in.png',
                        width: 160,
                        height: 120,
                      ),
                      const SizedBox(height: 40),
                      const Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Sign in',
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      AuthTextField(
                        controller: emailController,
                        hintText: 'abc@email.com',
                        prefixIcon: Icons.email_outlined,
                        validator: (value) => validateRequired(value, 'Email'),
                        onChanged: cubit.onEmailChanged,
                      ),
                      const SizedBox(height: 16),
                      AuthTextField(
                        controller: passwordController,
                        hintText: 'Your password',
                        prefixIcon: Icons.lock_outline,
                        obscureText: isPasswordHidden,
                        suffixIcon: IconButton(
                          onPressed: cubit.togglePasswordVisibility,
                          icon: Icon(
                            isPasswordHidden
                                ? Icons.visibility_off_outlined
                                : Icons.visibility_outlined,
                          ),
                        ),
                        validator: (value) => validateRequired(value, 'Password'),
                        onChanged: cubit.onPasswordChanged,
                      ),
                      const SizedBox(height: 14),
                      Row(
                        children: [
                          Switch(
                            value: rememberMe,
                            activeThumbColor: Colors.blue,
                            onChanged: cubit.toggleRememberMe,
                          ),
                          const Text('Remember Me'),
                          const Spacer(),
                          TextButton(
                            onPressed: () {},
                            child: const Text('Forgot Password?'),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      AuthButton(
                        text: isLoading ? 'LOADING...' : 'SIGN IN',
                        onTap: () {
                          if (formKey.currentState!.validate()) {
                            cubit.signIn();
                          }
                        },
                      ),
                      const SizedBox(height: 12),
                      const Text('OR'),
                      const SizedBox(height: 12),
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
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text("Don’t have an account? "),
                          TextButton(
                            onPressed: () {
                              Navigator.pushNamed(context, AppRoutes.signUp);
                            },
                            child: const Text('Sign up'),
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