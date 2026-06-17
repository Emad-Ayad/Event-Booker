
import 'package:event_hub/features/events/event_screen.dart';
import 'package:event_hub/features/profile/profile_screen.dart';
import 'package:event_hub/features/search/search_screen.dart';
import 'package:event_hub/features/splash/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/datasource/HomeRemoteDataSource.dart';
import '../../../data/model/EventModel.dart';
import '../../../data/repo/AuthRepository.dart';
import '../../../data/repo/HomeRepo.dart';
import '../../../data/repo/SavedEventsRepository.dart';
import '../../../data/repo/SessionRepository.dart';
import '../../details_screen/cubit/event_details_cubit.dart';
import '../../details_screen/details_screen.dart';
import '../../empty_event_screen/event_screen.dart';
import '../../events/cubit/event_cubit.dart';
import '../../home_screen/cubit/home_cubit.dart';
import '../../home_screen/home_screen.dart';
import '../../onboarding_screen/onboarding_screen.dart';
import '../../profile/cubit/profile_cubit.dart';
import '../../search/cubit/search_cubit.dart';
import '../../signin_screen/cubit/sign_in_cubit.dart';
import '../../signin_screen/sign_in_screen.dart';
import '../../signup_Srcreen/sign_up_screen.dart';
import 'AppRoutes.dart';
import '../../signup_Srcreen/cubit/sign_up_cubit.dart';
import '../../splash/cubit/splash_cubit.dart';

class AppRouter {
  final AuthRepository authRepository;
  final SessionRepository sessionRepository;
  final SavedEventsRepository savedEventsRepository;

  AppRouter({
    required this.authRepository,
    required this.sessionRepository,
    required this.savedEventsRepository
  });

  Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.splash:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (_) =>
            SplashCubit(sessionRepository)..checkLoginStatus(),
            child: const SplashScreen(),
          ),
        );

      case AppRoutes.onboarding:
        return MaterialPageRoute(
          builder: (_) => const OnboardingScreen(),
        );

      case AppRoutes.signIn:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (_) => SignInCubit(
              authRepository: authRepository,
              sessionRepository: sessionRepository,
            )..loadRememberedData(),
            child: SignInScreen(),
          ),
        );

      case AppRoutes.signUp:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (_) => SignUpCubit(authRepository),
            child: SignUpScreen(),
          ),
        );

      case AppRoutes.home:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (_) => HomeCubit(
              HomeRepo(HomeRemoteDataSource()),
            )..loadHomeData(),
            child: const HomeScreen(),
          ),
        );

      case AppRoutes.search:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (_) => SearchCubit(
              HomeRepo(HomeRemoteDataSource()),
            ),
            child: const SearchScreen(),
          ),
        );

      case AppRoutes.eventsEmpty:
        return MaterialPageRoute(
          builder: (_) => const EventsEmptyScreen(),
        );

      case AppRoutes.events:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (_) => EventsCubit(
              HomeRepo(HomeRemoteDataSource()),
            )..loadEvents(),
            child: const EventsScreen(),
          ),
        );

      case AppRoutes.profile:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (_) => ProfileCubit(
              authRepository: authRepository,
              savedEventsRepository: savedEventsRepository,
              sessionRepository: sessionRepository,
            )..loadProfileData(),
            child: const ProfileScreen(),
          ),
        );

      case AppRoutes.eventDetails:
        final event = settings.arguments as EventModel;
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (_) => EventDetailsCubit(
              homeRepo: HomeRepo(HomeRemoteDataSource()),
              savedEventsRepository: savedEventsRepository,
              sessionRepository: sessionRepository,
            )..initialize(event),
            child: EventDetailsScreen(event: event),
          ),
        );

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