import 'package:sqflite/sqflite.dart';

import '../model/EventModel.dart';


class SavedEventsLocalDataSource {
  final Database db;

  SavedEventsLocalDataSource(this.db);

  Future<void> saveEvent({
    required String userEmail,
    required EventModel event,
  }) async {
    await db.insert(
      'saved_events',
      {
        'user_email': userEmail,
        'event_id': event.id,
        'title': event.name,
        'image_url': event.imageUrl,
        'date': event.localDate,
        'time': event.localTime,
        'venue_name': event.venueName,
        'city_name': event.cityName,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> removeEvent({
    required String userEmail,
    required String eventId,
  }) async {
    await db.delete(
      'saved_events',
      where: 'user_email = ? AND event_id = ?',
      whereArgs: [userEmail, eventId],
    );
  }

  Future<bool> isEventSaved({
    required String userEmail,
    required String eventId,
  }) async {
    final result = await db.query(
      'saved_events',
      where: 'user_email = ? AND event_id = ?',
      whereArgs: [userEmail, eventId],
      limit: 1,
    );
    return result.isNotEmpty;
  }

  Future<List<EventModel>> getSavedEvents({
    required String userEmail,
  }) async {
    final result = await db.query(
      'saved_events',
      where: 'user_email = ?',
      whereArgs: [userEmail],
      orderBy: 'id DESC',
    );

    return result.map((e) => EventModel.fromMap(e)).toList();
  }
}