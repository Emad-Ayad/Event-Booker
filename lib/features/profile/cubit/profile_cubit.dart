import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/repo/AuthRepository.dart';
import '../../../data/repo/SavedEventsRepository.dart';
import '../../../data/repo/SessionRepository.dart';
import 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  final AuthRepository authRepository;
  final SavedEventsRepository savedEventsRepository;
  final SessionRepository sessionRepository;

  ProfileCubit({
    required this.authRepository,
    required this.savedEventsRepository,
    required this.sessionRepository,
  }) : super(ProfileInitial());

  Future<void> loadProfileData() async {
    emit(ProfileLoading());

    try {
      final email = await sessionRepository.getLoggedInUserEmail();

      if (email == null) {
        emit(ProfileError('No logged in user found'));
        return;
      }

      final user = await authRepository.getUserByEmail(email);
      final events = await savedEventsRepository.getSavedEvents(
        userEmail: email,
      );

      if (user == null) {
        emit(ProfileError('User not found'));
        return;
      }

      emit(
        ProfileLoaded(
          currentUser: user,
          savedEvents: events,
        ),
      );
    } catch (e) {
      emit(ProfileError(e.toString()));
    }
  }

  Future<bool> logout() async {
    final currentState = state;
    if (currentState is! ProfileLoaded) return false;

    emit(currentState.copyWith(isLoggingOut: true));

    try {
      await sessionRepository.logout();
      emit(ProfileLogoutSuccess());
      return true;
    } catch (e) {
      emit(currentState.copyWith(isLoggingOut: false));
      return false;
    }
  }
}