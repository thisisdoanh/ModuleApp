import 'package:dependency/dependency.dart';

part 'auth_state.freezed.dart';

@freezed
class AuthState with _$AuthState {
  /// Initial state before any auth check
  const factory AuthState.initial() = AuthInitial;

  /// Checking auth status or logging in
  const factory AuthState.loading() = AuthLoading;

  /// User is authenticated with valid token
  const factory AuthState.authenticated({
    required String userId,
    required String username,
    required String accessToken,
  }) = AuthAuthenticated;

  /// User is not authenticated
  const factory AuthState.unauthenticated() = AuthUnauthenticated;

  /// Auth operation failed
  const factory AuthState.failure({required String message}) = AuthFailure;
}
