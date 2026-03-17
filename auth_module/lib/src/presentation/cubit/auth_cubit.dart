import 'package:dependency/dependency.dart';

import '../../data/repository/auth_repository.dart';
import 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit(this._repository) : super(const AuthState.initial());

  final AuthRepository _repository;

  Future<void> login(String username, String password) async {
    emit(const AuthState.loading());
    try {
      final token = await _repository.login(username, password);
      emit(AuthState.authenticated(
        userId: token.userId,
        username: token.username,
        accessToken: token.accessToken,
      ));
    } catch (e) {
      emit(AuthState.failure(message: e.toString()));
    }
  }

  Future<void> logout() async {
    emit(const AuthState.loading());
    try {
      await _repository.logout();
    } catch (_) {
      await _repository.logout();
    }
    emit(const AuthState.unauthenticated());
  }

  Future<void> checkAuthStatus() async {
    emit(const AuthState.loading());
    try {
      final isLoggedIn = await _repository.isLoggedIn();
      if (!isLoggedIn) {
        emit(const AuthState.unauthenticated());
        return;
      }

      final isExpired = await _repository.isTokenExpired();
      if (isExpired) {
        try {
          final token = await _repository.refreshToken();
          emit(AuthState.authenticated(
            userId: token.userId,
            username: token.username,
            accessToken: token.accessToken,
          ));
          return;
        } catch (_) {
          emit(const AuthState.unauthenticated());
          return;
        }
      }

      final accessToken = await _repository.getAccessToken();
      final userId = await _repository.getUserId();
      emit(AuthState.authenticated(
        userId: userId ?? '',
        username: '',
        accessToken: accessToken ?? '',
      ));
    } catch (e) {
      emit(AuthState.failure(message: e.toString()));
    }
  }

  Future<void> refreshToken() async {
    try {
      final token = await _repository.refreshToken();
      emit(AuthState.authenticated(
        userId: token.userId,
        username: token.username,
        accessToken: token.accessToken,
      ));
    } catch (_) {
      emit(const AuthState.unauthenticated());
    }
  }
}
