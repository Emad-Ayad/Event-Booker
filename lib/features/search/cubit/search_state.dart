part of 'search_cubit.dart';

@immutable
sealed class SearchState {}

final class SearchInitial extends SearchState {}


class SearchLoading extends SearchState {
  final String query;

  SearchLoading(this.query);
}

class SearchLoaded extends SearchState {
  final String query;
  final List<EventModel> results;

  SearchLoaded({
    required this.query,
    required this.results,
  });
}

class SearchError extends SearchState {
  final String query;
  final String message;

  SearchError({
    required this.query,
    required this.message,
  });
}
