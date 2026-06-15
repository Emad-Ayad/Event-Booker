

import '../../core/network/DioHelper.dart';
import '../model/EventModel.dart';

class HomeRemoteDataSource {
  Future<List<EventModel>> getEvents({
    int size = 20,
    int page = 0,
    String? keyword,
    String? category,
  }) async {
    final response = await DioHelper.dio.get(
      '/events.json',
      queryParameters: {
        'size': size,
        'page': page,
        if (keyword != null && keyword.isNotEmpty) 'keyword': keyword,
        if (category != null && category.isNotEmpty) 'segmentName': category,
      },
    );

    final eventsJson = (response.data['_embedded']?['events'] as List?) ?? [];

    return eventsJson
        .map((e) => EventModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}