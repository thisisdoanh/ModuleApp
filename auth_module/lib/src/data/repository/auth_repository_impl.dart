import '../datasource/auth_remote_datasource.dart';
import '../model/auth_token.dart';
import '../model/login_request.dart';
import '../../service/token_service.dart';
import 'auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource _remoteDataSource;
  final TokenService _tokenService;

  AuthRepositoryImpl(this._remoteDataSource, this._tokenService);

  @override
  Future<AuthToken> login(String username, String password) async {
    final request = LoginRequest(username: username, password: password);
    final token = await _remoteDataSource.login(request);
    await _tokenService.saveToken(
      token.accessToken,
      token.refreshToken,
      token.userId,
      token.username,
      token.expiresAt,
    );
    return token;
  }

  @override
  Future<void> logout() async {
    final accessToken = await _tokenService.getAccessToken();
    if (accessToken != null) {
      await _remoteDataSource.logout(accessToken);
    }
    await _tokenService.clearTokens();
  }

  @override
  Future<AuthToken> refreshToken() async {
    final refreshToken = await _tokenService.getRefreshToken();
    if (refreshToken == null) throw Exception('No refresh token available');

    final newToken = await _remoteDataSource.refreshToken(refreshToken);
    await _tokenService.saveToken(
      newToken.accessToken,
      newToken.refreshToken,
      newToken.userId,
      newToken.username,
      newToken.expiresAt,
    );
    return newToken;
  }

  @override
  Future<String?> getAccessToken() => _tokenService.getAccessToken();

  @override
  Future<String?> getUserId() => _tokenService.getUserId();

  @override
  Future<bool> isLoggedIn() => _tokenService.isLoggedIn();

  @override
  Future<bool> isTokenExpired() => _tokenService.isTokenExpired();
}
