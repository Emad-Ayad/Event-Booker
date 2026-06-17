import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../../../data/repo/SessionRepository.dart';

part 'splash_state.dart';

class SplashCubit extends Cubit<SplashState> {
  final SessionRepository sessionRepository;

  SplashCubit(this.sessionRepository) : super(SplashInitial());

  Future<void> checkLoginStatus() async {
    final isLoggedIn = await sessionRepository.isLoggedIn();

    if (isLoggedIn) {
      emit(SplashAuth());
    } else {
      emit(SplashUnauth());
    }
  }

}
