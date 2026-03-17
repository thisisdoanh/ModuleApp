import 'package:app_networking/src/extension/string_extension.dart';
import 'package:app_networking/src/token/token_provider.dart';
import 'package:dependency/dependency.dart';

class AuthInterceptor extends QueuedInterceptor {
  AuthInterceptor(this._tokenProvider);

  final TokenProvider _tokenProvider;

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final token = _tokenProvider.token;
    if (token.accessToken.isNotNullOrEmpty) {
      options.headers['Authorization'] = 'Bearer ${token.accessToken}';
    }
    options.headers['Content-Type'] = 'application/json';
    return super.onRequest(options, handler);
  }
}
