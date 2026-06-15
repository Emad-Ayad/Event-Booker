

import '../../core/network/DioHelper.dart';
import '../model/EventModel.dart';

class HomeRemoteDataSource {
  Future<List<EventModel>> getEvents({
    int size = 20,
    int page = 0,
    String? keyword,
    String? segmentName,
  }) async {
    final response = await DioHelper.dio.get(
      '/events.json',
      queryParameters: {
        'size': size,
        'page': page,
        if (keyword != null && keyword.isNotEmpty) 'keyword': keyword,
        if (segmentName != null && segmentName.isNotEmpty) 'segmentName': segmentName,
      },
    );

    final eventsJson = (response.data['_embedded']?['events'] as List?) ?? [];
    return eventsJson
        .map((e) => EventModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<EventModel> getEventById(String id) async {
    final response = await DioHelper.dio.get('/events/$id.json');
    return EventModel.fromJson(response.data as Map<String, dynamic>);
  }

}