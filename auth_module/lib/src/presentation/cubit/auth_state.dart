import 'package:common_ui/common_ui.dart';
import 'package:dependency/dependency.dart';

part 'auth_state.freezed.dart';

@freezed
abstract class AuthState extends BaseState with _$AuthState {
  const AuthState._();

  const factory AuthState.initial() = AuthInitial;
  const factory AuthState.loading() = AuthLoading;
  const factory AuthState.authenticated({
    required String userId,
    required String username,
    required String accessToken,
  }) = AuthAuthenticated;
  const factory AuthState.unauthenticated() = AuthUnauthenticated;
  const factory AuthState.failure({required String message}) = AuthFailure;

  @override
  BaseStatus get status => maybeWhen(
        loading: () => BaseStatus.loading,
        authenticated: (_, __, ___) => BaseStatus.success,
        failure: (_) => BaseStatus.failure,
        orElse: () => BaseStatus.initial,
      );

  @override
  String? get errorMessage => maybeWhen(
        failure: (message) => message,
        orElse: () => null,
      );
}
