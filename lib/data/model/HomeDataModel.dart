


import 'CategoryModel.dart';
import 'EventModel.dart';

class HomeDataModel {
  final List<CategoryModel> categories;
  final List<EventModel> upcomingEvents;
  final List<EventModel> nearbyEvents;

  HomeDataModel({
    required this.categories,
    required this.upcomingEvents,
    required this.nearbyEvents,
  });
}