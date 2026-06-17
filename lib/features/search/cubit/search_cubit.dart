import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../../../data/model/EventModel.dart';
import '../../../data/repo/HomeRepo.dart';

part 'search_state.dart';


class SearchCubit extends Cubit<SearchState> {
  final HomeRepo homeRepo;
  Timer? _debounce;

  SearchCubit(this.homeRepo) : super(SearchInitial());

  void onQueryChanged(String query) {
    final trimmedQuery = query.trim();

    if (trimmedQuery.isEmpty) {
      _debounce?.cancel();
      emit(SearchInitial());
      return;
    }

    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      search(trimmedQuery);
    });
  }

  Future<void> search(String keyword) async {
    emit(SearchLoading(keyword));

    try {
      final data = await homeRepo.searchEvents(keyword);
      emit(
        SearchLoaded(
          query: keyword,
          results: data,
        ),
      );
    } catch (e) {
      emit(
        SearchError(
          query: keyword,
          message: e.toString(),
        ),
      );
    }
  }

  @override
  Future<void> close() {
    _debounce?.cancel();
    return super.close();
  }
}