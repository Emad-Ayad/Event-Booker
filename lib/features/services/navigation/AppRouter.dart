
import 'package:event_hub/features/events/event_screen.dart';
import 'package:event_hub/features/profile/profile_screen.dart';
import 'package:event_hub/features/search/search_screen.dart';
import 'package:event_hub/features/splash/splash_screen.dart';
import 'package:flutter/material.dart';

import '../../details_screen/details_screen.dart';
import '../../empty_event_screen/event_screen.dart';
import '../../home_screen/home_screen.dart';
import '../../onboarding_screen/onboarding_screen.dart';
import '../../signin_screen/sign_in_screen.dart';
import '../../signup_Srcreen/sign_up_screen.dart';
import 'AppRoutes.dart';

class AppRouter {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.splash:
        return MaterialPageRoute(builder: (_) => const SplashScreen());

      case AppRoutes.onboarding:
        return MaterialPageRoute(builder: (_) => const OnboardingScreen());

      case AppRoutes.signIn:
        return MaterialPageRoute(builder: (_) => const SignInScreen());

      case AppRoutes.signUp:
        return MaterialPageRoute(builder: (_) => const SignUpScreen());

      case AppRoutes.home:
        return MaterialPageRoute(builder: (_) => const HomeScreen());

      case AppRoutes.search:
        return MaterialPageRoute(builder: (_) => const SearchScreen());

      case AppRoutes.eventsEmpty:
        return MaterialPageRoute(builder: (_) => const EventsEmptyScreen());

      case AppRoutes.events:
        return MaterialPageRoute(builder: (_) => const EventsScreen());

      case AppRoutes.profile:
        return MaterialPageRoute(builder: (_) => const ProfileScreen());

      case AppRoutes.eventDetails:
        return MaterialPageRoute(builder: (_) => const EventDetailsScreen());



      default:
        return MaterialPageRoute(
          builder: (_) => const Scaffold(
            body: Center(
              child: Text('No route found'),
            ),
          ),
        );
    }
  }
}