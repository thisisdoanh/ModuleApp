import '../../model/auth_token.dart';
import '../../model/login_request.dart';

abstract class AuthNetworkDataSource {
  Future<AuthToken> login(LoginRequest request);
  Future<AuthToken> refreshToken(String refreshToken);
  Future<void> logout(String accessToken);
}
