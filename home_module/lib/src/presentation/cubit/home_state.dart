import 'package:dependency/dependency.dart';

import '../../data/model/user_profile.dart';

part 'home_state.freezed.dart';

@freezed
class HomeState with _$HomeState {
  const factory HomeState.initial() = HomeInitial;

  const factory HomeState.loading() = HomeLoading;

  const factory HomeState.loaded({
    required UserProfile profile,
    required int currentTabIndex,
  }) = HomeLoaded;

  const factory HomeState.error({required String message}) = HomeError;
}
