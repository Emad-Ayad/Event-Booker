import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../../../data/model/CategoryModel.dart';
import '../../../data/model/EventModel.dart';
import '../../../data/repo/HomeRepo.dart';

part 'home_state.dart';


class HomeCubit extends Cubit<HomeState> {
  final HomeRepo homeRepo;

  HomeCubit(this.homeRepo) : super(HomeInitial());

  Future<void> loadHomeData() async {
    emit(HomeLoading());

    try {
      final data = await homeRepo.getHomeData();

      emit(
        HomeLoaded(
          categories: data.categories,
          upcomingEvents: data.upcomingEvents,
          nearbyEvents: data.nearbyEvents,
          selectedCategory: null,
        ),
      );
    } catch (e) {
      emit(HomeError(e.toString()));
    }
  }

  Future<void> onCategoryTapped(String title) async {
    if (state is! HomeLoaded) return;

    final currentState = state as HomeLoaded;
    final newSelection =
    currentState.selectedCategory == title ? null : title;

    emit(
      HomeLoaded(
        categories: currentState.categories,
        upcomingEvents: currentState.upcomingEvents,
        nearbyEvents: currentState.nearbyEvents,
        selectedCategory: newSelection,
        isFilterLoading: true,
      ),
    );

    try {
      if (newSelection == null) {
        final upcoming = await homeRepo.getUpcomingEvents();
        final nearby = await homeRepo.getNearbyEvents();

        emit(
          HomeLoaded(
            categories: currentState.categories,
            upcomingEvents: upcoming,
            nearbyEvents: nearby,
            selectedCategory: null,
            isFilterLoading: false,
          ),
        );
      } else {
        final filtered = await homeRepo.getEventsByCategory(newSelection);

        emit(
          HomeLoaded(
            categories: currentState.categories,
            upcomingEvents: filtered,
            nearbyEvents: filtered,
            selectedCategory: newSelection,
            isFilterLoading: false,
          ),
        );
      }
    } catch (e) {
      emit(HomeError(e.toString()));
    }
  }
}