import 'package:common_ui/common_ui.dart';

import '../../data/repository/auth_repository.dart';
import 'auth_state.dart';

class AuthCubit extends BaseCubit<AuthState> {
  AuthCubit(this._repository) : super(const AuthState.initial());

  final AuthRepository _repository;

  @override
  Future<void> load() => checkAuthStatus();

  Future<void> login(String username, String password) async {
    safeEmit(const AuthState.loading());
    try {
      final token = await _repository.login(username, password);
      safeEmit(AuthState.authenticated(
        userId: token.userId,
        username: token.username,
        accessToken: token.accessToken,
      ));
    } catch (e) {
      safeEmit(AuthState.failure(message: e.toString()));
    }
  }

  Future<void> logout() async {
    safeEmit(const AuthState.loading());
    try {
      await _repository.logout();
    } catch (_) {
      await _repository.logout();
    }
    safeEmit(const AuthState.unauthenticated());
  }

  Future<void> checkAuthStatus() async {
    safeEmit(const AuthState.loading());
    try {
      final isLoggedIn = await _repository.isLoggedIn();
      if (!isLoggedIn) {
        safeEmit(const AuthState.unauthenticated());
        return;
      }
      final isExpired = await _repository.isTokenExpired();
      if (isExpired) {
        try {
          final token = await _repository.refreshToken();
          safeEmit(AuthState.authenticated(
            userId: token.userId,
            username: token.username,
            accessToken: token.accessToken,
          ));
          return;
        } catch (_) {
          safeEmit(const AuthState.unauthenticated());
          return;
        }
      }
      final accessToken = await _repository.getAccessToken();
      final userId = await _repository.getUserId();
      safeEmit(AuthState.authenticated(
        userId: userId ?? '',
        username: '',
        accessToken: accessToken ?? '',
      ));
    } catch (e) {
      safeEmit(AuthState.failure(message: e.toString()));
    }
  }

  Future<void> refreshToken() async {
    try {
      final token = await _repository.refreshToken();
      safeEmit(AuthState.authenticated(
        userId: token.userId,
        username: token.username,
        accessToken: token.accessToken,
      ));
    } catch (_) {
      safeEmit(const AuthState.unauthenticated());
    }
  }
}
