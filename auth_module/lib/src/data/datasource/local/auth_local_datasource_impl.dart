import 'package:dependency/dependency.dart';

import 'auth_local_datasource.dart';

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  AuthLocalDataSourceImpl(this._storage);

  final FlutterSecureStorage _storage;

  static const _keyAccessToken = 'auth_access_token';
  static const _keyRefreshToken = 'auth_refresh_token';
  static const _keyExpiresAt = 'auth_expires_at';
  static const _keyUserId = 'auth_user_id';
  static const _keyUsername = 'auth_username';

  @override
  Future<void> saveToken({
    required String accessToken,
    required String refreshToken,
    required String userId,
    required String username,
    required DateTime expiresAt,
  }) =>
      Future.wait([
        _storage.write(key: _keyAccessToken, value: accessToken),
        _storage.write(key: _keyRefreshToken, value: refreshToken),
        _storage.write(key: _keyUserId, value: userId),
        _storage.write(key: _keyUsername, value: username),
        _storage.write(key: _keyExpiresAt, value: expiresAt.toIso8601String()),
      ]);

  @override
  Future<String?> getAccessToken() => _storage.read(key: _keyAccessToken);

  @override
  Future<String?> getRefreshToken() => _storage.read(key: _keyRefreshToken);

  @override
  Future<String?> getUserId() => _storage.read(key: _keyUserId);

  @override
  Future<DateTime?> getExpiresAt() async {
    final value = await _storage.read(key: _keyExpiresAt);
    return value != null ? DateTime.parse(value) : null;
  }

  @override
  Future<void> clearToken() => Future.wait([
        _storage.delete(key: _keyAccessToken),
        _storage.delete(key: _keyRefreshToken),
        _storage.delete(key: _keyExpiresAt),
        _storage.delete(key: _keyUserId),
        _storage.delete(key: _keyUsername),
      ]);

  @override
  Future<bool> isLoggedIn() async {
    final token = await getAccessToken();
    if (token == null || token.isEmpty) return false;
    return !(await isTokenExpired());
  }

  @override
  Future<bool> isTokenExpired() async {
    final expiresAt = await getExpiresAt();
    if (expiresAt == null) return true;
    return DateTime.now().isAfter(expiresAt);
  }
}
