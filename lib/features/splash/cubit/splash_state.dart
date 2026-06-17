part of 'splash_cubit.dart';

@immutable
sealed class SplashState {}

final class SplashInitial extends SplashState {}

class SplashAuth extends SplashState {}

class SplashUnauth extends SplashState {}