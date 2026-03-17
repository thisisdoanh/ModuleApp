/// Manages token persistence in secure storage
abstract class TokenService {
  /// Save full auth token to secure storage
  Future<void> saveToken(String accessToken, String refreshToken,
      String userId, String username, DateTime expiresAt);

  /// Get the stored access token
  Future<String?> getAccessToken();

  /// Get the stored refresh token
  Future<String?> getRefreshToken();

  /// Get the token expiry time
  Future<DateTime?> getExpiresAt();

  /// Get stored user ID
  Future<String?> getUserId();

  /// Clear all stored tokens (on logout)
  Future<void> clearTokens();

  /// Check if user is logged in (has valid access token)
  Future<bool> isLoggedIn();

  /// Check if the access token is expired
  Future<bool> isTokenExpired();
}
