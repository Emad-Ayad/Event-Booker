import 'package:event_hub/features/signin_screen/sign_in_screen.dart';
import 'package:event_hub/features/signup_Srcreen/sign_up_screen.dart';
import 'package:event_hub/features/splash/splash_screen.dart';
import 'package:flutter/material.dart';

import 'data/local/AppDatabase.dart';
import 'data/local/SavedEventsLocalDataSource.dart';
import 'data/local/auth_local_data_source.dart';
import 'data/repo/AuthRepository.dart';
import 'data/repo/SavedEventsRepository.dart';
import 'data/repo/SessionRepository.dart';
import 'features/details_screen/details_screen.dart';
import 'features/onboarding_screen/onboarding_screen.dart';
import 'features/services/navigation/AppRouter.dart';
import 'features/services/navigation/AppRoutes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final db = await AppDatabase.instance.database;
  final authLocalDataSource = AuthLocalDataSource(db);
  final savedEventsLocalDataSource = SavedEventsLocalDataSource(db);
  final authRepository = AuthRepository(authLocalDataSource);
  final sessionRepository = SessionRepository();
  final savedEventsRepository = SavedEventsRepository(savedEventsLocalDataSource);

  runApp(
    MyApp(
      authRepository: authRepository,
      sessionRepository: sessionRepository,
      savedEventsRepository: savedEventsRepository,
    ),
  );
}

class MyApp extends StatelessWidget {
  final AuthRepository authRepository;
  final SessionRepository sessionRepository;
  final SavedEventsRepository savedEventsRepository;


  const MyApp({
    super.key,
    required this.authRepository,
    required this.sessionRepository,
    required this.savedEventsRepository,
  });

  @override
  Widget build(BuildContext context) {
    final appRouter = AppRouter(
      authRepository: authRepository,
      sessionRepository: sessionRepository,
      savedEventsRepository: savedEventsRepository
    );

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: AppRoutes.splash,
      onGenerateRoute: appRouter.generateRoute,
    );
  }
}


//animated toggle
