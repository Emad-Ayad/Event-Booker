part of 'event_cubit.dart';

@immutable
sealed class EventsState {}

final class EventsInitial extends EventsState {}
class EventsLoading extends EventsState {}

class EventsLoaded extends EventsState {
  final List<EventModel> events;

  EventsLoaded(this.events);
}

class EventsError extends EventsState {
  final String message;

  EventsError(this.message);
}