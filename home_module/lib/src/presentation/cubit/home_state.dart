import 'package:common_ui/common_ui.dart';
import 'package:dependency/dependency.dart';

import '../../data/model/user_profile.dart';

part 'home_state.freezed.dart';

@freezed
abstract class HomeState extends BaseState with _$HomeState {
  const HomeState._();

  const factory HomeState.initial() = HomeInitial;
  const factory HomeState.loading() = HomeLoading;
  const factory HomeState.loaded({
    required UserProfile profile,
    required int currentTabIndex,
  }) = HomeLoaded;
  const factory HomeState.error({required String message}) = HomeError;

  @override
  BaseStatus get status => maybeWhen(
        loading: () => BaseStatus.loading,
        loaded: (_, __) => BaseStatus.success,
        error: (_) => BaseStatus.failure,
        orElse: () => BaseStatus.initial,
      );

  @override
  String? get errorMessage => maybeWhen(
        error: (message) => message,
        orElse: () => null,
      );
}
