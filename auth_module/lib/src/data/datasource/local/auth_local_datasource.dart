/// Local datasource contract for auth token persistence via FlutterSecureStorage.
abstract class AuthLocalDataSource {
  Future<void> saveToken({
    required String accessToken,
    required String refreshToken,
    required String userId,
    required String username,
    required DateTime expiresAt,
  });

  Future<String?> getAccessToken();
  Future<String?> getRefreshToken();
  Future<String?> getUserId();
  Future<DateTime?> getExpiresAt();
  Future<void> clearToken();

  Future<bool> isLoggedIn();
  Future<bool> isTokenExpired();
}
