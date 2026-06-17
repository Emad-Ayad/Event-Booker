import '../local/SavedEventsLocalDataSource.dart';
import '../model/EventModel.dart';

class SavedEventsRepository {
  final SavedEventsLocalDataSource localDataSource;

  SavedEventsRepository(this.localDataSource);

  Future<void> saveEvent({
    required String userEmail,
    required EventModel event,
  }) {
    return localDataSource.saveEvent(
      userEmail: userEmail,
      event: event,
    );
  }

  Future<void> removeEvent({
    required String userEmail,
    required String eventId,
  }) {
    return localDataSource.removeEvent(
      userEmail: userEmail,
      eventId: eventId,
    );
  }

  Future<bool> isEventSaved({
    required String userEmail,
    required String eventId,
  }) {
    return localDataSource.isEventSaved(
      userEmail: userEmail,
      eventId: eventId,
    );
  }

  Future<List<EventModel>> getSavedEvents({
    required String userEmail,
  }) {
    return localDataSource.getSavedEvents(userEmail: userEmail);
  }
}