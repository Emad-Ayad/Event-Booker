import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../../../data/model/EventModel.dart';
import '../../../data/repo/HomeRepo.dart';

part 'event_state.dart';


class EventsCubit extends Cubit<EventsState> {
  final HomeRepo homeRepo;

  EventsCubit(this.homeRepo) : super(EventsInitial());

  Future<void> loadEvents() async {
    emit(EventsLoading());

    try {
      final result = await homeRepo.getAllEvents();
      emit(EventsLoaded(result));
    } catch (e) {
      emit(EventsError(e.toString()));
    }
  }
}