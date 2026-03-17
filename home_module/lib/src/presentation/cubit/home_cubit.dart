import 'package:common_ui/common_ui.dart';

import '../../data/repository/home_repository.dart';
import 'home_state.dart';

class HomeCubit extends BaseCubit<HomeState> {
  HomeCubit(this._repository) : super(const HomeState.initial());

  final HomeRepository _repository;

  @override
  Future<void> load() => refresh();

  Future<void> loadProfile(String userId) async {
    safeEmit(const HomeState.loading());
    try {
      final profile = await _repository.getUserProfile(userId);
      safeEmit(HomeState.loaded(profile: profile, currentTabIndex: 0));
    } catch (e) {
      safeEmit(HomeState.error(message: e.toString()));
    }
  }

  void changeTab(int tabIndex) {
    final current = state;
    if (current is HomeLoaded) {
      safeEmit(HomeState.loaded(
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
