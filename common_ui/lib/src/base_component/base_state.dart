import '../enum/base_status.dart';

/// Base class for all Cubit states in the monorepo.
///
/// All module states (defined with @freezed) should extend or
/// conceptually follow this contract — they represent a UI state snapshot.
abstract class BaseState {
  const BaseState({this.status = BaseStatus.initial, this.errorMessage});

  final BaseStatus status;
  final String? errorMessage;
}

extension BaseStateCopyWith on BaseState {
  bool get isLoading => status == BaseStatus.loading;

  bool get hasError =>
      errorMessage != null && errorMessage!.isNotEmpty && status == BaseStatus.failure;

  bool get isSuccess => status == BaseStatus.success;

  bool get isInitial => status == BaseStatus.initial;

  bool get isFailure => status == BaseStatus.failure;
}
