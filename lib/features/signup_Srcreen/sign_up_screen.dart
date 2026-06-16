import 'package:event_hub/features/services/navigation/AppRoutes.dart';
import 'package:event_hub/utill/auth_button.dart';
import 'package:event_hub/utill/auth_text_field.dart';
import 'package:event_hub/utill/social_button.dart';
import 'package:flutter/material.dart';

import '../../data/local/AppDatabase.dart';
import '../../data/local/auth_local_data_source.dart';
import '../../data/model/UserModel.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final formKey = GlobalKey<FormState>();

  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  bool isPasswordHidden = true;
  bool isConfirmPasswordHidden = true;
  bool isLoading = false;

  String? validateRequired(String? value, String fieldName) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName is required';
    }
    return null;
  }

  String? validateConfirmPassword(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Confirm password is required';
    }
    if (value != passwordController.text) {
      return 'Passwords do not match';
    }
    return null;
  }

  Future<void> signUp() async {
    if (!formKey.currentState!.validate()) return;

    setState(() => isLoading = true);

    try {
      final db = await AppDatabase.instance.database;
      final authLocal = AuthLocalDataSource(db);

      final existingUser = await authLocal.getUserByEmail(
        emailController.text.trim(),
      );

      if (existingUser != null) {
        _showMessage('This email is already registered');
        return;
      }

      final user = UserModel(
        fullName: fullNameController.text.trim(),
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );
      await authLocal.signUp(user);
      _showMessage('Account created successfully');
      Navigator.pushReplacementNamed(context, AppRoutes.signIn);
    } catch (e) {
      _showMessage('Sign up failed: $e');
    }
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
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
                    controller: fullNameController,
                    hintText: 'Full name',
                    prefixIcon: Icons.person_outline,
                    validator: (value) => validateRequired(value, 'Full name'),
                  ),
                  const SizedBox(height: 16),
                  AuthTextField(
                    controller: emailController,
                    hintText: 'abc@email.com',
                    prefixIcon: Icons.email_outlined,
                    validator: (value) => validateRequired(value, 'Email'),
                  ),
                  const SizedBox(height: 16),
                  AuthTextField(
                    controller: passwordController,
                    hintText: 'Your password',
                    prefixIcon: Icons.lock_outline,
                    obscureText: isPasswordHidden,
                    validator: (value) => validateRequired(value, 'Password'),
                    suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          isPasswordHidden = !isPasswordHidden;
                        });
                      },
                      icon: Icon(
                        isPasswordHidden
                            ? Icons.visibility_off_outlined
                            : Icons.visibility_outlined,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  AuthTextField(
                    controller: confirmPasswordController,
                    hintText: 'Confirm password',
                    prefixIcon: Icons.lock_outline,
                    obscureText: isConfirmPasswordHidden,
                    validator: validateConfirmPassword,
                    suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          isConfirmPasswordHidden = !isConfirmPasswordHidden;
                        });
                      },
                      icon: Icon(
                        isConfirmPasswordHidden
                            ? Icons.visibility_off_outlined
                            : Icons.visibility_outlined,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  AuthButton(text: 'SIGN UP', onTap: signUp),
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
  }
}
