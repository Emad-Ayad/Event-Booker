part of 'event_details_cubit.dart';

@immutable
sealed class EventDetailsState {}

final class EventDetailsInitial extends EventDetailsState {}


class EventDetailsLoading extends EventDetailsState {}

class EventDetailsLoaded extends EventDetailsState {
  final EventModel event;
  final bool isSaved;
  final String? userEmail;
  final bool isSaving;

  EventDetailsLoaded({
    required this.event,
    required this.isSaved,
    required this.userEmail,
    this.isSaving = false,
  });

  EventDetailsLoaded copyWith({
    EventModel? event,
    bool? isSaved,
    String? userEmail,
    bool? isSaving,
  }) {
    return EventDetailsLoaded(
      event: event ?? this.event,
      isSaved: isSaved ?? this.isSaved,
      userEmail: userEmail ?? this.userEmail,
      isSaving: isSaving ?? this.isSaving,
    );
  }
}

class EventDetailsError extends EventDetailsState {
  final String message;
  final EventModel event;
  final bool isSaved;
  final String? userEmail;

  EventDetailsError({
    required this.message,
    required this.event,
    required this.isSaved,
    required this.userEmail,
  });
}

class EventDetailsActionSuccess extends EventDetailsState {
  final String message;
  final EventModel event;
  final bool isSaved;
  final String? userEmail;

  EventDetailsActionSuccess({
    required this.message,
    required this.event,
    required this.isSaved,
    required this.userEmail,
  });
}

class EventDetailsActionError extends EventDetailsState {
  final String message;
  final EventModel event;
  final bool isSaved;
  final String? userEmail;

  EventDetailsActionError({
    required this.message,
    required this.event,
    required this.isSaved,
    required this.userEmail,
  });
}
