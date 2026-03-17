import '../enum/base_status.dart';

abstract class BaseState {
  const BaseState();

  BaseStatus get status => BaseStatus.initial;
  String? get errorMessage => null;

  bool get isLoading => status == BaseStatus.loading;
  bool get isSuccess => status == BaseStatus.success;
  bool get isFailure => status == BaseStatus.failure;
  bool get isInitial => status == BaseStatus.initial;
  bool get hasError => isFailure && errorMessage != null && errorMessage!.isNotEmpty;
}
