import '../datasource/local/auth_local_datasource.dart';
import '../datasource/network/auth_network_datasource.dart';
import '../model/auth_token.dart';
import '../model/login_request.dart';
import 'auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl(this._network, this._local);

  final AuthNetworkDataSource _network;
  final AuthLocalDataSource _local;

  @override
  Future<AuthToken> login(String username, String password) async {
    final token = await _network.login(
      LoginRequest(username: username, password: password),
    );
    await _local.saveToken(
      accessToken: token.accessToken,
      refreshToken: token.refreshToken,
      userId: token.userId,
      username: token.username,
      expiresAt: token.expiresAt,
    );
    return token;
  }

  @override
  Future<void> logout() async {
    final accessToken = await _local.getAccessToken();
    if (accessToken != null) await _network.logout(accessToken);
    await _local.clearToken();
  }

  @override
  Future<AuthToken> refreshToken() async {
    final refreshToken = await _local.getRefreshToken();
    if (refreshToken == null) throw Exception('No refresh token available');

    final newToken = await _network.refreshToken(refreshToken);
    await _local.saveToken(
      accessToken: newToken.accessToken,
      refreshToken: newToken.refreshToken,
      userId: newToken.userId,
      username: newToken.username,
      expiresAt: newToken.expiresAt,
    );
    return newToken;
  }

  @override
  Future<String?> getAccessToken() => _local.getAccessToken();

  @override
  Future<String?> getUserId() => _local.getUserId();

  @override
  Future<bool> isLoggedIn() => _local.isLoggedIn();

  @override
  Future<bool> isTokenExpired() => _local.isTokenExpired();
}
