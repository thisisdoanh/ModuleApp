import '../model/auth_token.dart';

abstract class AuthRepository {
  /// Login with username and password, returns AuthToken
  Future<AuthToken> login(String username, String password);

  /// Logout and clear local tokens
  Future<void> logout();

  /// Refresh the access token using refresh token
  Future<AuthToken> refreshToken();

  /// Get stored access token
  Future<String?> getAccessToken();

  /// Get stored user ID
  Future<String?> getUserId();

  /// Check if user is currently logged in with valid token
  Future<bool> isLoggedIn();

  /// Check if access token needs refresh
  Future<bool> isTokenExpired();
}
