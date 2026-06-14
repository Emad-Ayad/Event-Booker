import 'package:event_hub/features/signin_screen/sign_in_screen.dart';
import 'package:event_hub/features/signup_Srcreen/sign_up_screen.dart';
import 'package:event_hub/features/splash/splash_screen.dart';
import 'package:flutter/material.dart';

import 'features/details_screen/details_screen.dart';
import 'features/event_screen/event_screen.dart';
import 'features/onboarding_screen/onboarding_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home:  EventDetailsScreen(),
    );
  }
}


//animated toggle
