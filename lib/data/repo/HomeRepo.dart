import 'package:flutter/material.dart';

import '../datasource/HomeRemoteDataSource.dart';
import '../model/CategoryModel.dart';
import '../model/EventModel.dart';
import '../model/HomeDataModel.dart';


class HomeRepo {
  final HomeRemoteDataSource remoteDataSource;

  HomeRepo(this.remoteDataSource);

  Future<List<EventModel>> getUpcomingEvents() async {
    return await remoteDataSource.getEvents(size: 10, page: 0);
  }

  Future<List<EventModel>> getNearbyEvents() async {
    return await remoteDataSource.getEvents(size: 10, page: 1);
  }

  Future<List<CategoryModel>> getCategories() async {
    final events = await remoteDataSource.getEvents(size: 20);

    final seen = <String>{};
    final categories = <CategoryModel>[];

    for (final event in events) {
      final category = event.name;
      if (category.isNotEmpty && !seen.contains(category)) {
        seen.add(category);
        categories.add(
          CategoryModel(
            title: category,
            color: _getCategoryColor(category),
            icon: _getCategoryIcon(category),
          ),
        );
      }
    }

    return categories;
  }

  Future<HomeDataModel> getHomeData() async {
    final categories = await getCategories();
    final upcomingEvents = await getUpcomingEvents();
    final nearbyEvents = await getNearbyEvents();

    return HomeDataModel(
      categories: categories,
      upcomingEvents: upcomingEvents,
      nearbyEvents: nearbyEvents,
    );
  }

  Color _getCategoryColor(String title) {
    switch (title.toLowerCase()) {
      case 'sports':
        return const Color(0xFFFF6B6B);
      case 'music':
        return const Color(0xFFFFA45B);
      case 'film':
        return const Color(0xFF35D39D);
      case 'arts & theatre':
        return const Color(0xFF5BC0FF);
      default:
        return const Color(0xFF5669FF);
    }
  }

  IconData _getCategoryIcon(String title) {
    switch (title.toLowerCase()) {
      case 'sports':
        return Icons.sports_basketball;
      case 'music':
        return Icons.music_note;
      case 'film':
        return Icons.movie;
      case 'arts & theatre':
        return Icons.palette;
      default:
        return Icons.category;
    }
  }
}