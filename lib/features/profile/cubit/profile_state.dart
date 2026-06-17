import '../../../data/model/EventModel.dart';
import '../../../data/model/UserModel.dart';

abstract class ProfileState {}

class ProfileInitial extends ProfileState {}

class ProfileLoading extends ProfileState {}

class ProfileLoaded extends ProfileState {
  final UserModel currentUser;
  final List<EventModel> savedEvents;
  final bool isLoggingOut;

  ProfileLoaded({
    required this.currentUser,
    required this.savedEvents,
    this.isLoggingOut = false,
  });

  ProfileLoaded copyWith({
    UserModel? currentUser,
    List<EventModel>? savedEvents,
    bool? isLoggingOut,
  }) {
    return ProfileLoaded(
      currentUser: currentUser ?? this.currentUser,
      savedEvents: savedEvents ?? this.savedEvents,
      isLoggingOut: isLoggingOut ?? this.isLoggingOut,
    );
  }
}

class ProfileError extends ProfileState {
  final String message;

  ProfileError(this.message);
}

class ProfileLogoutSuccess extends ProfileState {}