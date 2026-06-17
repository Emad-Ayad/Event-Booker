part of 'home_cubit.dart';

@immutable
sealed class HomeState {}

final class HomeInitial extends HomeState {}


class HomeLoading extends HomeState {}

class HomeLoaded extends HomeState {
  final List<CategoryModel> categories;
  final List<EventModel> upcomingEvents;
  final List<EventModel> nearbyEvents;
  final String? selectedCategory;
  final bool isFilterLoading;

  HomeLoaded({
    required this.categories,
    required this.upcomingEvents,
    required this.nearbyEvents,
    this.selectedCategory,
    this.isFilterLoading = false,
  });
}

class HomeError extends HomeState {
  final String message;

  HomeError(this.message);
}
