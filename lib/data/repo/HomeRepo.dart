import 'package:flutter/material.dart';

import '../datasource/HomeRemoteDataSource.dart';
import '../model/CategoryModel.dart';
import '../model/EventModel.dart';
import '../model/HomeDataModel.dart';

class HomeRepo {
  final HomeRemoteDataSource remoteDataSource;

  HomeRepo(this.remoteDataSource);

  List<CategoryModel> getCategories() {
    return [
      CategoryModel(
          title: 'Sports',
          color: const Color(0xFFFF6B6B),
          icon: Icons.sports_basketball),
      CategoryModel(
          title: 'Music',
          color: const Color(0xFFFFA45B),
          icon: Icons.music_note),
      CategoryModel(
          title: 'Arts & Theatre',
          color: const Color(0xFF5BC0FF),
          icon: Icons.palette),
      CategoryModel(
          title: 'Film',
          color: const Color(0xFF35D39D),
          icon: Icons.movie),
      CategoryModel(
          title: 'Miscellaneous',
          color: const Color(0xFF5669FF),
          icon: Icons.category),
    ];
  }

  Future<List<EventModel>> getUpcomingEvents() async {
    return await remoteDataSource.getEvents(size: 10, page: 0);
  }
  Future<List<EventModel>> getAllEvents() async {
    return await remoteDataSource.getEvents(size: 30, page: 0);
  }

  Future<List<EventModel>> getNearbyEvents() async {
    return await remoteDataSource.getEvents(size: 10, page: 1);
  }

  Future<HomeDataModel> getHomeData() async {
    final upcomingEvents = await getUpcomingEvents();
    final nearbyEvents = await getNearbyEvents();

    return HomeDataModel(
      categories: getCategories(),
      upcomingEvents: upcomingEvents,
      nearbyEvents: nearbyEvents,
    );
  }

  Future<List<EventModel>> getEventsByCategory(String segmentName) async {
    return await remoteDataSource.getEvents(size: 10, segmentName: segmentName);
  }

  Future<List<EventModel>> searchEvents(String keyword) async {
    return await remoteDataSource.getEvents(keyword: keyword, size: 10);
  }

  Future<EventModel> getEventById(String id) async {
    return await remoteDataSource.getEventById(id);
  }

}