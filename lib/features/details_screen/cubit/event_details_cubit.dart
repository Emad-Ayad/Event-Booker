import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../../../data/model/EventModel.dart';
import '../../../data/repo/HomeRepo.dart';
import '../../../data/repo/SavedEventsRepository.dart';
import '../../../data/repo/SessionRepository.dart';

part 'event_details_state.dart';


class EventDetailsCubit extends Cubit<EventDetailsState> {
  final HomeRepo homeRepo;
  final SavedEventsRepository savedEventsRepository;
  final SessionRepository sessionRepository;

  EventDetailsCubit({
    required this.homeRepo,
    required this.savedEventsRepository,
    required this.sessionRepository,
  }) : super(EventDetailsInitial());

  Future<void> initialize(EventModel initialEvent) async {
    emit(EventDetailsLoading());

    String? userEmail;
    EventModel event = initialEvent;
    bool isSaved = false;

    try {
      userEmail = await sessionRepository.getLoggedInUserEmail();

      try {
        event = await homeRepo.getEventById(initialEvent.id);
      } catch (_) {
        event = initialEvent;
      }

      if (userEmail != null) {
        isSaved = await savedEventsRepository.isEventSaved(
          userEmail: userEmail,
          eventId: initialEvent.id,
        );
      }

      emit(
        EventDetailsLoaded(
          event: event,
          isSaved: isSaved,
          userEmail: userEmail,
        ),
      );
    } catch (e) {
      emit(
        EventDetailsError(
          message: e.toString(),
          event: event,
          isSaved: isSaved,
          userEmail: userEmail,
        ),
      );
    }
  }

  Future<void> toggleSaveEvent() async {
    final currentState = state;

    EventModel currentEvent;
    bool currentSaved;
    String? currentUserEmail;

    if (currentState is EventDetailsLoaded) {
      currentEvent = currentState.event;
      currentSaved = currentState.isSaved;
      currentUserEmail = currentState.userEmail;

      emit(currentState.copyWith(isSaving: true));
    } else if (currentState is EventDetailsActionSuccess) {
      currentEvent = currentState.event;
      currentSaved = currentState.isSaved;
      currentUserEmail = currentState.userEmail;

      emit(
        EventDetailsLoaded(
          event: currentEvent,
          isSaved: currentSaved,
          userEmail: currentUserEmail,
          isSaving: true,
        ),
      );
    } else if (currentState is EventDetailsActionError) {
      currentEvent = currentState.event;
      currentSaved = currentState.isSaved;
      currentUserEmail = currentState.userEmail;

      emit(
        EventDetailsLoaded(
          event: currentEvent,
          isSaved: currentSaved,
          userEmail: currentUserEmail,
          isSaving: true,
        ),
      );
    } else if (currentState is EventDetailsError) {
      currentEvent = currentState.event;
      currentSaved = currentState.isSaved;
      currentUserEmail = currentState.userEmail;

      emit(
        EventDetailsLoaded(
          event: currentEvent,
          isSaved: currentSaved,
          userEmail: currentUserEmail,
          isSaving: true,
        ),
      );
    } else {
      return;
    }

    if (currentUserEmail == null) {
      emit(
        EventDetailsActionError(
          message: 'No logged in user found',
          event: currentEvent,
          isSaved: currentSaved,
          userEmail: currentUserEmail,
        ),
      );
      return;
    }

    try {
      if (currentSaved) {
        await savedEventsRepository.removeEvent(
          userEmail: currentUserEmail,
          eventId: currentEvent.id,
        );

        emit(
          EventDetailsActionSuccess(
            message: 'Removed from saved events',
            event: currentEvent,
            isSaved: false,
            userEmail: currentUserEmail,
          ),
        );
      } else {
        await savedEventsRepository.saveEvent(
          userEmail: currentUserEmail,
          event: currentEvent,
        );

        emit(
          EventDetailsActionSuccess(
            message: 'Saved to your events',
            event: currentEvent,
            isSaved: true,
            userEmail: currentUserEmail,
          ),
        );
      }
    } catch (e) {
      emit(
        EventDetailsActionError(
          message: 'Error: $e',
          event: currentEvent,
          isSaved: currentSaved,
          userEmail: currentUserEmail,
        ),
      );
    }
  }
}