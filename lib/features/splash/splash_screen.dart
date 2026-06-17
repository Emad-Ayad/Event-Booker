import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../services/navigation/AppRoutes.dart';
import 'cubit/splash_cubit.dart';


class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<SplashCubit, SplashState>(
      listener: (context, state) {
        if (state is SplashAuth) {
          Navigator.pushReplacementNamed(context, AppRoutes.home);
        } else if (state is SplashUnauth) {
          Navigator.pushReplacementNamed(context, AppRoutes.signIn);
        }
      },
      child: Scaffold(
        body: Center(
          child: Image.asset(
            'assets/images/logo.png',
            height: 58,
            width: 242,
          ),
        ),
      ),
    );
  }
}
