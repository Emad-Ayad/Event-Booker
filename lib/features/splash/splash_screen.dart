import 'dart:async';

import 'package:flutter/material.dart';

import '../../data/local/SessionManager.dart';
import '../services/navigation/AppRoutes.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  Future<void> checkLogin() async {
    final isLoggedIn = await SessionManager.isLoggedIn();

    Navigator.pushReplacementNamed(
      context,
      isLoggedIn ? AppRoutes.home : AppRoutes.signIn,
    );
  }

  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 2), () {
      checkLogin();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: Image.asset('assets/images/logo.png',height: 58,width: 242)
      ),
    );
  }
}
