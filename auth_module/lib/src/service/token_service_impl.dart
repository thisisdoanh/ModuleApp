import 'package:dependency/dependency.dart';
import 'token_service.dart';

class TokenServiceImpl implements TokenService {
  final FlutterSecureStorage _secureStorage;

  static const _keyAccessToken = 'auth_access_token';
  static const _keyRefreshToken = 'auth_refresh_token';
  static const _keyExpiresAt = 'auth_expires_at';
  static const _keyUserId = 'auth_user_id';
  static const _keyUsername = 'auth_username';

  TokenServiceImpl(this._secureStorage);

  @override
  Future<void> saveToken(
    String accessToken,
    String refreshToken,
    String userId,
    String username,
    DateTime expiresAt,
  ) async {
    await Future.wait([
      _secureStorage.write(key: _keyAccessToken, value: accessToken),
      _secureStorage.write(key: _keyRefreshToken, value: refreshToken),
      _secureStorage.write(key: _keyUserId, value: userId),
      _secureStorage.write(key: _keyUsername, value: username),
      _secureStorage.write(
          key: _keyExpiresAt, value: expiresAt.toIso8601String()),
    ]);
  }

  @override
  Future<String?> getAccessToken() =>
      _secureStorage.read(key: _keyAccessToken);

  @override
  Future<String?> getRefreshToken() =>
      _secureStorage.read(key: _keyRefreshToken);

  @override
  Future<DateTime?> getExpiresAt() async {
    final value = await _secureStorage.read(key: _keyExpiresAt);
    return value != null ? DateTime.parse(value) : null;
  }

  @override
  Future<String?> getUserId() => _secureStorage.read(key: _keyUserId);

  @override
  Future<void> clearTokens() async {
    await Future.wait([
      _secureStorage.delete(key: _keyAccessToken),
      _secureStorage.delete(key: _keyRefreshToken),
      _secureStorage.delete(key: _keyExpiresAt),
      _secureStorage.delete(key: _keyUserId),
      _secureStorage.delete(key: _keyUsername),
    ]);
  }

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
