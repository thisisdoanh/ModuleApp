import 'package:dependency/dependency.dart';

import '../../data/repository/home_repository.dart';
import 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit(this._repository) : super(const HomeState.initial());

  final HomeRepository _repository;

  Future<void> loadProfile(String userId) async {
    emit(const HomeState.loading());
    try {
      final profile = await _repository.getUserProfile(userId);
      emit(HomeState.loaded(profile: profile, currentTabIndex: 0));
    } catch (e) {
      emit(HomeState.error(message: e.toString()));
    }
  }

  void changeTab(int tabIndex) {
    final current = state;
    if (current is HomeLoaded) {
      emit(HomeState.loaded(
        profile: current.profile,
        currentTabIndex: tabIndex,
      ));
    }
  }

  Future<void> refresh() async {
    final current = state;
    if (current is HomeLoaded) {
      await loadProfile(current.profile.userId);
    }
  }
}
