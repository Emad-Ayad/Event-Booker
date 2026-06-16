import 'package:event_hub/utill/auth_button.dart';
import 'package:event_hub/utill/auth_text_field.dart';
import 'package:event_hub/utill/social_button.dart';
import 'package:flutter/material.dart';

import '../../data/local/AppDatabase.dart';
import '../../data/local/SessionManager.dart';
import '../../data/local/auth_local_data_source.dart';
import '../services/navigation/AppRoutes.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool isPasswordHidden = true;
  bool rememberMe = false;

  @override
  void initState() {
    super.initState();
    loadRememberedData();
  }

  Future<void> loadRememberedData() async {
    final savedRememberMe = await SessionManager.getRememberMe();
    final rememberedData = await SessionManager.getRememberedCredentials();

    if (savedRememberMe) {
      setState(() {
        rememberMe = true;
        emailController.text = rememberedData['email'] ?? '';
        passwordController.text = rememberedData['password'] ?? '';
      });
    }
  }

  String? validateRequired(String? value, String fieldName) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName is required';
    }
    return null;
  }

  Future<void> signIn() async {
    if (!formKey.currentState!.validate()) return;

    try {
      final db = await AppDatabase.instance.database;
      final authLocal = AuthLocalDataSource(db);

      final user = await authLocal.signIn(
        emailController.text.trim(),
        passwordController.text.trim(),
      );

      if (user == null) {
        _showMessage('Invalid email or password');
        return;
      }

      await SessionManager.setLoggedIn(isLoggedIn: true, email: user.email);

      await SessionManager.saveRememberMe(
        rememberMe: rememberMe,
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      _showMessage('Login successful');

      Navigator.pushReplacementNamed(context, AppRoutes.home);
    } catch (e) {
      _showMessage('Sign in failed: $e');
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
                  ),
                  const SizedBox(height: 16),
                  AuthTextField(
                    controller: passwordController,
                    hintText: 'Your password',
                    prefixIcon: Icons.lock_outline,
                    obscureText: isPasswordHidden,
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
                    validator: (value) => validateRequired(value, 'Password'),
                  ),
                  const SizedBox(height: 14),
                  Row(
                    children: [
                      Switch(
                        value: rememberMe,
                        onChanged: (value) {
                          setState(() {
                            rememberMe = value;
                          });
                        },
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
                  AuthButton(text: 'SIGN IN', onTap: signIn),
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
  }
}
