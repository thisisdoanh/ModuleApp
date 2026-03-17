import 'package:dependency/dependency.dart';
import '../model/auth_token.dart';
import '../model/login_request.dart';

abstract class AuthRemoteDataSource {
  Future<AuthToken> login(LoginRequest request);
  Future<AuthToken> refreshToken(String refreshToken);
  Future<void> logout(String accessToken);
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final Dio _dio;

  AuthRemoteDataSourceImpl(this._dio);

  @override
  Future<AuthToken> login(LoginRequest request) async {
    try {
      final response = await _dio.post(
        '/api/auth/login',
        data: request.toJson(),
      );
      final data = response.data as Map<String, dynamic>;
      return AuthToken(
        accessToken: data['access_token'] as String,
        refreshToken: data['refresh_token'] as String,
        userId: data['user_id'] as String,
        username: data['username'] as String,
        expiresAt: DateTime.parse(data['expires_at'] as String),
      );
    } on DioException catch (e) {
      throw Exception('Login failed: ${e.response?.data ?? e.message}');
    }
  }

  @override
  Future<AuthToken> refreshToken(String refreshToken) async {
    try {
      final response = await _dio.post(
        '/api/auth/refresh',
        data: {'refresh_token': refreshToken},
      );
      final data = response.data as Map<String, dynamic>;
      return AuthToken(
        accessToken: data['access_token'] as String,
        refreshToken: data['refresh_token'] as String,
        userId: data['user_id'] as String,
        username: data['username'] as String,
        expiresAt: DateTime.parse(data['expires_at'] as String),
      );
    } on DioException catch (e) {
      throw Exception('Refresh token failed: ${e.response?.data ?? e.message}');
    }
  }

  @override
  Future<void> logout(String accessToken) async {
    try {
      await _dio.post(
        '/api/auth/logout',
        options: Options(headers: {'Authorization': 'Bearer $accessToken'}),
      );
    } on DioException catch (e) {
      throw Exception('Logout failed: ${e.response?.data ?? e.message}');
    }
  }
}
