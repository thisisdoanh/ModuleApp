import 'package:app_networking/app_networking.dart';
import 'package:dependency/dependency.dart';

import '../../model/auth_token.dart';
import '../../model/login_request.dart';
import 'auth_network_datasource.dart';

class AuthNetworkDataSourceImpl implements AuthNetworkDataSource {
  AuthNetworkDataSourceImpl(this._apiClient);

  final ApiHandler _apiClient;

  @override
  Future<AuthToken> login(LoginRequest request) async {
    final response = await _apiClient.post<AuthToken>(
      UrlEndPoint.auth.login,
      parser: AuthToken.fromJson,
      body: request.toJson(),
    );
    if (response.data == null) throw Exception('Login failed: empty response');
    return response.data!;
  }

  @override
  Future<AuthToken> refreshToken(String refreshToken) async {
    final response = await _apiClient.post<AuthToken>(
      UrlEndPoint.auth.refreshToken,
      parser: AuthToken.fromJson,
      body: {'refresh_token': refreshToken},
    );
    if (response.data == null) {
      throw Exception('Refresh token failed: empty response');
    }
    return response.data!;
  }

  @override
  Future<void> logout(String accessToken) async {
    await _apiClient.post<void>(
      UrlEndPoint.auth.logout,
      parser: (_) {},
      options: Options(headers: {'Authorization': 'Bearer $accessToken'}),
    );
  }
}
